/* Diffrent misc types of sheets
 * Contains:
 * Metal
 * Plasteel
 * Wood
 * Cloth
 * Plastic
 * Cardboard
 * Paper Frames
 * Runed Metal (cult)
 * Bronze (bake brass)
 */

/*
 * Metal
 */
GLOBAL_LIST_INIT(metal_recipes, list ( \
	new/datum/stack_recipe("stool", /obj/structure/chair/stool, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("bar stool", /obj/structure/chair/stool/bar, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("bed", /obj/structure/bed, 2, one_per_turf = TRUE, on_floor = TRUE), \
	null, \
	new/datum/stack_recipe_list("office chairs", list( \
		new/datum/stack_recipe("dark office chair", /obj/structure/chair/office, 5, one_per_turf = TRUE, on_floor = TRUE), \
		new/datum/stack_recipe("light office chair", /obj/structure/chair/office/light, 5, one_per_turf = TRUE, on_floor = TRUE), \
		)), \
	new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/chair/comfy/beige, 2, one_per_turf = TRUE, on_floor = TRUE), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/chair/comfy/black, 2, one_per_turf = TRUE, on_floor = TRUE), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/chair/comfy/brown, 2, one_per_turf = TRUE, on_floor = TRUE), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/chair/comfy/lime, 2, one_per_turf = TRUE, on_floor = TRUE), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/chair/comfy/teal, 2, one_per_turf = TRUE, on_floor = TRUE), \
		)), \
	new/datum/stack_recipe_list("sofas", list(
		new /datum/stack_recipe("sofa (middle)", /obj/structure/chair/sofa/old, 1, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("sofa (left)", /obj/structure/chair/sofa/old/left, 1, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("sofa (right)", /obj/structure/chair/sofa/old/right, 1, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("sofa (corner)", /obj/structure/chair/sofa/old/corner, 1, one_per_turf = TRUE, on_floor = TRUE)
		)), \
	new/datum/stack_recipe_list("corporate sofas", list( \
		new /datum/stack_recipe("sofa (middle)", /obj/structure/chair/sofa/corp, one_per_turf = TRUE, on_floor = TRUE), \
		new /datum/stack_recipe("sofa (left)", /obj/structure/chair/sofa/corp/left, one_per_turf = TRUE, on_floor = TRUE), \
		new /datum/stack_recipe("sofa (right)", /obj/structure/chair/sofa/corp/right, one_per_turf = TRUE, on_floor = TRUE), \
		new /datum/stack_recipe("sofa (corner)", /obj/structure/chair/sofa/corp/corner, one_per_turf = TRUE, on_floor = TRUE), \
		)), \
	new/datum/stack_recipe("rack parts", /obj/item/rack_parts), \
	new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("floor tile", /obj/item/stack/tile/plasteel, 1, 4, 20), \
	new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60), \
	null, \
	new/datum/stack_recipe("meatspike frame", /obj/structure/kitchenspike_frame, 5, time = 25, one_per_turf = TRUE, on_floor = TRUE), \
	null, \
	new/datum/stack_recipe("grenade casing", /obj/item/grenade/chem_grenade), \
	new/datum/stack_recipe("light fixture frame", /obj/item/wallframe/light_fixture, 2), \
	new/datum/stack_recipe("small light fixture frame", /obj/item/wallframe/light_fixture/small, 1), \
	null, \
	new/datum/stack_recipe("extinguisher cabinet frame", /obj/item/wallframe/extinguisher_cabinet, 2), \
	null, \
	new/datum/stack_recipe("floodlight frame", /obj/structure/floodlight_frame, 5, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("voting box", /obj/structure/votebox, 15, time = 50), \
	new/datum/stack_recipe("pestle", /obj/item/pestle, 1, time = 50), \
	new/datum/stack_recipe("shower frame", /obj/structure/showerframe, 2, time= 2 SECONDS)
))

/obj/item/stack/sheet/metal
	name = "metal"
	desc = "Sheets made out of metal."
	singular_name = "metal sheet"
	icon_state = "sheet-metal"
	inhand_icon_state = "sheet-metal"
	mats_per_unit = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT)
	throwforce = 10
	flags_1 = CONDUCT_1
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/metal
	grind_results = list(/datum/reagent/iron = 20)
	point_value = 2
	tableVariant = /obj/structure/table
	material_type = /datum/material/iron
	matter_amount = 4
	cost = 500
	source = /datum/robot_energy_storage/metal

