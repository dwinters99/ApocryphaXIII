/**
 * Base class for all random spawners.
 */
/obj/effect/spawner/random
	icon = 'icons/effects/random_spawners.dmi'
	icon_state = "loot"
	layer = OBJ_LAYER
	/// Stops persistent lootdrop spawns from being shoved into lockers
	anchored = TRUE
	/// A list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)
	var/list/loot
	/// The subtypes AND type to combine with the loot list
	var/loot_type_path
	/// The subtypes (this excludes the provided path) to combine with the loot list
	var/loot_subtype_path
	/// Whether the spawner should immediately spawn loot and cleanup on Initialize()
	var/spawn_on_init = TRUE
	/// How many items will be spawned
	var/spawn_loot_count = 1
	/// If the same item can be spawned twice
	var/spawn_loot_double = TRUE
	/// Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself
	var/spawn_loot_split = FALSE
	/// Whether the spawner should spawn all the loot in the list
	var/spawn_all_loot = FALSE
	/// The chance for the spawner to create loot (ignores spawn_loot_count)
	var/spawn_loot_chance = 100
	/// Determines how big of a range (in tiles) we should scatter things in.
	var/spawn_scatter_radius = 0
	/// Whether the items should have a random pixel_x/y offset (maxium offset distance is ±16 pixels for x/y)
	var/spawn_random_offset = FALSE

/obj/effect/spawner/random/Initialize(mapload)
	. = ..()

	if(spawn_on_init)
		spawn_loot()
		return INITIALIZE_HINT_QDEL

///If the spawner has any loot defined, randomly picks some and spawns it. Does not cleanup the spawner.
/obj/effect/spawner/random/proc/spawn_loot(lootcount_override)
	if(!prob(spawn_loot_chance))
		return INITIALIZE_HINT_QDEL

	var/list/spawn_locations = get_spawn_locations(spawn_scatter_radius)
	var/spawn_loot_count = isnull(lootcount_override) ? src.spawn_loot_count : lootcount_override

	if(spawn_all_loot)
		spawn_loot_count = INFINITY
		spawn_loot_double = FALSE

	if(loot_type_path)
		loot += typesof(loot_type_path)

	if(loot_subtype_path)
		loot += subtypesof(loot_subtype_path)

	if(loot?.len)
		var/loot_spawned = 0
		while((spawn_loot_count-loot_spawned) && loot.len)
			var/lootspawn = pickweight(loot)
			while(islist(lootspawn))
				lootspawn = pickweight(lootspawn)
			if(!spawn_loot_double)
				loot.Remove(lootspawn)
			if(lootspawn && (spawn_scatter_radius == 0 || spawn_locations.len))
				var/turf/spawn_loc = loc
				if(spawn_scatter_radius > 0)
					spawn_loc = pick_n_take(spawn_locations)

				var/atom/movable/spawned_loot = new lootspawn(spawn_loc)
				spawned_loot.setDir(dir)

				if (!spawn_loot_split && !spawn_random_offset)
					if (pixel_x != 0)
						spawned_loot.pixel_x = pixel_x
					if (pixel_y != 0)
						spawned_loot.pixel_y = pixel_y
				else if (spawn_random_offset)
					spawned_loot.pixel_x = rand(-16, 16)
					spawned_loot.pixel_y = rand(-16, 16)
				else if (spawn_loot_split)
					if (loot_spawned)
						spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
			loot_spawned++

///If the spawner has a spawn_scatter_radius set, this creates a list of nearby turfs available
/obj/effect/spawner/random/proc/get_spawn_locations(radius)
	var/list/scatter_locations = list()

	if(radius >= 0)
		for(var/turf/turf_in_view in view(radius, get_turf(src)))
			if(!turf_in_view.density)
				scatter_locations += turf_in_view

	return scatter_locations

//finds the probabilities of items spawning from a loot spawner's loot pool
/obj/item/loot_table_maker
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"
	var/spawner_to_test = /obj/effect/spawner/random/maintenance //what lootdrop spawner to use the loot pool of
	var/loot_count = 180 //180 is about how much maint loot spawns per map as of 11/14/2019
	//result outputs
	var/list/spawned_table //list of all items "spawned" and how many
	var/list/stat_table //list of all items "spawned" and their occurrance probability

/obj/item/loot_table_maker/Initialize()
	. = ..()
	make_table()

/obj/item/loot_table_maker/attack_self(mob/user)
	to_chat(user, "Loot pool re-rolled.")
	make_table()

/obj/item/loot_table_maker/proc/make_table()
	spawned_table = list()
	stat_table = list()
	var/obj/effect/spawner/random/spawner_to_table = new spawner_to_test
	var/lootpool = spawner_to_table.loot
	qdel(spawner_to_table)
	for(var/i in 1 to loot_count)
		var/loot_spawn = pick_loot(lootpool)
		if(!(loot_spawn in spawned_table))
			spawned_table[loot_spawn] = 1
		else
			spawned_table[loot_spawn] += 1
	stat_table += spawned_table
	for(var/item in stat_table)
		stat_table[item] /= loot_count

/obj/item/loot_table_maker/proc/pick_loot(lootpool) //selects path from loot table and returns it
	var/lootspawn = pickweight(lootpool)
	while(islist(lootspawn))
		lootspawn = pickweight(lootspawn)
	return lootspawn
