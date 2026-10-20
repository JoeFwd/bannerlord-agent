# Bannerlord Brain

One durable lesson per note. Grep `**/*.md` for a symptom, API or file name; browse by topic below.

## audio

- [[ws-psai-duplicate-ids-with-native-soundtrack]] (lesson): Keeping native music alongside a mod soundtrack crashes at startup when the mod reuses Native theme/segment ids with an empty ModuleIdPrefix.

## banners-heraldry

- [[banner-icon-atlas-editing]] (howto): Adding a banner charge means repainting a 512x512 tile in a ui atlas PSD; convention is green fill + RED stroke, padding is per-tile, and an unreferenced slot is not a free slot
- [[banner-key-format-and-32-layer-cap]] (reference): banner_key is 10 ints per layer; the 32-layer parse cap was removed in 1.4.7 but multiplayer still caps at 31; icon 505 covers only 88.3% of its Size box
- [[banner-party-palette-mismatch]] (lesson): bannerlord.party's palette parks duplicate swatches in the game palette's gaps; 8 ids are dead and render 0xDEADBEEF, and the remap is lossless and by hex

## campaign-ai

- [[army-creation-hourly-tick-lifo-shared-cache]] (lesson): AiHourlyTickEvent listeners run LIFO over one shared PartyThinkParams member cache, so a mod that creates armies from a listener can corrupt the cache; Kingdom.CreateArmy is the safe boundary.
- [[army-dispersal-noactivewar-check]] (lesson): Army.CheckArmyDispersion disbands armies at 25 percent per hour when the kingdom has no active war; armies created for non-war purposes need a patch.
- [[army-requires-kingdom-use-besiegercamp-setter]] (lesson): A Bannerlord Army with a null Kingdom crashes the player's encounter menu - kingdomless mod factions should put parties in a siege via the public MobileParty.BesiegerCamp setter, not Army
- [[behostileaction-escalates-to-kingdom-war]] (reference): BeHostileAction.ApplyEncounterHostileAction turns a player attack on a same-kingdom party into a kingdom war with -10 relation against the defending leader; EncounterModel.IsEncounterExemptFromHostileActions is the override seam.
- [[campaign-menu-without-wait-zeroes-ai-dt]] (lesson): In vanilla Campaign.Tick a game menu with !IsWaitActive sets _dt = 0 before TickPartialHourlyAi - the calendar keeps running but no party thinks, so armies abandon sieges and hold; park observers in a wait menu
- [[caravan-camel-icon-hardcoded]] (lesson): Vanilla CaravanPartyComponent hardcodes item id "camel" for aserai/khuzait-culture caravans; a mod that strips camels gets an NRE in MobilePartyVisual - fix by aliasing the item in XSLT, not C#
- [[constant-war-peace-loop]] (lesson): IsAtConstantWar short-circuits IsAtWarAgainstFaction before the StanceLink, so MakePeaceAction can never converge - classic infinite "X and Y have made peace" spam
- [[gathering-army-aibehaviorobject-not-target]] (lesson): A gathering Besieger Army's AiBehaviorObject is a gathering fortress, never the siege target, so "targets goal" tests are false while gathering; and vanilla Defender scoring pulls a whole kingdom onto same-kingdom sieges
- [[invasion-style-party-state-machine-observed]] (reference): Observed phase/threshold behaviour of a CustomSpawns-style invasion party (search, recon, approach, siege abandon at 1.5 strength ratio, cooldown).
- [[mapfaction-wall-blocks-same-kingdom-hostility]] (lesson): Two clans in the same kingdom cannot be at war in vanilla: MapFaction resolves them to one faction, so clan-pair StanceLinks are dead data.
- [[offspring-needs-child-equipment-roster-per-culture]] (lesson): DeliverOffSpring NREs in EquipmentHelper.AssignHeroEquipmentFromEquipment when no EquipmentRoster matches the hero's culture with flags exactly IsLordTemplate|IsChildEquipmentTemplate (+IsFemaleTemplate for girls)
- [[partycomponent-owner-must-be-own-leader]] (lesson): A custom PartyComponent whose party captures a fortification must return its OWN leader hero from PartyOwner (and SetCustomOwner), or ChangeOwnerOfSettlementAction NREs
- [[same-kingdom-mapevent-diplomatically-finished]] (lesson): Vanilla MapEvent.Update ends any battle whose leader parties' MapFactions are not at war (DiplomaticallyFinished, no winner) on its FIRST tick, so same-kingdom battles never resolve or score and the AI re-engages every tick
- [[vanilla-clan-defection-and-relation-drains]] (reference): Vanilla clan defection is a purchase (join+leave value x2 same culture, up to x2.5 when buyer weak, buyer pays up to half their gold) and relations are randomised at new game; sieges, captures and annexation votes drain relation without checking MapFaction
- [[vanilla-garrison-rebalance-on-enter]] (lesson): Vanilla GarrisonTroopsCampaignBehavior.OnSettlementEntered splits garrison men into any same-faction lord party entering a fortification, bypassing mod garrison floors
- [[vanilla-hostility-consumer-sites]] (reference): The list of vanilla code sites that decide whether two parties are enemies, and which are overridable models versus private or non-virtual code.