/obj/item/stack/sheet/metal/narsie_act()
	new /obj/item/stack/sheet/runed_metal(loc, amount)
	qdel(src)

/obj/item/stack/sheet/metal/fifty
	amount = 50

/obj/item/stack/sheet/metal/twenty
	amount = 20

/obj/item/stack/sheet/metal/ten
	amount = 10

/obj/item/stack/sheet/metal/five
	amount = 5

/obj/item/stack/sheet/metal/get_main_recipes()
	. = ..()
	. += GLOB.metal_recipes

/obj/item/stack/sheet/metal/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins whacking [user.p_them()]self over the head with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/*
 * Plasteel
 */
GLOBAL_LIST_INIT(plasteel_recipes, list ( \
	new/datum/stack_recipe("bomb assembly", /obj/machinery/syndicatebomb/empty, 10, time = 50), \
	null, \
))

/obj/item/stack/sheet/plasteel
	name = "plasteel"
	singular_name = "plasteel sheet"
	desc = "This sheet is an alloy of iron and plasma."
	icon_state = "sheet-plasteel"
	inhand_icon_state = "sheet-plasteel"
	mats_per_unit = list(/datum/material/alloy/plasteel=MINERAL_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasteel
	throwforce = 10
	flags_1 = CONDUCT_1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 80)
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/plasteel
	grind_results = list(/datum/reagent/iron = 20, /datum/reagent/toxin/plasma = 20)
	point_value = 23
	tableVariant = /obj/structure/table/reinforced
	material_flags = MATERIAL_NO_EFFECTS
	matter_amount = 12

/obj/item/stack/sheet/plasteel/get_main_recipes()
	. = ..()
	. += GLOB.plasteel_recipes

/obj/item/stack/sheet/plasteel/twenty
	amount = 20

/obj/item/stack/sheet/plasteel/fifty
	amount = 50

/*
 * Wood
 */
