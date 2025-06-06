/// Wrapper spawner for lavaland fauna
/obj/effect/spawner/random/lavaland_fauna
	loot = list(
		/obj/effect/spawner/random/pool/lavaland_fauna,
		/obj/effect/spawner/random/pool/lavaland_fauna/megafauna,
		/obj/effect/spawner/random/pool/lavaland_fauna/megafauna/unique,
		/obj/effect/spawner/random/pool/tendril_spawner,
	)

/datum/spawn_pool/lavaland_fauna
	id = "lavaland_fauna_spawn_pool"

/datum/spawn_pool/lavaland_fauna/New()
	. = ..()
	available_points = rand(100, 150)

/datum/spawn_pool/lavaland_megafauna
	id = "lavaland_megafauna_spawn_pool"

/datum/spawn_pool/lavaland_megafauna/New()
	. = ..()
	available_points = roll("8d3")

/obj/effect/spawner/random/pool/lavaland_fauna
	spawn_pool_id = "lavaland_fauna_spawn_pool"
	record_spawn = TRUE

	var/fauna_scan_range = 12
	var/megafauna_scan_range = 12
	var/turf/mining_base_gps

	loot = list(
		list(
			/obj/effect/landmark/mob_spawner/goliath,
			/obj/effect/landmark/mob_spawner/legion,
			/obj/effect/landmark/mob_spawner/watcher,
		) = 3,

		list(
			/obj/effect/landmark/mob_spawner/abandoned_minebot,
			/obj/effect/landmark/mob_spawner/goldgrub,
			/obj/effect/landmark/mob_spawner/gutlunch,
		) = 1,
	)

/obj/effect/spawner/random/pool/lavaland_fauna/Initialize(mapload)
	. = ..()
	if(SSmapping.caves_theme)
		fauna_scan_range = SSmapping.caves_theme.fauna_scan_range
		megafauna_scan_range = SSmapping.caves_theme.megafauna_scan_range

	for(var/obj/item/gps/ruin/mining_base/base_gps in GLOB.poi_list)
		mining_base_gps = get_turf(base_gps)
		break

/obj/effect/spawner/random/pool/lavaland_fauna/record_item(type_path_to_make)
	if(ispath(type_path_to_make, /obj/effect/spawner/random/pool))
		return

	SSblackbox.record_feedback("tally", "lavaland_mob_spawns", 1, "[type_path_to_make]")

/obj/effect/spawner/random/pool/lavaland_fauna/check_safe(type_path_to_make)
	var/turf/T = get_turf(src)

	for(var/thing in urange(fauna_scan_range, T))
		// avoid spawning a mob if there's another one within the scan range
		if(istype(thing, /obj/effect/landmark/mob_spawner))
			return FALSE

	return ..()

/obj/effect/spawner/random/pool/lavaland_fauna/megafauna
	spawn_pool_id = "lavaland_megafauna_spawn_pool"
	point_value = 1
	loot = list(
		/mob/living/simple_animal/hostile/megafauna/dragon = 4,
		/mob/living/simple_animal/hostile/megafauna/colossus = 2,
	)

/obj/effect/spawner/random/pool/lavaland_fauna/megafauna/check_safe(type_path_to_make)
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	var/okay_area = istype(A, /area/lavaland/surface/outdoors/unexplored/danger)
	var/okay_turf = TRUE

	if(mining_base_gps && mining_base_gps.z == T.z)
		okay_turf = get_dist(mining_base_gps, T) > 64

	if(!okay_area || !okay_turf)
		return FALSE

	for(var/thing in urange(fauna_scan_range, T))
		// avoid spawning a megafauna if there's another one within the scan range
		if(ismegafauna(thing) && get_dist(T, thing) <= megafauna_scan_range)
			return FALSE

	return ..()

/obj/effect/spawner/random/pool/lavaland_fauna/megafauna/unique
	unique_picks = TRUE
	loot = list(
		/mob/living/simple_animal/hostile/megafauna/bubblegum,
		/mob/living/simple_animal/hostile/megafauna/ancient_robot,
	)

/datum/spawn_pool/tendrils
	id = "lavaland_tendril_spawn_pool"

/datum/spawn_pool/tendrils/New()
	. = ..()
	available_points = roll("5d4") + roll("1d6")

/obj/effect/spawner/random/pool/tendril_spawner
	spawn_pool_id = "lavaland_tendril_spawn_pool"
	point_value = 1
	loot = list(
		/obj/structure/spawner/lavaland,
		/obj/structure/spawner/lavaland/goliath,
		/obj/structure/spawner/lavaland/legion,
	)
	record_spawn = TRUE

/obj/effect/spawner/random/pool/tendril_spawner/record_item(type_path_to_make)
	SSblackbox.record_feedback("tally", "lavaland_mob_spawns", 1, "[type_path_to_make]")

/obj/effect/spawner/random/pool/tendril_spawner/check_safe(type_path_to_make)
	var/turf/T = get_turf(src)
	for(var/thing in urange(10, T))
		// prevents tendrils spawning in each other's collapse range
		if(istype(thing, /obj/structure/spawner/lavaland) && get_dist(T, thing) <= LAVALAND_TENDRIL_COLLAPSE_RANGE)
			return FALSE

	return ..()