## campaign-map

- [[campaign-model-seams-for-encounters-and-access]] (reference): Public GameModel overrides that let a mod change encounters, settlement access and army creation without Harmony.
- [[clan-createclan-cadet-spinoff-recipe]] (howto): How to spin a runtime clan off an existing clan in 1.4: Clan.CreateClan, set leader, move the hero, and join the parent kingdom.
- [[herokilled-event-and-clan-leader-handover-race]] (lesson): On a hero death, vanilla's ChangeClanLeaderAction and your HeroKilledEvent handler run in unspecified order; never read Clan.Leader to find an heir.
- [[kingdom-decision-lifecycle]] (reference): How KingdomDecision objects are enqueued, cancelled and resolved, so a mod can add its own decision type.
- [[main-map-override-last-module-wins]] (reference): SandBox.MapScene.GetMainMapModule picks the last active module containing SceneObj/Main_map/scene.xscene.
- [[map-border-entities-bound-camera]] (reference): The campaign camera pan limits, zoom cap and MapDiagonal come from the border_min and border_max entities in the map scene, not from terrain size.
- [[map-settlement-position-two-files]] (howto): A campaign-map settlement's position lives in TWO places that must stay in sync - settlements.xml posX/posY (+gate_pos) and the map scene's settlement capsule parent transform; scene has no BOM, settlements.xml has one
- [[navmesh-river-must-match-terrain-and-mask]] (lesson): Moving river navmesh vertices only changes navigability; visible water and terrain paint come from the river mask, heightmap and river paths, so a bend change needs all of them in sync.
- [[settlement-component-types-no-custom-type]] (reference): Bannerlord 1.4.7 has only Town/Village/Hideout/Retirement SettlementComponents; a castle is Town is_castle="true"; a new settlement type needs C#
- [[settlement-gate-on-non-land-face-pathfinding-av]] (lesson): A native AccessViolation in GetPathBetweenAIFaceIndicesWithRegionSwitchCost during AI distance scoring means a settlement GATE sits on a non-land navmesh face (face index -1); scan Settlement.All for gate face < 0 and move the gate onto land
- [[settlement-nameplate-relation-ints]] (reference): The settlement nameplate relation integer: 0 default, 1 same faction, 2 war, 3 alliance (3 added in 1.4).
- [[settlement-owner-change-details]] (reference): The ChangeOwnerOfSettlementDetail values and what each means, for mods that react to ownership changes.
- [[settlement-scene-binding-by-wall-level]] (reference): Settlement to scene binding via Location scene_name / scene_name_1..3, selected by wall level, falling back to the first.
- [[settlement-shell-prefab-structure-rules]] (lesson): Town/castle prefab shells have a functional subtree (gates, siege anchors, breach) that must not be scaled, retagged or reordered.
- [[siege-vanilla-1-4-facts]] (reference): 1.4 SiegeEvent.Tick makes illegitimate besiegers leave, and ChangeOwnerOfSettlementAction destroys the garrison on BySiege.

## coop-multiplayer

- [[coop-replication-gotchas-for-content-mods]] (reference): What a content mod must expect from a campaign co-op layer: authority gates, exact-type tournament checks, puppet equipment re-rolls and usage-index sync.
- [[coop-server-docker-logs]] (reference): BannerlordCoop dedicated-server logs are Docker json-file logs (UTC, ANSI, wrapped lines) with no Serilog Debug output; convert before grepping
- [[coop-two-prefixes-on-one-method-ordering]] (lesson): When two mods prefix the same method, registration order decides whether a capture/replication prefix sees the call; use HarmonyPriority.

## crafting-items