GLOBAL_LIST_INIT(wood_recipes, list ( \
	new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20), \
	new/datum/stack_recipe("wood table frame", /obj/structure/table_frame/wood, 2, time = 10), \
	new/datum/stack_recipe("rolling pin", /obj/item/kitchen/rollingpin, 2, time = 30), \
	new/datum/stack_recipe("wooden chair", /obj/structure/chair/wood/, 3, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("winged wooden chair", /obj/structure/chair/wood/wings, 3, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, 5, time = 50, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("book case", /obj/structure/bookcase, 4, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("drying rack", /obj/machinery/smartfridge/drying_rack, 10, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("wooden barrel", /obj/structure/fermenting_barrel, 8, time = 50, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("dog bed", /obj/structure/bed/dogbed, 10, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("dresser", /obj/structure/dresser, 10, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("picture frame", /obj/item/wallframe/picture, 1, time = 10),\
	new/datum/stack_recipe("painting frame", /obj/item/wallframe/painting, 1, time = 10),\
	new/datum/stack_recipe("wooden bucket", /obj/item/reagent_containers/glass/bucket/wooden, 3, time = 10),\
	new/datum/stack_recipe("rake", /obj/item/cultivator/rake, 5, time = 10),\
	new/datum/stack_recipe("loom", /obj/structure/loom, 10, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("mortar", /obj/item/reagent_containers/glass/mortar, 3), \
	new/datum/stack_recipe("firebrand", /obj/item/match/firebrand, 2, time = 100), \
	null, \
	new/datum/stack_recipe_list("pews", list(
		new /datum/stack_recipe("pew (middle)", /obj/structure/chair/pew, 3, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("pew (left)", /obj/structure/chair/pew/left, 3, one_per_turf = TRUE, on_floor = TRUE),
		new /datum/stack_recipe("pew (right)", /obj/structure/chair/pew/right, 3, one_per_turf = TRUE, on_floor = TRUE)
		)),
	null, \
	))

/obj/item/stack/sheet/mineral/wood
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "wood plank"
	icon_state = "sheet-wood"
	inhand_icon_state = "sheet-wood"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/wood=MINERAL_MATERIAL_AMOUNT)
	sheettype = "wood"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 0)
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/wood
	novariants = TRUE
	material_type = /datum/material/wood
	grind_results = list(/datum/reagent/cellulose = 20) //no lignocellulose or lignin reagents yet,
	walltype = /turf/closed/wall/mineral/wood

/obj/item/stack/sheet/mineral/wood/get_main_recipes()
	. = ..()
	. += GLOB.wood_recipes

/obj/item/stack/sheet/mineral/wood/fifty
	amount = 50

/*
 * Bamboo
 */

GLOBAL_LIST_INIT(bamboo_recipes, list ( \
	new/datum/stack_recipe("punji sticks trap", /obj/structure/punji_sticks, 5, time = 30, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("blow gun", /obj/item/gun/syringe/blowgun, 10, time = 70), \
	))

/obj/item/stack/sheet/mineral/bamboo
	name = "bamboo cuttings"
	desc = "Finely cut bamboo sticks."
	singular_name = "cut bamboo stick"
	icon_state = "sheet-bamboo"
	inhand_icon_state = "sheet-bamboo"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/bamboo = MINERAL_MATERIAL_AMOUNT)
	throwforce = 15
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 0)
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/bamboo
	grind_results = list(/datum/reagent/cellulose = 10)
	material_type = /datum/material/bamboo
	drop_sound = null
	pickup_sound = null

/datum/armor/mineral_bamboo
	fire = 50

/obj/item/stack/sheet/mineral/bamboo/get_main_recipes()
	. = ..()
	. += GLOB.bamboo_recipes

/*
 * Cloth
 */
GLOBAL_LIST_INIT(cloth_recipes, list ( \
	new/datum/stack_recipe("white jumpskirt", /obj/item/clothing/under/color/jumpskirt/white, 3), /*Ladies first*/ \
	new/datum/stack_recipe("white jumpsuit", /obj/item/clothing/under/color/white, 3), \
	new/datum/stack_recipe("white shoes", /obj/item/clothing/shoes/sneakers/white, 2), \
	new/datum/stack_recipe("white scarf", /obj/item/clothing/neck/scarf, 1), \
	null, \
	new/datum/stack_recipe("backpack", /obj/item/storage/backpack, 4), \
	new/datum/stack_recipe("duffel bag", /obj/item/storage/backpack/duffelbag, 6), \
	null, \
	new/datum/stack_recipe("plant bag", /obj/item/storage/bag/plants, 4), \
	new/datum/stack_recipe("book bag", /obj/item/storage/bag/books, 4), \
	new/datum/stack_recipe("mining satchel", /obj/item/storage/bag/ore, 4), \
	new/datum/stack_recipe("chemistry bag", /obj/item/storage/bag/chemistry, 4), \
	new/datum/stack_recipe("bio bag", /obj/item/storage/bag/bio, 4), \
	new/datum/stack_recipe("construction bag", /obj/item/storage/bag/construction, 4), \
	null, \
	new/datum/stack_recipe("improvised gauze", /obj/item/stack/medical/gauze/improvised, 1, 2, 6), \
	new/datum/stack_recipe("rag", /obj/item/reagent_containers/glass/rag, 1), \
	new/datum/stack_recipe("bedsheet", /obj/item/bedsheet, 3), \
	new/datum/stack_recipe("empty sandbag", /obj/item/emptysandbag, 4), \
	null, \
	new/datum/stack_recipe("fingerless gloves", /obj/item/clothing/gloves/fingerless, 1), \
	new/datum/stack_recipe("white gloves", /obj/item/clothing/gloves/color/white, 3), \
	new/datum/stack_recipe("white softcap", /obj/item/clothing/head/soft/mime, 2), \
	new/datum/stack_recipe("white beanie", /obj/item/clothing/head/beanie, 2), \
	null, \
	new/datum/stack_recipe("blindfold", /obj/item/clothing/glasses/blindfold, 2), \
	null, \
	new/datum/stack_recipe("19x19 canvas", /obj/item/canvas/nineteen_nineteen, 3), \
	new/datum/stack_recipe("23x19 canvas", /obj/item/canvas/twentythree_nineteen, 4), \
	new/datum/stack_recipe("23x23 canvas", /obj/item/canvas/twentythree_twentythree, 5), \
	))

/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "Is it cotton? Linen? Denim? Burlap? Canvas? You can't tell."
	singular_name = "cloth roll"
	icon_state = "sheet-cloth"
	inhand_icon_state = "sheet-cloth"
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cloth
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound =  'sound/items/handling/cloth_pickup.ogg'
	grind_results = list(/datum/reagent/cellulose = 20)

/obj/item/stack/sheet/cloth/get_main_recipes()
	. = ..()
	. += GLOB.cloth_recipes

/obj/item/stack/sheet/cloth/ten
	amount = 10

/obj/item/stack/sheet/cloth/five
	amount = 5

GLOBAL_LIST_INIT(durathread_recipes, list ( \
	new/datum/stack_recipe("durathread jumpsuit", /obj/item/clothing/under/misc/durathread, 4, time = 40),
	new/datum/stack_recipe("durathread beret", /obj/item/clothing/head/beret/durathread, 2, time = 40), \
	new/datum/stack_recipe("durathread beanie", /obj/item/clothing/head/beanie/durathread, 2, time = 40), \
	new/datum/stack_recipe("durathread bandana", /obj/item/clothing/mask/bandana/durathread, 1, time = 25), \
	))

/obj/item/stack/sheet/durathread
	name = "durathread"
	desc = "A fabric sown from incredibly durable threads, known for its usefulness in armor production."
	singular_name = "durathread roll"
	icon_state = "sheet-durathread"
	inhand_icon_state = "sheet-cloth"
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/durathread
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound =  'sound/items/handling/cloth_pickup.ogg'

/obj/item/stack/sheet/durathread/get_main_recipes()
	. = ..()
	. += GLOB.durathread_recipes

/obj/item/stack/sheet/cotton
	name = "raw cotton bundle"
	desc = "A bundle of raw cotton ready to be spun on the loom."
	singular_name = "raw cotton ball"
	icon_state = "sheet-cotton"
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cotton
	var/pull_effort = 10
	var/loom_result = /obj/item/stack/sheet/cloth
	grind_results = list(/datum/reagent/cellulose = 20)

/obj/item/stack/sheet/cotton/durathread
	name = "raw durathread bundle"
	desc = "A bundle of raw durathread ready to be spun on the loom."
	singular_name = "raw durathread ball"
	icon_state = "sheet-durathreadraw"
	merge_type = /obj/item/stack/sheet/cotton/durathread
	loom_result = /obj/item/stack/sheet/durathread
	grind_results = list()

/*
 * Cardboard
 */
GLOBAL_LIST_INIT(cardboard_recipes, list (														\
	new/datum/stack_recipe("box", /obj/item/storage/box),										\
	new/datum/stack_recipe("large box", /obj/structure/closet/cardboard, 4, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("cardboard cutout", /obj/item/cardboard_cutout, 5),					\
	null,																						\

	new/datum/stack_recipe("pizza box", /obj/item/pizzabox),									\
	new/datum/stack_recipe("folder", /obj/item/folder),											\
	null,																						\
	//TO-DO: Find a proper way to just change the illustration on the box. Code isn't the issue, input is.
	new/datum/stack_recipe_list("fancy boxes", list(
		new /datum/stack_recipe("donut box", /obj/item/storage/fancy/donut_box),				\
		new /datum/stack_recipe("egg box", /obj/item/storage/fancy/egg_box),					\
		new /datum/stack_recipe("nugget box", /obj/item/storage/fancy/nugget_box),			\
		null,																					\

		new /datum/stack_recipe("lethal ammo box", /obj/item/storage/box/lethalshot),			\
		new /datum/stack_recipe("rubber shot ammo box", /obj/item/storage/box/rubbershot),		\
		new /datum/stack_recipe("bean bag ammo box", /obj/item/storage/box/beanbag),			\
		new /datum/stack_recipe("flashbang box", /obj/item/storage/box/flashbangs),				\
		new /datum/stack_recipe("flashes box", /obj/item/storage/box/flashes),					\
		new /datum/stack_recipe("handcuffs box", /obj/item/storage/box/handcuffs),				\
		null,																					\

		new /datum/stack_recipe("pillbottle box", /obj/item/storage/box/pillbottles),			\
		new /datum/stack_recipe("beaker box", /obj/item/storage/box/beakers),					\
		new /datum/stack_recipe("syringe box", /obj/item/storage/box/syringes),					\
		new /datum/stack_recipe("latex gloves box", /obj/item/storage/box/gloves),				\
		new /datum/stack_recipe("sterile masks box", /obj/item/storage/box/masks),				\
		new /datum/stack_recipe("body bag box", /obj/item/storage/box/bodybags),				\
		new /datum/stack_recipe("perscription glasses box", /obj/item/storage/box/rxglasses),	\
		new /datum/stack_recipe("medipen box", /obj/item/storage/box/medipens),					\
		null,																					\

		new /datum/stack_recipe("disk box", /obj/item/storage/box/disks),						\
		new /datum/stack_recipe("light tubes box", /obj/item/storage/box/lights/tubes),			\
		new /datum/stack_recipe("light bulbs box", /obj/item/storage/box/lights/bulbs),			\
		new /datum/stack_recipe("mixed lights box", /obj/item/storage/box/lights/mixed),		\
		new /datum/stack_recipe("mouse traps box", /obj/item/storage/box/mousetraps),			\
		new /datum/stack_recipe("candle box", /obj/item/storage/fancy/candle_box)
		)),

	null,																						\
))

/obj/item/stack/sheet/cardboard	//BubbleWrap //it's cardboard you fuck
	name = "cardboard"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "cardboard sheet"
	icon_state = "sheet-card"
	inhand_icon_state = "sheet-card"
	mats_per_unit = list(/datum/material/cardboard = MINERAL_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cardboard
	novariants = TRUE
	grind_results = list(/datum/reagent/cellulose = 10)
	material_type = /datum/material/cardboard

/obj/item/stack/sheet/cardboard/get_main_recipes()
	. = ..()
	. += GLOB.cardboard_recipes

/obj/item/stack/sheet/cardboard/fifty
	amount = 50

/obj/item/stack/sheet/cardboard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stamp/clown) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(use(1))
			playsound(I, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
			to_chat(user, "<span class='notice'>You stamp the cardboard! It's a clown box! Honk!</span>")
			if (amount >= 0)
				new/obj/item/storage/box/clown(droploc) //bugfix
	if(istype(I, /obj/item/stamp/chameleon) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(use(1))
			to_chat(user, "<span class='notice'>You stamp the cardboard in a sinister way.</span>")
			if (amount >= 0)
				new/obj/item/storage/box/syndie_kit(droploc)
	else
		. = ..()


/*
 * Runed Metal
 */

GLOBAL_LIST_INIT(runed_metal_recipes, list ( \
	new /datum/stack_recipe("runed door (a weak door that stuns non-cultists who touch it))", /obj/machinery/door/airlock/cult, 1, time = 5 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("runed girder (not a recommended usage of runed metal)", /obj/structure/girder/cult, 1, time = 5 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("pylon (heals (and regenerates the blood of) nearby blood cultists and constructs, but also turns nearby floor tiles into engraved flooring)", /obj/structure/destructible/cult/pylon, 4, time = 4 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("daemon forge (can make shielded robes, flagellant's robes, and mirror shields)", /obj/structure/destructible/cult/forge, 3, time = 4 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("archives (can make zealot's blindfolds, shuttle curse orbs, and veil walker equipment)", /obj/structure/destructible/cult/tome, 3, time = 4 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("altar (can make eldritch whetstones, construct shells, and flasks of unholy water)", /obj/structure/destructible/cult/talisman, 3, time = 4 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	))

/obj/item/stack/sheet/runed_metal
	name = "runed metal"
	desc = "Sheets of cold metal with shifting inscriptions writ upon them."
	singular_name = "runed metal sheet"
	icon_state = "sheet-runed"
	inhand_icon_state = "sheet-runed"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/runedmetal = MINERAL_MATERIAL_AMOUNT)
	sheettype = "runed"
	merge_type = /obj/item/stack/sheet/runed_metal
	novariants = TRUE
	grind_results = list(/datum/reagent/iron = 5, /datum/reagent/blood = 15)
	material_type = /datum/material/runedmetal

/obj/item/stack/sheet/runed_metal/attack_self(mob/living/user)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>Only one with forbidden knowledge could hope to work this metal...</span>")
		return
	var/turf/T = get_turf(user) //we may have moved. adjust as needed...
	var/area/A = get_area(user)
	if((!is_station_level(T.z) && !is_mining_level(T.z)) || (A && !(A.flags_1 & CULT_PERMITTED_1)))
		to_chat(user, "<span class='warning'>The veil is not weak enough here.</span>")
		return FALSE
	return ..()

/obj/item/stack/sheet/runed_metal/get_main_recipes()
	. = ..()
	. += GLOB.runed_metal_recipes

/obj/item/stack/sheet/runed_metal/fifty
	amount = 50

/obj/item/stack/sheet/runed_metal/ten
	amount = 10

/obj/item/stack/sheet/runed_metal/five
	amount = 5

/*
 * Bronze
 */

GLOBAL_LIST_INIT(bronze_recipes, list ( \
	new/datum/stack_recipe("bronze boots", /obj/item/clothing/shoes/bronze), \
	null,
))

/obj/item/stack/tile/bronze
	name = "brass"
	desc = "On closer inspection, what appears to be wholly-unsuitable-for-building brass is actually more structurally stable bronze."
	singular_name = "bronze sheet"
	icon_state = "sheet-brass"
	inhand_icon_state = "sheet-brass"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/bronze = MINERAL_MATERIAL_AMOUNT)
	lefthand_file = 'icons/mob/inhands/misc/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/sheets_righthand.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	force = 5
	throwforce = 10
	max_amount = 50
	throw_speed = 1
	throw_range = 3
	turf_type = /turf/open/floor/bronze
	novariants = FALSE
	grind_results = list(/datum/reagent/iron = 5, /datum/reagent/copper = 3) //we have no "tin" reagent so this is the closest thing
	merge_type = /obj/item/stack/tile/bronze
	tableVariant = /obj/structure/table/bronze
	material_type = /datum/material/bronze

/obj/item/stack/tile/bronze/get_main_recipes()
	. = ..()
	. += GLOB.bronze_recipes

/obj/item/stack/sheet/paperframes/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = 0
	pixel_y = 0

/obj/item/stack/tile/bronze/thirty
	amount = 30

/*
 * Lesser and Greater gems - unused
 */
/obj/item/stack/sheet/lessergem
	name = "lesser gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "lesser gem"
	icon_state = "sheet-lessergem"
	inhand_icon_state = "sheet-lessergem"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/lessergem

/obj/item/stack/sheet/greatergem
	name = "greater gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "greater gem"
	icon_state = "sheet-greatergem"
	inhand_icon_state = "sheet-greatergem"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/greatergem

/*
 * Bones
 */
/obj/item/stack/sheet/bone
	name = "bones"
	icon = 'icons/obj/mining.dmi'
	icon_state = "bone"
	inhand_icon_state = "sheet-bone"
	mats_per_unit = list(/datum/material/bone = MINERAL_MATERIAL_AMOUNT)
	singular_name = "bone"
	desc = "Someone's been drinking their milk."
	force = 7
	throwforce = 5
	max_amount = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	grind_results = list(/datum/reagent/carbon = 10)
	merge_type = /obj/item/stack/sheet/bone
	material_type = /datum/material/bone
	drop_sound = null
	pickup_sound = null

GLOBAL_LIST_INIT(plastic_recipes, list(
	new /datum/stack_recipe("plastic floor tile", /obj/item/stack/tile/plastic, 1, 4, 20), \
	new /datum/stack_recipe("folding plastic chair", /obj/structure/chair/plastic, 2), \
	new /datum/stack_recipe("plastic flaps", /obj/structure/plasticflaps, 5, one_per_turf = TRUE, on_floor = TRUE, time = 40), \
	new /datum/stack_recipe("water bottle", /obj/item/reagent_containers/food/drinks/waterbottle/empty), \
	new /datum/stack_recipe("large water bottle", /obj/item/reagent_containers/food/drinks/waterbottle/large/empty, 3), \
	new /datum/stack_recipe("colo cups", /obj/item/reagent_containers/food/drinks/colocup, 1), \
	new /datum/stack_recipe("wet floor sign", /obj/item/clothing/suit/caution, 2), \
	new /datum/stack_recipe("blank wall sign", /obj/item/sign, 1)))

/obj/item/stack/sheet/plastic
	name = "plastic"
	desc = "Compress dinosaur over millions of years, then refine, split and mold, and voila! You have plastic."
	singular_name = "plastic sheet"
	icon_state = "sheet-plastic"
	inhand_icon_state = "sheet-plastic"
	mats_per_unit = list(/datum/material/plastic=MINERAL_MATERIAL_AMOUNT)
	throwforce = 7
	material_type = /datum/material/plastic
	merge_type = /obj/item/stack/sheet/plastic

/obj/item/stack/sheet/plastic/fifty
	amount = 50

/obj/item/stack/sheet/plastic/five
	amount = 5

/obj/item/stack/sheet/plastic/get_main_recipes()
	. = ..()
	. += GLOB.plastic_recipes

GLOBAL_LIST_INIT(paperframe_recipes, list(
new /datum/stack_recipe("paper frame separator", /obj/structure/window/paperframe, 2, one_per_turf = TRUE, on_floor = TRUE, time = 10), \
new /datum/stack_recipe("paper frame door", /obj/structure/mineral_door/paperframe, 3, one_per_turf = TRUE, on_floor = TRUE, time = 10 )))

/obj/item/stack/sheet/paperframes
	name = "paper frames"
	desc = "A thin wooden frame with paper attached."
	singular_name = "paper frame"
	icon_state = "sheet-paper"
	inhand_icon_state = "sheet-paper"
	mats_per_unit = list(/datum/material/paper = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/paperframes
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 20)
	material_type = /datum/material/paper
	drop_sound = null
	pickup_sound = null

/obj/item/stack/sheet/paperframes/get_main_recipes()
	. = ..()
	. += GLOB.paperframe_recipes
/obj/item/stack/sheet/paperframes/five
	amount = 5
/obj/item/stack/sheet/paperframes/twenty
	amount = 20
/obj/item/stack/sheet/paperframes/fifty
	amount = 50

/obj/item/stack/sheet/meat
	name = "meat sheets"
	desc = "Something's bloody meat compressed into a nice solid sheet."
	singular_name = "meat sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_COLOR
	mats_per_unit = list(/datum/material/meat = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/meat
	material_type = /datum/material/meat
	material_modifier = 1 //None of that wussy stuff
	drop_sound = null
	pickup_sound = null

/obj/item/stack/sheet/meat/fifty
	amount = 50
/obj/item/stack/sheet/meat/twenty
	amount = 20
/obj/item/stack/sheet/meat/five
	amount = 5

/obj/item/stack/sheet/pizza
	name = "pepperoni sheetzzas"
	desc = "It's a delicious pepperoni sheetzza!"
	singular_name = "pepperoni sheetzza"
	icon_state = "sheet-pizza"
	mats_per_unit = list(/datum/material/pizza = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/pizza
	material_type = /datum/material/pizza
	material_modifier = 1
	drop_sound = null
	pickup_sound = null

/obj/item/stack/sheet/pizza/fifty
	amount = 50
/obj/item/stack/sheet/pizza/twenty
	amount = 20
/obj/item/stack/sheet/pizza/five
	amount = 5

/obj/item/stack/sheet/sandblock
	name = "blocks of sand"
	desc = "You're too old to be playing with sandcastles. Now you build... sandstations."
	singular_name = "sand block"
	icon_state = "sheet-sandstone"
	mats_per_unit = list(/datum/material/sand = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/sandblock
	material_type = /datum/material/sand
	material_modifier = 1

/obj/item/stack/sheet/sandblock/fifty
	amount = 50
/obj/item/stack/sheet/sandblock/twenty
	amount = 20
/obj/item/stack/sheet/sandblock/five
	amount = 5


/obj/item/stack/sheet/hauntium
	name = "haunted sheets"
	desc = "These sheets seem cursed."
	singular_name = "haunted sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_COLOR
	mats_per_unit = list(/datum/material/hauntium = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/hauntium
	material_type = /datum/material/hauntium
	material_modifier = 1 //None of that wussy stuff

/obj/item/stack/sheet/hauntium/fifty
	amount = 50
/obj/item/stack/sheet/hauntium/twenty
	amount = 20
/obj/item/stack/sheet/hauntium/five
	amount = 5
