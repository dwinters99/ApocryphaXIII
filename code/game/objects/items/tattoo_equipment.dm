//CONTAINS:
//Tattoo gun and needle
//Tattoo ink
//Numbing spray


/obj/item/reagent_containers/tattoo_gun //Normal tattoo gun. Quick, professional.
	name = "tattoo gun"
	desc = "For creating tattoos. A nerd might call it a tattoo machine."
	icon = 'icons/obj/wod13/tattoo_equipment.dmi'
	icon_state = "gun"
	var/ink = 10 //Capacity. Bigger tattoos need more ink.
	var/speed = 1 //Tattooing speed. Bigger tattoos take longer.

/obj/item/reagent_containers/tattoo_gun/needle //Plain metal. Slow, painful.
	name = "tattoo needle"
	desc = "For creating tattoos. This is ancient technology perfect for creating modern art."
	icon = 'icons/obj/wod13/tattoo_equipment.dmi'
	icon_state = "needle"
	ink = 10
	speed = 0.2 //Slower!

/obj/item/reagent_containers/tattoo_ink //Omni-colored.
	name = "tattoo ink"
	desc = "For creating tattoos. Without this, it's just bad acupuncture."
	icon = 'icons/obj/wod13/tattoo_equipment.dmi'
	icon_state = "ink"
	volume = 30
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/glass/numbing_spray
	name = "numbing spray"
	desc = "Weak topical anesthetic. Useful for crybabies and sensitive addicts."
	icon = 'icons/obj/wod13/tattoo_equipment.dmi'
	icon_state = "spray"
	volume = 10
