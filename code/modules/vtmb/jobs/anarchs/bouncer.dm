
/datum/job/vamp/bruiser
	title = "Bruiser"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 7
	spawn_positions = 7
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/bruiser

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRUISER
	known_contacts = list("Baron","Bouncer","Emissary","Sweeper")
	allowed_species = list("Vampire", "Ghoul")
	allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_TRUE_BRUJAH, CLAN_BRUJAH, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_TREMERE, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_TZIMISCE, CLAN_NONE, CLAN_VENTRUE, CLAN_LASOMBRA, CLAN_GARGOYLE, CLAN_KIASYD, CLAN_CAPPADOCIAN, CLAN_SETITES, CLAN_SALUBRI, CLAN_NAGARAJA, CLAN_SALUBRI_WARRIOR)
	species_slots = list("Ghoul" = 3, "Vampire" = 50)

	v_duty = "You are the enforcer of the Anarchs. The baron is always in need of muscle power. Enforce the Traditions - in the anarch way."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/bruiser
	name = "Bruiser"
	jobtype = /datum/job/vamp/bruiser

	ears = /obj/item/p25radio
	id = /obj/item/card/id/bruiser
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/bruiser
	r_hand = /obj/item/melee/vampirearms/baseball
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/vampire_stake=3, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/card/credit=1)


/obj/effect/landmark/start/bruiser
	name = "Bruiser"
	icon_state = "Bouncer"
