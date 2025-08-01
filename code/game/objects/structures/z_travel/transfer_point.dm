GLOBAL_LIST_EMPTY(unallocted_transfer_points)

/obj/transfer_point_vamp
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "matrix_go"
	name = "transfer point"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/obj/transfer_point_vamp/exit
	var/id = "unallocated"

/obj/transfer_point_vamp/Initialize()
	. = ..()
	if(!exit)
		if(isnum(id))
			warning("[src] has a ID of [id]. Numbers are bad practice") // Im considering them bad practice cause you cant fucking tell where the lead - Fallcon
		GLOB.unallocted_transfer_points += src
		for(var/obj/transfer_point_vamp/T in GLOB.unallocted_transfer_points)
			if(T.id == id && T != src)
				exit = T
				GLOB.unallocted_transfer_points -= T
				T.exit = src
				GLOB.unallocted_transfer_points -= src
				break

/obj/transfer_point_vamp/backrooms
	id = "backrooms"
	alpha = 0

/obj/transfer_point_vamp/backrooms/map
	density = 0

/obj/transfer_point_vamp/umbral
	name = "portal"
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "portal"
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	pixel_w = -8

/obj/transfer_point_vamp/old_clan_tzimisce
	name = "old clan transfer point"
	icon_state = "matrix_go"
	layer = MID_TURF_LAYER

/obj/transfer_point_vamp/umbral/Initialize()
	. = ..()
	set_light(2, 1, "#a4a0fb")

/obj/transfer_point_vamp/umbral/Bumped(atom/movable/AM)
	. = ..()
	playsound(get_turf(AM), 'code/modules/wod13/sounds/portal_enter.ogg', 75, FALSE)

/obj/transfer_point_vamp/Bumped(atom/movable/AM)
	. = ..()
	var/turf/T = get_step(exit, get_dir(AM, src))
	AM.forceMove(T)