- [[blade-mesh-origin-inflates-reach]] (lesson): Bannerlord crafted-weapon reach is computed from XML lengths/offsets, not mesh bounds - an off-origin blade mesh silently overstates reach
- [[crafted-weapon-stats-driven-by-weaponflags]] (reference): Bannerlord crafted-weapon speed/damage branch on WeaponDescription WeaponFlags, never on weapon_class; WideGrip without NotUsableWithOneHand is a data trap
- [[crafting-connector-offset-normalization-method]] (howto): Method for normalising crafting piece connectors across a template: seam sign, scale-weighted cancellation, fallback by removing UsablePieces.
- [[crafting-contact-profile-check]] (howto): Acceptance test for a Bannerlord blade/guard joint is the per-column contact percentage across the blade's base width, calibrated against healthy swords (88-100% @ 0.11-0.15 median gap)
- [[crafting-joint-gap-formula]] (lesson): Bannerlord crafting joint-gap formula, why mesh bounds/seam gaps lie about visible blade-guard gaps, and how to decide which piece owns an offset error
- [[crafting-offsets-are-scale-multiplied]] (lesson): BuildData offsets are multiplied by the CraftedItem's scale_factor, and a Pommel's piece_offset is positive-downward (away from the blade)
- [[crafting-piece-cannot-be-rotated-by-xml]] (reference): A crafting piece's orientation is 100% baked into its mesh - no XML attribute rotates it and the engine places every piece with Mat3.Identity
- [[crafting-template-order-and-icons]] (lesson): The crafting menu sorts templates by StringId (not XML order); icons key off StringId too, so renamed ids need cross-module GenericSprite aliases - with a silent load-order trap
- [[crafting-tool-uniform-scale-bug]] (lesson): Engine rule - non-full_scale crafting pieces scale on the length axis only (full_scale defaults true for Guard/Pommel); a crafting tool that scaled uniformly rendered laterally too fat (FIXED 2026-08-08)
- [[crafting-usage-vs-bench-list-rules]] (reference): Bannerlord crafting - UsablePieces drives the bench list, AvailablePieces drives which weapon usage is emitted; the two are independent, and saves bake in the design
- [[handle-length-drives-both-joints]] (lesson): A Handle's declared length moves the pommel AND guard attach points symmetrically (+/-length/2 about pivot), so length cannot fix one joint without breaking the other - use previous_piece_offset
- [[handle-piece-offset-semantics]] (lesson): For a shaft mesh centred on its origin, hand_to_bottom = length/2 - piece_offset; piece_offset == length/2 puts the hand on the butt and shoves the weapon forward
- [[precrafted-item-piece-must-be-in-template-usable-pieces]] (lesson): A pre-crafted item whose piece was removed from the template UsablePieces crashes CraftingOrder.InitializeCraftingOrderOnLoad at campaign start, not at the smithy.
- [[scabbard-anchored-to-blade-pivot]] (lesson): The holster follows the Blade pivot, so a blade seated too deep in the guard drags the scabbard over the cross; reseat by splitting distance_to_previous/next_piece (zero stat change), and never aim for seam == 0
- [[scabbard-holster-mesh-placement]] (reference): A crafted weapon's scabbard is the Blade piece's BladeData holster_mesh, placed at the Blade's own pivot (PiecePivotDistances[0]); two template flags suppress it; body placement and the quiver skeleton branch are unmodellable offline
- [[scabbard-length-families]] (lesson): Scabbard meshes come in fixed length families (about -32/-39/-52/-64 mouth offset); a misfit is the wrong mesh assigned - swap holster_mesh, never trim a shared mesh; colour variants share geometry; tpac names are lowercase
- [[scabbard-mouth-metric-pitfall]] (lesson): Scabbard fit needs TWO reference points - blade.MinY (does it sheathe the blade) and guard.MaxY (does the mouth meet the cross); either alone gives false verdicts and their disagreement is the real signal
- [[split-mesh-seam-is-ragged]] (howto): Splitting one mesh into two crafting pieces - mate halves at ORIGINAL positions (the seam ring is not flat), mirror BOTH halves, restore custom split normals or the seam shades as a hard band, and register the piece in both registries

## engine-runtime

- [[bannerlord-live-version]] (reference): Identify the installed game version from bin/Win64_Shipping_Client/Version.xml, not DLL metadata or ButterLib's log; verify APIs against shipped DLLs (install was v1.4.8 build 119303 on 2026-08-17)
- [[campaign-perf-measurement-method]] (howto): Howto - measure campaign-map frame cost with a temporary Harmony Stopwatch probe loaded through the debugger, and the pitfalls (inclusive times, warmup, drift, unmatched baselines).
- [[setphysicsstate-is-visibility-coupled]] (lesson): GameEntity.SetPhysicsState(false) hides the entity as well as disabling its rigid body - the native call drives both, and the managed override is empty so C# reading cannot reveal it

## gabs-debugging

