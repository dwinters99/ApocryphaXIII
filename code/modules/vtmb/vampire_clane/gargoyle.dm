/datum/vampire_clan/gargoyle
	name = CLAN_GARGOYLE
	desc = "The Gargoyles are a vampiric bloodline created by the Tremere as their servitors. Although technically not a Tremere bloodline, the bloodline is largely under their control. In the Final Nights, Gargoyle populations seem to be booming; this is largely because older, free Gargoyles are coming out of hiding to join the Camarilla, because more indentured Gargoyles break free from the clutches of the Tremere, and because the free Gargoyles have also begun to Embrace more mortals on their own."
	curse = "All Gargoyles, much like the Nosferatu, are hideous to look at, a byproduct of their occult origins (and the varied Kindred stock from which they originate). This means that Gargoyles, just like the Nosferatu, have to hide their existence from common mortals, as their mere appearance is a breach of the Masquerade. In addition, the nature of the bloodline's origin manifests itself in the fact that Gargoyles are highly susceptible to mind control of any source. This weakness is intentional; a flaw placed into all Gargoyles by the Tremere in the hope that it would make them easier to control (and less likely to rebel)."
	clan_disciplines = list(
		/datum/discipline/fortitude,
		/datum/discipline/potence,
		/datum/discipline/visceratika
	)
	alt_sprite = "gargoyle"
	no_facial = FALSE
	violating_appearance = TRUE
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian
	current_accessory = "gargoyle_full"
	accessories = list("gargoyle_full", "gargoyle_left", "gargoyle_right", "gargoyle_broken", "gargoyle_round", "gargoyle_devil", "gargoyle_oni", "none")
	accessories_layers = list("gargoyle_full" = UNICORN_LAYER, "gargoyle_left" = UNICORN_LAYER, "gargoyle_right" = UNICORN_LAYER, "gargoyle_broken" = UNICORN_LAYER, "gargoyle_round" = UNICORN_LAYER, "gargoyle_devil" = UNICORN_LAYER, "gargoyle_oni" = UNICORN_LAYER, "none" = UNICORN_LAYER)
	whitelisted = FALSE

/datum/vampire_clan/gargoyle/on_gain(mob/living/carbon/human/H)
	..()
	H.dna.species.wings_icon = "Gargoyle"
	H.physiology.brute_mod = 0.8

/datum/vampire_clan/gargoyle/post_gain(mob/living/carbon/human/gargoyle)
	..()
	gargoyle.dna.species.GiveSpeciesFlight(gargoyle)

	if(gargoyle.shoes)
		qdel(gargoyle.shoes)
	gargoyle.Digitigrade_Leg_Swap(FALSE) //TODO: Remove shoes first

	gargoyle.remove_overlay(MARKS_LAYER)
	var/mutable_appearance/acc_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_legs_n_tails", -MARKS_LAYER)
	gargoyle.overlays_standing[MARKS_LAYER] = acc_overlay
	gargoyle.apply_overlay(MARKS_LAYER)
