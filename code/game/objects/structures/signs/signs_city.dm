//Considering having a subtype of this for "hanging" signs
/obj/structure/sign/city
	icon = 'code/modules/wod13/props.dmi'

/obj/structure/sign/city/police_department
	name = "San Francisco Police Department"
	desc = "Stop right there you criminal scum! Nobody can break the law on my watch!!"
	icon_state = "police"
	pixel_z = 40

/obj/structure/sign/city/order
	name = "order sign"
	icon_state = "order"

/obj/structure/sign/city/hotel
	name = "sign"
	desc = "It says H O T E L."
	icon_state = "hotel"
	//plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/sign/city/hotel/Initialize()
	. = ..()
	set_light(3, 3, "#8e509e")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/sign/city/millenium
	name = "sign"
	desc = "It says M I L L E N I U M."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "millenium"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/sign/city/millenium/Initialize()
	. = ..()
	set_light(3, 3, "#4299bb")

/obj/structure/sign/city/anarch
	name = "sign"
	desc = "It says B A R."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "bar"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/sign/city/anarch/Initialize()
	. = ..()
	set_light(3, 3, "#ffffff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/sign/city/chinese
	name = "sign"
	desc = "雨天和血的机会."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "chinese1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/sign/city/chinese/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/sign/city/chinese/alt
	icon_state = "chinese2"

/obj/structure/sign/city/chinese/alt2
	icon_state = "chinese3"

/obj/structure/sign/city/strip_club
	name = "sign"
	desc = "It says DO RA. Maybe it's some kind of strip club..."
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "dora"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	pixel_w = -8
	pixel_z = 32

/obj/structure/sign/city/strip_club/Initialize()
	. = ..()
	set_light(3, 2, "#8e509e")

/obj/structure/sign/city/cabaret_sign
	name = "cabaret"
	desc = "An enticing pair of legs... I wonder what's inside?"
	icon = 'icons/cabaret.dmi'
	icon_state = "cabar"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/sign/city/cabaret_sign/Initialize()
	. = ..()
	set_light(3, 2, "#d98aec")

/obj/structure/sign/city/cabaret_sign/two
	icon_state = "et"

/obj/structure/sign/city/store
	icon = 'code/modules/wod13/fastfood.dmi'
	icon_state = "bacotell"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	pixel_w = -16

/obj/structure/sign/city/store/bacotell
	name = "Baco Tell"
	desc = "Eat some precious tacos and pizza!"
	icon_state = "bacotell"

/obj/structure/sign/city/store/bubway
	name = "BubWay"
	desc = "Eat some precious burgers and pizza!"
	icon_state = "bubway"

/obj/structure/sign/city/store/gummaguts
	name = "Gumma Guts"
	desc = "Eat some precious chicken nuggets and donuts!"
	icon_state = "gummaguts"