- [[cdb-native-av-capture-method]] (howto): How to capture and read a native access violation in TaleWorlds.Native using cdbX64 without Rider, including the non-invasive sampling variant.
- [[clr-exception-breakpoints-needed-to-catch-silent-death]] (howto): Without CLR exception breakpoints a managed crash in Bannerlord leaves no dump and no log; set them (and a stop-on-first-chance AV capture for native faults).
- [[dead-game-looks-like-unhit-breakpoint]] (lesson): A dead game looks exactly like a breakpoint that has not fired; poll Get-Process/games_status/debug session at least every 60s during any wait, and collect death evidence once the process is gone.
- [[debugger-pause-kills-gabp-game]] (lesson): Pausing Bannerlord in a JetBrains debugger for more than ~30s while GABS is connected makes the game exit silently on resume; GABS also deletes bridge.json on disconnect
- [[evaluate-in-debugger-without-freezing-the-game]] (lesson): Never put logging breakpoints (or {this} log messages) on per-frame paths; let the battle run, then take snapshots from a throttled once-per-second main-thread anchor and check Mission.Current.CurrentTime advanced
- [[gabs-load-save-forbidden]] (lesson): Never use the GABS core/load_save tool - from a running campaign it hung the loading screen forever; load saves through the in-game Load Game menu
- [[gabs-on-1-4-7]] (howto): GABS/GABP works on Bannerlord 1.4.7 with the stock v1.3.13 DLL once MCM and UIExtenderEx are installed and module order is right; old per-version path tables are outdated
- [[gabs-start-launches-wrong-install]] (lesson): A GABS games_start pointed at an obsolete install produced a phantom "crash on save load" defect; the MCP server caches config at startup, and a pinned port means no bridge.json is written
- [[gabs-ui-driving-traps]] (reference): Small GABS UI-driving traps: arguments key name, save-list widgets, crafting-screen saves, click_widget exceptions, missing MCM.
- [[resuming-from-first-chance-exception-kills-process]] (lesson): Resuming after a paused vanilla first-chance NRE (NavalDLC, PatrolParty) can silently kill the game, so inspect and stop instead.
- [[rider-breakpoint-condition-no-ampersand]] (howto): In Rider conditional breakpoints `&&` is parsed as a format specifier; use null-conditional operators instead, and find bad XML with a conditional breakpoint in LoadXml.
- [[rider-eval-pause-looks-like-hang]] (lesson): A debugger pause (breakpoint, first-chance exception, eval) stops the whole game process and makes GABS calls time out, which looks exactly like a hang.

## harmony-patching

- [[early-patching-encounter-menu-behavior-static-ctor]] (incident): Patching EncounterGameMenuBehavior members during OnSubModuleLoad forces its static constructor, which calls GameTexts.FindText before it is initialised, giving a TypeInitializationException on save load.
- [[harmony-patch-failure-kills-game-silently]] (lesson): An exception while applying a Harmony patch in OnSubModuleLoad (e.g. AmbiguousMatchException from AccessTools.Method on an overloaded method) exits Bannerlord with no log, dump or debugger pause; test patches offline first

## meshes-textures-assets

- [[banner-icon-psd-autoimport]] (lesson): Bannerlord's asset watcher rebuilds ui _tex.tpac AND the RuntimeDataCache .rdc within seconds of a PSD write, so a one-tile edit is a 3-file commit and the .rdc is raw RGBA you can diff
- [[blender-fbx-roundtrip-breaks-scale]] (lesson): Blender FBX export silently rescales Bannerlord meshes 100x in game unless apply_scale_options is FBX_SCALE_ALL/UNITS; the importer applies Lcl Scaling and ignores UnitScaleFactor; audit/render tools cannot detect either failure
- [[cannonball-pile-white-is-ao-coef]] (lesson): Washed-out white spheres on a stone_pile_deformer material trace to the Ambient Occlusion Coef, not the diffuse/specular textures
- [[fbx-edits-need-tpac-reimport]] (lesson): Editing a source FBX changes tool renders at once but the game loads the compiled _geo.tpac - re-import through the Modding Kit before trusting in-game results; shipped tpacs can be mirrored vs their FBX
- [[fbx-reexport-must-preserve-material-names]] (incident): A Blender FBX re-export renamed materials (wood -> wood.001); restore exact material names and slot mapping or the compiled asset changes.
- [[invisible-mesh-is-scale-not-shader]] (lesson): A mesh that renders in the modding tool but is invisible in game is usually millimetre-scale; measure the compiled tpac bbox (LZ4-compressed geometry) first, and fix via meta_mesh_component scale
- [[material-without-use-specular-looks-matte]] (lesson): A material whose saved flags omit use_specular samples no specular map, so identical textures still look matte; metallic versus standard workflow also changes reflection.
- [[reimport-keeps-second-material]] (lesson): Modding Tools FBX reimport rebinds the primary material (slot 1) by FBX name but keeps the stale SecondMaterial (slot 2) GUID; audit slots separately and judge "white mesh" from slot 1
- [[tpac-material-binding-trailer]] (lesson): A mesh's material binding is a length-prefixed name in the _geo.tpac trailer; "default" means no material was bound and the mesh renders flat grey - fix it in the Modding Tools, never by binary patching

