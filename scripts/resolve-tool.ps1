<#
.SYNOPSIS
  Print the checkout path of a pinned bannerlord-agent tool, cloning it if no checkout exists.

.DESCRIPTION
  Lookup order: the tool's env var, the tools/ submodule next to this script, the editing
  checkout at ./submodules/bannerlord-agent/tools/<name>, then ~/.bannerlord-agent/tools/<name>.
  When none exists, the tool is cloned into the last location at the commit in tools.lock.json.
  An existing checkout is never updated; a commit mismatch is reported as a warning.

  -Check verifies that every tools.lock.json commit matches the tools/ submodule pointer
  (run it in the editing checkout before tagging a release).

.EXAMPLE
  $env:BANNERLORD_NAVMESH_STUDIO = & apm_modules/JoeFwd/bannerlord-agent/scripts/resolve-tool.ps1 BannerlordSceneStudio
#>
param(
    [Parameter(Position = 0)][string]$Name,
    [switch]$Check
)
$ErrorActionPreference = 'Stop'
$env:GIT_TERMINAL_PROMPT = '0'
$env:GCM_INTERACTIVE = 'never'

$root = Split-Path $PSScriptRoot -Parent
$lock = Get-Content (Join-Path $root 'tools.lock.json') -Raw | ConvertFrom-Json

if ($Check) {
    $bad = 0
    foreach ($tool in $lock.PSObject.Properties) {
        $pointer = (git -C $root ls-files --stage "tools/$($tool.Name)") -split '\s+' | Select-Object -Index 1
        if ($pointer -ne $tool.Value.commit) {
            Write-Host "MISMATCH $($tool.Name): submodule $pointer, tools.lock.json $($tool.Value.commit)"
            $bad++
        }
    }
    if ($bad) { exit 1 }
    Write-Host 'tools.lock.json matches the tools/ submodules.'
    exit 0
}

$entry = $lock.$Name
if (-not $entry) { throw "Unknown tool '$Name'. Known: $($lock.PSObject.Properties.Name -join ', ')" }

function Test-Checkout([string]$path) {
    $path -and (Test-Path $path) -and (Get-ChildItem -Force $path | Select-Object -First 1)
}

$envPath = [Environment]::GetEnvironmentVariable($entry.env)
foreach ($candidate in @(
        $envPath,
        (Join-Path $root "tools/$Name"),
        (Join-Path (Get-Location) "submodules/bannerlord-agent/tools/$Name"))) {
    if (Test-Checkout $candidate) { (Resolve-Path $candidate).Path; exit 0 }
}

$dest = Join-Path $HOME ".bannerlord-agent/tools/$Name"
if (Test-Checkout $dest) {
    $head = git -C $dest rev-parse HEAD
    if ($head -ne $entry.commit) {
        Write-Warning "$dest is at $head, but this release pins $($entry.commit). Left unchanged."
    }
    $dest
    exit 0
}

[Console]::Error.WriteLine("Cloning $($entry.url) at $($entry.commit) into $dest")
git clone --quiet $entry.url $dest
if ($LASTEXITCODE) { throw "git clone failed for $($entry.url)" }
git -C $dest -c advice.detachedHead=false checkout --quiet $entry.commit
if ($LASTEXITCODE) { throw "Commit $($entry.commit) not found in $($entry.url)" }
$dest