## missions-battles

- [[formation-detachments-includes-strategicareas]] (lesson): Formation.Detachments is not a machine list - ArrangementOrder.TickOccasionally keeps joining every StrategicArea near the formation's OrderPosition, so sizing a crew pool off Detachments.Count runs away
- [[formation-transferunits-selective-pop-uses-stale-orderposition]] (lesson): Formation.TransferUnits with useSelectivePop pops the units nearest the TARGET formation's OrderPosition, and an empty target's order position is stale-copied from the source on first transfer
- [[lordshall-defender-slots-filtered-by-navmesh]] (reference): In the lord's-hall siege mission, archer spawn helpers are kept only if on an enabled navmesh face, and SpawnTroops dereferences the chosen slot with no null check.

## modding-tools-editor

- [[animation-clip-rename-breaks-resources]] (lesson): Renaming a freshly authored animation clip in the Modding Kit (1.4.8) produced invalid resource resolution and unusable caches; keep the autogenerated clip name.
- [[bannerlord-source-mcp-1_4_6-workaround]] (howto): When several Bannerlord source-search MCP servers (one per game version) are configured but only the oldest registers as a tool, reach the others by POSTing JSON-RPC straight to their port
- [[navmesh-studio-tool]] (reference): The user's navmesh studio (env BANNERLORD_NAVMESH_STUDIO) - read/edit/generate suite for any scene navmesh.bin; usage, limits (terrain-only generate, no weld, GUI cannot add faces) and launch gotcha
- [[submodule-source-recovery-by-decompile-diff]] (howto): How to recover and verify lost C# source from deployed DLLs - ilspycmd -p, then diff decompile-vs-decompile of the live build to cancel decompiler noise; grep binaries case-insensitively

## navmesh

- [[campaign-navmesh-river-lake-conventions]] (reference): How vanilla Main_map navmesh models rivers, lakes, fords and sea: quad ladders, terrain-following +0.4 m, no transition type.
- [[campaign-navmesh-terrain-type-ids]] (reference): Campaign map navmesh g3 terrain-type enum (1 Plain ... 25 UnderBridge) and code facts about water types.
- [[campaign-position-is-vec2-plus-onland-flag]] (reference): CampaignVec2 stores a Vec2 plus an IsOnLand flag and selects the navmesh face by that flag, so land and water layers may overlap in 2D.
- [[lz4-reencode-not-byte-identical]] (lesson): A navmesh or terrain file recompressed with a different LZ4 encoder decompresses identically but differs byte for byte, so byte-compare payloads, not files.
- [[navmesh-bridge-deck-over-water-construction]] (reference): How a campaign-map bridge is modelled in navmesh - a terrain-1 convex quad deck laid over retained river/underbridge water faces, with an intentional 0.17 m vertical split.
- [[navmesh-bridge-two-bank-route-gate]] (howto): Howto - prove a bridge deck is usable by walking the passable-face graph from the deck to land on both banks, using the terrain ids the real party navigation model accepts.
- [[navmesh-duplicate-corner-face-crash]] (lesson): A navmesh face whose corner list repeats a vertex (zero-area quad) leaves a NULL link slot and the native loader AVs at Native+0x4140D7; the repair is uniquely determined by the orphaned edges
- [[navmesh-editor-runtime-acceptance-checklist]] (howto): Editor/runtime checks to run on a modified campaign navmesh before calling it accepted; static audits are not a substitute.
- [[navmesh-face-field-meanings-g1-g6]] (reference): What each navmesh face field means: g1/g2/g4 constants, g3 face id or terrain type, g5 scene-level mask, g6 flag.
- [[navmesh-faces-must-be-tris-or-quads]] (lesson): Bannerlord navmesh faces may only have 3 or 4 vertices; an n-gon parses fine offline but crashes the game natively during navmesh load, before "NAV_MESH: load finished
- [[navmesh-fragmentation-is-not-a-crash-cause]] (reference): A valid navmesh can still be heavily fragmented (many tiny islands) - a pathfinding quality concern, not a crash cause; benchmark component counts against peers and vanilla
- [[navmesh-g3-differs-campaign-vs-scene]] (lesson): g3 is a dynamic face id in scene navmeshes but a terrain-type enum in the campaign Main_map navmesh.
- [[navmesh-g5-level-bits-must-cover-all-castle-levels]] (lesson): Siege navmesh connector faces tagged with only level_1 vanish at castle level 2/3 and shatter the sheet into unreachable islands; sweep for faces with siege but not all level bits
- [[navmesh-g5-scene-level-mask-not-island]] (lesson): g5 is a signed scene-level visibility bitmask (base/level_1..3/civilian/siege/looted), not an island or group id.
- [[navmesh-level-mask-must-match-mission-mask]] (lesson): A mission loads only navmesh faces whose g5 level bits match the mission mask; a scene whose faces lack the siege bit loads one face and every query returns -1.
- [[navmesh-load-validation-checklist]] (howto): Howto - offline integrity checks to run on a navmesh.bin before deploying (header sizes, face arity, edge ownership, isolated vertices, round trip, water components, SHA backups).
- [[navmesh-presence-probe-in-rider]] (howto): Only Scene.GetNavigationMeshForPosition reliably answers "is there navmesh here" from the Rider evaluator; GetGroundZ is physics height and most path APIs are broken or lie
- [[navmesh-reverse-engineering-decompress-first]] (lesson): Never reverse-engineer RNM1/ZGR6/OK01 by diffing the file bytes: the body is LZ4, so diffs show compression artefacts, not structure.
- [[navmesh-sliver-dissolve-cleanup]] (howto): Howto - remove needle faces by dissolving the shared edge of two same-terrain triangles into a convex quad, preserving exact XY footprint; thresholds used.
- [[navmesh-surgery-rules-for-existing-meshes]] (howto): Rules that kept a large navmesh edit safe: area overlap, constrained triangulation, stable ids, shape gates, no component merges.
- [[navmesh-vertex-touch-is-not-an-edge-connection]] (lesson): Two navmesh faces that share only a vertex are not connected; the engine walks shared edge ids, so T-junctions create orphan islands.
- [[navmesh-xy-overlap-classification-gate]] (howto): Howto - classify every XY edge crossing/overlap/T-junction in a navmesh by owning-face terrain ids; dry/dry, water-only, coplanar and T-junction classes must be zero.
- [[nmg8-navmesh-prefab-format]] (reference): The prefab navmesh imported by Scene.ImportNavigationMeshPrefab is an uncompressed triangle NMG8, distinct from the RNM1 polygon navmesh.
- [[nmg8-nmg9-scene-navmesh-format]] (reference): Decompressed NMG8/NMG9 polygon navmesh layout: vertices, 24/20 byte edges, variable-size face records with fields g1-g6.
- [[rnm1-container-format]] (reference): RNM1 navmesh.bin container layout: header, runtime-pointer garbage, LZ4 raw block stream holding an NMG8/NMG9 payload.
- [[siege-dynamic-navmesh-id-convention]] (reference): Siege-scene navmesh g3 conventions: 1 inside castle, 2 approach, 7 gate, ladder drop ids, reserved dynamic range.

## saves-serialization

- [[party-component-owned-identity-pattern]] (decision): Persist per-party custom state on the PartyComponent itself, rebuild any registry at first tick, and never persist derived data.
- [[saveable-type-definer-ids]] (lesson): Each mod needs its own SaveableTypeDefiner base id and must keep ids stable; custom decision outcomes use consecutive ids.
- [[vanilla-save-container-definitions]] (howto): Vanilla SaveableCampaignTypeDefiner already registers most common generic containers; check it with ilspycmd before adding ConstructContainerDefinition to a mod's definer

## scenes-xscene

- [[editor-save-regenerates-terrain-bin-from-ok01]] (lesson): Opening a scene in the editor and saving rebuilds terrain.bin from terrain_ed.bin; patch both or back up terrain.bin first.
- [[flora-bin-flr2-format]] (reference): flora.bin (FLR2) record layout and the ground-clearance caveat when transplanting flora.
- [[joust-scene-generation-from-donor-scene]] (howto): Generating a joust/tournament scene from a donor scene plus a navmesh produced through the navmesh studio API.
- [[missing-commonareamarker-crash]] (lesson): A town scene whose common_area_N entities lost their CommonAreaMarker script registers zero common areas and crashes a civilian mission ~4 s in (AV reading 0x128 in TaleWorlds.Native); restore the script block
- [[ok01-orientation-and-palette-traps]] (lesson): OK01 vertex and node order are transposed relative to ZGR6, masks are per-node unions, and the layer palette is sparse and keyed by name prefix.
- [[ok01-terrain-ed-format]] (reference): OK01 terrain_ed.bin (editor-only terrain source) layout: header, column-major nodes, normals, heights, sparse weight layers.
- [[raycast-collision-roots-must-follow-relocated-art]] (lesson): Selection colliders (bo_sphere_collider, raycast-only) on campaign settlements keep stale positions when art is compacted; relocate them with the art.
- [[scene-composer-workflow]] (howto): Programmatic scene composition: SceneBuilder API, outputs, heightmap indexing, and the GUID-subset assertion.
- [[scene-entity-levels-require-all]] (lesson): An entity with several assigned scene levels appears only when the mission contains ALL of them.
- [[scene-minimum-entities-battle-scene]] (reference): Minimum content for a loadable battle scene (terrain, flora stub, navmesh, borders, spawn set, tactical regions, sound/reflection).
- [[scene-registration-by-folder-name]] (howto): The engine finds a scene by folder name in any active module's SceneObj; custom battle menu entries come from a SubModule.xml node.
- [[scene-support-files-references-atmosphere-probes]] (reference): Companion scene files: references.txt manifest, atmosphere.xml, prt_data.bin - what is known about whether they are required.
- [[scene-transforms-lack-mesh-bounds]] (lesson): Scene (xscene) entity transforms give origins/yaw/scale but no mesh extents; nested entities compose parent transforms and some use non_orthogonal_rotation_mat, so bridge spans and building footprints cannot be derived from scene data alone.
- [[scene-water-authoring]] (reference): Scenes get water from a global water_properties plane or from local water_plane/water_body entities; 1.4.8 added choppiness and a non-naval material override; a terrain re-save can silently drop rivers.
- [[siege-scene-hard-requirements]] (reference): What a campaign siege scene needs to load and function, ordered by failure risk.
- [[terrain-flora-weight-offset-threshold]] (lesson): Scene grass/bushes are usually terrain-layer flora - a layer mesh spawns only where the weight mask exceeds weight_offset*255; cap the layer below that, never zero it (it often paints the ground texture too)
- [[terrain-normals-derivable-from-heights]] (howto): Terrain normals can be recomputed from heights by central differences; the ZGR6 NRML PNG is not a usable source for OK01.
- [[xscene-byte-preserving-span-edits]] (howto): Edit a huge .xscene by byte spans (Expat offsets), hash-pinned and failure-atomic, instead of re-serialising the XML.
- [[xscene-declares-level-bit-mapping]] (reference): scene.xscene declares its own <levels> mask bits - never assume a base/level_1/level_2/civilian/siege bit order when decoding navmesh g5; enablement is AND across mission-type and level bits
- [[xscene-editor-vs-runtime-data-split]] (reference): Bannerlord scenes store terrain/entities twice - editor source (terrain_ed.bin OK01, edit_mode_data) and runtime (terrain.bin ZGR6, other xscene nodes); editing only the runtime half leaves the game fine but the editor stale, and an editor save destroys the runtime work
- [[xscene-file-byte-format]] (reference): scene.xscene exact text format: CRLF, tab indent, no BOM, self-closing tags without a space; round-trip serialisers change it.
- [[xscene-orphan-group-guid-crash]] (incident): An edit_mode_data group_object_guid not declared in editor_data crashes the Modding Kit editor with a native AV on scene load while the game runs fine; fix by declaring the group
- [[xscene-terrain-node-records-must-match-terrain-bin]] (lesson): The xscene <terrain><nodes> records size the engine's buffers; stale or partial records cause out-of-bounds reads and a native crash on scene load.
- [[zgr6-phym-layer-index-cells]] (reference): PHYM nodes are per-cell layer indices (0-based into xscene layer list); 0 is a safe uniform fill; not derivable from WGHT.
- [[zgr6-terrain-bin-format]] (reference): ZGR6 terrain.bin layout: five LZ4 sections (MIDX/HGHT/NRML/WGHT/PHYM), node tables, per-node encodings.
- [[zgr6-wght-needs-16-slots]] (lesson): Every WGHT node must carry all 16 slot entries; fewer makes the loader read past the node buffer (access violation on scene load).

## siege-machines

- [[artillery-detachment-weight-gated-on-ammo-point]] (reference): A siege weapon using GetDetachmentWeightAuxForExternalAmmoWeapons decides its detachment weight ONLY from the can_pick_up_ammo standing point; the pilot seat and HasAmmo are ignored, so a dead gunner is never replaced
- [[campaign-siege-engine-registration-numbers]] (reference): Native campaign siege machine type ids 0-7 are reserved; custom machines use 8 and up, and the map-icon projectile bone index depends on the skeleton.
- [[reloader-frozen-at-ammo-point-gate-hypothesis-falsified]] (incident): A cannon reloader frozen centimetres from the ammo point, with a live move order that never becomes a use, is not explained by shouldEnablePickup or the load standing point.
- [[setdisabledsynched-leaks-detachments]] (lesson): SetDisabledSynched does NOT remove a machine from Formation._detachments; only UsableMachine.Disable() does and it never runs on the deployment path - a live sibling must prune disabled machines via IsDeactivated
- [[siege-spawner-forward-axis-must-face-away-from-walls]] (lesson): Native RangedSiegeWeapon aim math flips the machine frame 180 degrees, so a custom machine spawner must face away from the walls and its visual body needs a pi rotation.
- [[siege-spawner-scene-requirements]] (howto): A custom siege machine spawner must sit near a siege_deployment_placeholder and have the right upgrade-level visibilities or it is silently unavailable.
- [[siege-weapon-release-angle-clamp-and-range]] (reference): Ranged siege weapon elevation is clamped by MBMath.ClampAngle around (Top+Bottom)/2, so widening only the Bottom restriction never raises max angle; at a fixed cap range scales with muzzle velocity squared
- [[siegeweapon-forceduse-steals-crew]] (lesson): SiegeWeapon.OnInit sets ForcedUse=true, so vanilla keeps enlisting the NEAREST formation onto your machine and fights your own crewing; fix with SetForcedUse(false) in C# after base.OnInit (prefab variable does not work)
- [[standingpoint-tickaux-toctou]] (lesson): StandingPoint.TickAux checks HasUser once then dereferences UserAgent repeatedly; never call StopUsingGameObject from an OnAgentWieldedItemChange handler (raised from inside TickAux on AutoSheathWeapons points)
- [[weapon-requirement-standingpoint-hasaimovingto-latch]] (lesson): A StandingPointWithWeaponRequirement refuses agents not wielding the projectile, so an agent that loses its ball en route latches HasAIMovingTo permanently and hides the point from everyone else

## ui-gauntlet

- [[banner-editor-shield-texture-nre]] (incident): BannerEditorView.OnNewBannerReadyForShield can throw an intermittent vanilla NRE at character-creation age selection via the thumbnail cache.
- [[gauntlet-sprite-atlas-repack-workflow]] (howto): How to add sprites to a Gauntlet atlas tpac: decompose, add PNGs at exact sizes, repack, update SpriteData.

## war-sails-naval

- [[seaborne-raid-scene-requirements]] (reference): What a village scene needs for sea-side raids: levels, navmesh faces, landing points, and world-map drop-offs.
- [[seaborne-village-raid-scene-checklist]] (howto): Acceptance checklist for turning a village mission scene into a War Sails seaborne-raid variant, plus the map-side requirement that makes a village sea-accessible at all.
- [[war-sails-sail-cloth-requirements]] (howto): Sail cloth works only when the sail has saved Cloth Editor settings and the mission sail has a banner child; values and shortcuts that were verified.
- [[warsails-main-map-migration-contract]] (reference): What a campaign map needs for War Sails/NavalDLC (v1.2.8): terrain ids, ports, bridges, water plane, caches, blockade and pirate setup.
- [[ws-climber-yaw-convention]] (reference): War Sails rope climbers face local X (yaw 0 starboard / pi port, climb_point at local -x, inboard); using +-pi/2 stands the ropes edge-on to the hull
- [[ws-fmod-sail-sound-hang]] (incident): UNRESOLVED - War Sails sea-battle hang with FMOD Studio update thread spinning and the game thread blocked in MissionSail.UpdateSoundPos; intermittent, not music, not camera churn; a Rider pause looks identical
- [[ws-movement-set-swim-dive-slots-must-be-defined]] (incident): A movement set with swimming/diving action slots = -1 makes the native action lookup read off the table and crash the main tick when an agent enters diving mode.
- [[ws-naval-quirks]] (reference): Smaller War Sails facts: cheat mission needs imperial troops, grappled ships fold sails, sail toggle key, port screen figurehead tooltip NRE, hull XSD warnings.
- [[ws-sail-cloth-params-frozen]] (lesson): FIXED 2026-10-02 - sail cloth meshes keep importer-default cloth params (anchor 1, wind 1, damping 0.95) so the cloth is near-rigid; vanilla square_sail_a uses anchor 0, wind 15, damping 0.2; a fresh FBX import has no cloth settings at all
- [[ws-sail-vertex-paint-pins]] (lesson): Cloth pinning lives in per-vertex colour - alpha 0 pins, blue 0 marks the border ring; sails with only the top pinned fly up like flags in wind. TpacTool prints Color as BGRA
- [[ws-ship-navmesh-boarding-face-rules]] (lesson): NavalDLC ship navmesh boarding ids (NMG9 g3, 1..50) must each be on exactly ONE face with at least one unshared edge, and every attachment machine must sit inside the face with its id; split quads are suspected of a native AV in boarding melee

## xml-data

- [[authored-genealogy-cycles-overflow-the-stack]] (incident): A hero listed as his own father in authored XML makes any recursive ancestry walk recurse until a StackOverflow, which .NET cannot catch.
- [[bannerlord-xml-load-abort-semantics]] (reference): MBObjectManager.LoadXml has no try/catch - one bad node silently kills every object after it in the merged document; classic cause of cascading NREs
- [[reused-culture-needs-complete-data]] (lesson): Reusing a vanilla culture id for new content crashes in kingdom init, hero creation and patrol spawning when the culture lacks policies, notable templates or patrol templates.
