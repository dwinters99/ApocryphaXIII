#define DOGGY_ANIMATION_COOLDOWN 30 DECISECONDS

/datum/action/gift
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	var/rage_req = 0
	var/gnosis_req = 0
	var/cool_down = 0

	var/allowed_to_proceed = FALSE

/datum/action/gift/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	. = ..()

/datum/action/gift/Trigger()
	. = ..()
	if(istype(owner, /mob/living/carbon))
		var/mob/living/carbon/H = owner
		if(H.stat == DEAD)
			allowed_to_proceed = FALSE
			return
		if(rage_req)
			if(H.auspice.rage < rage_req)
				to_chat(owner, "<span class='warning'>You don't have enough <b>RAGE</b> to do that!</span>")
				SEND_SOUND(owner, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
				allowed_to_proceed = FALSE
				return
			if(H.auspice.gnosis < gnosis_req)
				to_chat(owner, "<span class='warning'>You don't have enough <b>GNOSIS</b> to do that!</span>")
				SEND_SOUND(owner, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
				allowed_to_proceed = FALSE
				return
		if(cool_down+150 >= world.time)
			allowed_to_proceed = FALSE
			return
		cool_down = world.time
		allowed_to_proceed = TRUE
		if(rage_req)
			adjust_rage(-rage_req, owner, FALSE)
		if(gnosis_req)
			adjust_gnosis(-gnosis_req, owner, FALSE)
		to_chat(owner, "<span class='notice'>You activate the [name]...</span>")

/datum/action/gift/falling_touch
	name = "Falling Touch"
	desc = "This Gift allows the Garou to send her foe sprawling with but a touch."
	button_icon_state = "falling_touch"
	rage_req = 1

/datum/action/gift/falling_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/falling_touch.ogg', 75, FALSE)
		H.put_in_active_hand(new /obj/item/melee/touch_attack/werewolf(H))

/datum/action/gift/inspiration
	name = "Inspiration"
	desc = "The Garou with this Gift lends new resolve and righteous anger to his brethren."
	button_icon_state = "inspiration"
	rage_req = 1

/mob/living/carbon/Life()
	. = ..()
	if(inspired)
		if(stat != DEAD)
			adjustBruteLoss(-10, TRUE)
			var/obj/effect/celerity/C = new(get_turf(src))
			C.appearance = appearance
			C.dir = dir
			var/matrix/ntransform = matrix(C.transform)
			ntransform.Scale(2, 2)
			animate(C, transform = ntransform, alpha = 0, time = 3)

/mob/living/carbon/proc/inspired()
	inspired = TRUE
	to_chat(src, "<span class='notice'>You feel inspired...</span>")
	spawn(150)
		to_chat(src, "<span class='warning'>You no longer feel inspired...</span>")
		inspired = FALSE

/datum/action/gift/inspiration/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/inspiration.ogg', 75, FALSE)
		H.emote("scream")
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)
		for(var/mob/living/carbon/C in range(5, owner))
			if(C)
				if(iswerewolf(C) || isgarou(C))
					if(C.auspice.tribe == H.auspice.tribe)
						C.inspired()

/datum/action/gift/razor_claws
	name = "Razor Claws"
	desc = "By raking his claws over stone, steel, or another hard surface, the Ahroun hones them to razor sharpness."
	button_icon_state = "razor_claws"
	rage_req = 1

/datum/action/gift/razor_claws/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/razor_claws.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.dna.species.attack_verb = "slash"
			H.dna.species.attack_sound = 'sound/weapons/slash.ogg'
			H.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
			H.dna.species.punchdamagelow = 20
			H.dna.species.punchdamagehigh = 20
			H.agg_damage_plus = 5
			to_chat(owner, "<span class='notice'>You feel your claws sharpening...</span>")
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.adjust_veil(-1)
			spawn(150)
				H.dna.species.attack_verb = initial(H.dna.species.attack_verb)
				H.dna.species.attack_sound = initial(H.dna.species.attack_sound)
				H.dna.species.miss_sound = initial(H.dna.species.miss_sound)
				H.dna.species.punchdamagelow = initial(H.dna.species.punchdamagelow)
				H.dna.species.punchdamagehigh = initial(H.dna.species.punchdamagehigh)
				H.agg_damage_plus = 0
				to_chat(owner, "<span class='warning'>Your claws are not sharp anymore...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/razor_claws.ogg', 75, FALSE)
			var/mob/living/carbon/H = owner
			H.melee_damage_lower = H.melee_damage_lower+15
			H.melee_damage_upper = H.melee_damage_upper+15
			H.agg_damage_plus = 3
			to_chat(owner, "<span class='notice'>You feel your claws sharpening...</span>")
			spawn(150)
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				H.tox_damage_plus = 0
				to_chat(owner, "<span class='warning'>Your claws are not sharp anymore...</span>")

/datum/action/gift/beast_speech
	name = "Beast Speech"
	desc = "The werewolf with this Gift may communicate with any animals from fish to mammals."
	button_icon_state = "beast_speech"
	rage_req = 1

/datum/action/gift/beast_speech/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(length(C.beastmaster) > 3)
			var/mob/living/simple_animal/hostile/beastmaster/B = pick(C.beastmaster)
			qdel(B)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/wolves.ogg', 75, FALSE)
		if(!length(C.beastmaster))
			var/datum/action/beastmaster_stay/E1 = new()
			E1.Grant(C)
			var/datum/action/beastmaster_deaggro/E2 = new()
			E2.Grant(C)
		var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(C))
		D.my_creator = C
		C.beastmaster |= D
		D.beastmaster = C

/datum/action/gift/call_of_the_wyld
	name = "Call Of The Wyld"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and imbue it with great emotion, stirring the hearts of fellow Garou and chilling the bones of all others."
	button_icon_state = "call_of_the_wyld"
	rage_req = 1

/datum/action/gift/call_of_the_wyld/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.emote("howl")
		playsound(get_turf(C), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
		for(var/mob/living/carbon/A in orange(6, owner))
			if(A)
				if(isgarou(A) || iswerewolf(A))
					A.emote("howl")
					playsound(get_turf(A), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
					spawn(10)
						adjust_gnosis(1, A, TRUE)

/datum/action/gift/mindspeak
	name = "Mindspeak"
	desc = "By invoking the power of waking dreams, the Garou can place any chosen characters into silent communion."
	button_icon_state = "mindspeak"

/datum/action/gift/mindspeak/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/new_thought = input(owner, "What do you want to tell to your Tribe?") as text|null
		if(new_thought)
			var/mob/living/carbon/C = owner
			to_chat(C, "You transfer this message to your tribe members nearby: <b>[sanitize_text(new_thought)]</b>")
			for(var/mob/living/carbon/A in orange(9, owner))
				if(A)
					if(isgarou(A) || iswerewolf(A))
						if(A.auspice.tribe == C.auspice.tribe)
							to_chat(A, "You hear a message in your head... <b>[sanitize_text(new_thought)]</b>")

/datum/action/gift/resist_pain
	name = "Resist Pain"
	desc = "Through force of will, the Philodox is able to ignore the pain of his wounds and continue acting normally."
	button_icon_state = "resist_pain"
	rage_req = 2

/datum/action/gift/resist_pain/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.physiology.armor.melee = 40
			H.physiology.armor.bullet = 25
			to_chat(owner, "<span class='notice'>You feel your skin thickering...</span>")
			spawn(15 SECONDS)
				H.physiology.armor.melee = initial(H.physiology.armor.melee)
				H.physiology.armor.bullet = initial(H.physiology.armor.bullet)
				to_chat(owner, "<span class='warning'>Your skin is thin again...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
			var/mob/living/carbon/werewolf/H = owner
			H.werewolf_armor = 40
			to_chat(owner, "<span class='notice'>You feel your skin thickering...</span>")
			spawn(15 SECONDS)
				H.werewolf_armor = initial(H.werewolf_armor)
				to_chat(owner, "<span class='warning'>Your skin is thin again...</span>")

/datum/action/gift/scent_of_the_true_form
	name = "Scent Of The True Form"
	desc = "This Gift allows the Garou to determine the true nature of a person."
	button_icon_state = "scent_of_the_true_form"
	gnosis_req = 1

/datum/action/gift/scent_of_the_true_form/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(HAS_TRAIT(owner, TRAIT_SCENTTRUEFORM))
			REMOVE_TRAIT(owner, TRAIT_SCENTTRUEFORM, REF(src))
			to_chat(owner, "<span class='notice'>You allow the essence of the spirit to leave your senses.</span>")

		else
			ADD_TRAIT(owner, TRAIT_SCENTTRUEFORM, REF(src))
			to_chat(owner, "<span class='notice'>Your nose gains a clarity for the supernal around you...</span>")


/datum/action/gift/truth_of_gaia
	name = "Truth Of Gaia"
	desc = "As judges of the Litany, Philodox have the ability to sense whether others have spoken truth or falsehood."
	button_icon_state = "truth_of_gaia"

/datum/action/gift/truth_of_gaia/Trigger()
	. = ..()
//	if(allowed_to_proceed)
//

/datum/action/gift/mothers_touch
	name = "Mother's Touch"
	desc = "The Garou is able to heal the wounds of any living creature, aggravated or otherwise, simply by laying hands over the afflicted area."
	button_icon_state = "mothers_touch"
	rage_req = 2

/datum/action/gift/mothers_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		H.put_in_active_hand(new /obj/item/melee/touch_attack/mothers_touch(H))

/datum/action/gift/sense_wyrm
	name = "Sense Wyrm"
	desc = "This Gift allows the werewolf to trace the location of all wyrm-tainted entities within the area."
	button_icon_state = "sense_wyrm"
	rage_req = 1

/datum/action/gift/sense_wyrm/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/list/mobs_in_range = list()
		for(var/mob/living/carbon/target in orange(owner, 30))
			mobs_in_range += target
		for(var/mob/living/carbon/target in mobs_in_range)
			var/is_wyrm = 0
			if(iscathayan(target))
				var/mob/living/carbon/human/kj = target
				if(!kj.check_kuei_jin_alive())
					is_wyrm = 1
			if (iskindred(target))
				var/mob/living/carbon/human/vampire = target
				if ((vampire.morality_path?.score < 7) || vampire.client?.prefs?.is_enlightened)
					is_wyrm = 1
				if ((vampire.clan?.name == CLAN_BAALI) || ( (vampire.client?.prefs?.is_enlightened && (vampire.morality_path?.score > 7)) || (!vampire.client?.prefs?.is_enlightened && (vampire.morality_path?.score < 4)) ))
					is_wyrm = 1
			if (isgarou(target) || iswerewolf(target))
				var/mob/living/carbon/wolf = target
				if(wolf.auspice.tribe.name == "Black Spiral Dancers")
					is_wyrm = 1
			if(is_wyrm)
				to_chat(owner, "A stain is found at [get_area_name(target)], X:[target.x] Y:[target.y].")
				is_wyrm = 0

/datum/action/gift/spirit_speech
	name = "Spirit Speech"
	desc = "This Gift allows the Garou to communicate with encountered spirits."
	button_icon_state = "spirit_speech"

/datum/action/gift/spirit_speech/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.see_invisible = SEE_INVISIBLE_OBSERVER
		spawn(200)
			C.see_invisible = initial(C.see_invisible)

/datum/action/gift/blur_of_the_milky_eye
	name = "Blur Of The Milky Eye"
	desc = "The Garou's form becomes a shimmering blur, allowing him to pass unnoticed among others."
	button_icon_state = "blur_of_the_milky_eye"
	rage_req = 2

/datum/action/gift/blur_of_the_milky_eye/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.alpha = 36
		playsound(get_turf(owner), 'code/modules/wod13/sounds/milky_blur.ogg', 75, FALSE)
		spawn(20 SECONDS)
			C.alpha = 255

/datum/action/gift/open_seal
	name = "Open Seal"
	desc = "With this Gift, the Garou can open nearly any sort of closed or locked physical device."
	button_icon_state = "open_seal"

/datum/action/gift/open_seal/Trigger()
	. = ..()
	if(allowed_to_proceed)
		for(var/obj/structure/vampdoor/V in range(5, owner))
			if(V)
				if(V.closed)
					if(V.lockpick_difficulty < 10)
						V.locked = FALSE
						playsound(V, V.open_sound, 75, TRUE)
						V.icon_state = "[V.baseicon]-0"
						V.density = FALSE
						V.opacity = FALSE
						V.layer = OPEN_DOOR_LAYER
						to_chat(owner, "<span class='notice'>You open [V].</span>")
						V.closed = FALSE

/datum/action/gift/infectious_laughter
	name = "Infectious Laughter"
	desc = "When the Ragabash laughs, those around her are compelled to follow along, forgetting their grievances."
	button_icon_state = "infectious_laughter"
	rage_req = 1

/datum/action/gift/infectious_laughter/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.emote("laugh")
		C.Stun(10)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/infectious_laughter.ogg', 100, FALSE)
		for(var/mob/living/L in oviewers(4, owner))
			if(L)
				L.emote("laugh")
				L.Stun(20)

/datum/action/gift/rage_heal
	name = "Rage Heal"
	desc = "This Gift allows the Garou to heal severe injuries with rage."
	button_icon_state = "rage_heal"
	rage_req = 1
	check_flags = null

/datum/action/gift/rage_heal/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		var/obj/item/organ/brain/brain = C.getorganslot(ORGAN_SLOT_BRAIN)
		if(C.stat != DEAD)
			SEND_SOUND(owner, sound('code/modules/wod13/sounds/rage_heal.ogg', 0, 0, 75))
			C.adjustBruteLoss(-40*C.auspice.level, TRUE)
			C.adjustFireLoss(-30*C.auspice.level, TRUE)
			C.adjustCloneLoss(-10*C.auspice.level, TRUE)
			C.adjustToxLoss(-10*C.auspice.level, TRUE)
			C.adjustOxyLoss(-20*C.auspice.level, TRUE)
			C.bloodpool = min(C.bloodpool + C.auspice.level, C.maxbloodpool)
			C.blood_volume = min(C.blood_volume + 56 * C.auspice.level, BLOOD_VOLUME_NORMAL)
			if(ishuman(owner))
				var/mob/living/carbon/human/BD = owner
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
				if(length(BD.all_wounds))
					var/datum/wound/W = pick(BD.all_wounds)
					W.remove_wound()
			if (brain)
				brain.applyOrganDamage(-30*C.auspice.level)
				brain.cure_all_traumas(TRAUMA_RESILIENCE_WOUND)

/datum/action/change_apparel
	name = "Change Apparel"
	desc = "Choose the clothes of your Crinos form."
	button_icon_state = "choose_apparel"
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

/datum/action/change_apparel/Trigger()
	. = ..()
	var/mob/living/carbon/werewolf/crinos/C = owner
	if(C.stat == CONSCIOUS)
		if(C.sprite_apparel == 4)
			C.sprite_apparel = 0
		else
			C.sprite_apparel = min(4, C.sprite_apparel+1)

/datum/action/gift/hispo
	name = "Hispo Form"
	desc = "Change your Lupus form into Hispo and backwards."
	button_icon_state = "hispo"

/datum/action/gift/hispo/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/werewolf/lupus/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
		var/matrix/ntransform = matrix(owner.transform)
		if(H.hispo)
			ntransform.Scale(0.95, 0.95)
			animate(owner, transform = ntransform, color = "#000000", time = DOGGY_ANIMATION_COOLDOWN)
			addtimer(CALLBACK(src, PROC_REF(transform_lupus), H), DOGGY_ANIMATION_COOLDOWN)
		else
			ntransform.Scale(1.05, 1.05)
			animate(owner, transform = ntransform, color = "#000000", time = DOGGY_ANIMATION_COOLDOWN)
			addtimer(CALLBACK(src, PROC_REF(transform_hispo), H), DOGGY_ANIMATION_COOLDOWN)

/datum/action/gift/hispo/proc/transform_lupus(mob/living/carbon/werewolf/lupus/H)
	if(HAS_TRAIT(H, TRAIT_DOGWOLF))
		H.icon = 'code/modules/wod13/werewolf_lupus.dmi'
	else
		H.icon = 'code/modules/wod13/tfn_lupus.dmi'
	H.pixel_w = 0
	H.pixel_z = 0
	H.melee_damage_lower = initial(H.melee_damage_lower)
	H.melee_damage_upper = initial(H.melee_damage_upper)
	H.armour_penetration = initial(H.armour_penetration)
	H.hispo = FALSE
	H.regenerate_icons()
	H.update_transform()
	animate(H, transform = null, color = "#FFFFFF", time = 1)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/hispoform)
	H.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)

/datum/action/gift/hispo/proc/transform_hispo(mob/living/carbon/werewolf/lupus/H)
	H.icon = 'code/modules/wod13/hispo.dmi'
	H.pixel_w = -16
	H.pixel_z = -16
	H.melee_damage_lower = 45
	H.melee_damage_upper = 45
	H.armour_penetration = 50
	H.hispo = TRUE
	H.regenerate_icons()
	H.update_transform()
	animate(H, transform = null, color = "#FFFFFF", time = 1)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	H.add_movespeed_modifier(/datum/movespeed_modifier/hispoform)

/datum/movespeed_modifier/hispoform
	multiplicative_slowdown = -0.5


/datum/action/gift/glabro
	name = "Glabro Form"
	desc = "Change your Homid form into Glabro and backwards."
	button_icon_state = "glabro"

/datum/action/gift/glabro/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/human/H = owner
		var/datum/species/garou/G = H.dna.species
		if (!HAS_TRAIT(owner, TRAIT_CORAX))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
		if(G.glabro)
			H.remove_overlay(PROTEAN_LAYER)
			G.punchdamagelow -= 15
			G.punchdamagehigh -= 15
			H.physique = H.physique-2
			H.physiology.armor.melee -= 15
			H.physiology.armor.bullet -= 15
			var/matrix/M = matrix()
			M.Scale(1)
			animate(H, transform = M, time = 1 SECONDS)
			G.glabro = FALSE
			H.update_icons()
		else
			if (HAS_TRAIT(owner, TRAIT_CORAX))
				to_chat(owner,"<span class='warning'>Corax do not have a Glabro form to shift into.</span>")
				return
			else
				H.remove_overlay(PROTEAN_LAYER)
				var/mob/living/carbon/werewolf/crinos/crinos = H.transformator.crinos_form?.resolve()
				var/mutable_appearance/glabro_overlay = mutable_appearance('code/modules/wod13/werewolf_abilities.dmi', crinos?.sprite_color, -PROTEAN_LAYER)
				H.overlays_standing[PROTEAN_LAYER] = glabro_overlay
				H.apply_overlay(PROTEAN_LAYER)
				G.punchdamagelow += 15
				G.punchdamagehigh += 15
				H.physique = H.physique+2
				H.physiology.armor.melee += 15
				H.physiology.armor.bullet += 15
				var/matrix/M = matrix()
				M.Scale(1.23)
				animate(H, transform = M, time = 1 SECONDS)
				G.glabro = TRUE
				H.update_icons()

/datum/action/gift/howling
	name = "Howl"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and communicate a single word or concept to all other Garou across the city."
	button_icon_state = "call_of_the_wyld"
	rage_req = 1
	cool_down = 5
	check_flags = null
	var/list/howls = list(
		"attack" = list(
			"menu" = "Attack",
			"message" = "A wolf howls a fierce call to attack"
		),
		"retreat" = list(
			"menu" = "Retreat",
			"message" = "A wolf howls a warning to retreat"
		),
		"help" = list(
			"menu" = "Help",
			"message" = "A wolf howls a desperate plea for help"
		),
		"gather" = list(
			"menu" = "Gather",
			"message" = "A wolf howls to gather the pack"
		),
		"victory" = list(
			"menu" = "Victory",
			"message" = "A wolf howls in celebration of victory"
		),
		"dying" = list(
			"menu" = "Dying",
			"message" = "A wolf howls in pain and despair"
		),
		"mourning" = list(
			"menu" = "Mourning",
			"message" = "A wolf howls in deep mourning for the fallen"
		)
	)

/datum/action/gift/howling/Trigger()
	. = ..()
	if(allowed_to_proceed)

		if(istype(get_area(owner), /area/vtm/interior/penumbra))
			to_chat(owner, span_warning("Your howl echoes and dissapates into the Umbra, it's sound blanketed by the spiritual energy of the Velvet Shadow."))
			return

		var/mob/living/carbon/C = owner
		var/list/menu_options = list()
		for (var/howl_key in howls)
			menu_options += howls[howl_key]["menu"]
		menu_options += "Cancel"

		var/choice = tgui_input_list(owner, "Select a howl to use!", "Howl Selection", menu_options)
		if(choice && choice != "Cancel")
			var/howl
			for (var/howl_key in howls)
				if (howls[howl_key]["menu"] == choice)
					howl = howls[howl_key]
					break

			var/message = howl["message"]
			var/tribe = C.auspice.tribe.name
			if (tribe)
				message = replacetext(message, "tribe", tribe)

			C.emote("howl")
			var/origin_turf = get_turf(C)
			playsound(origin_turf, pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 50, FALSE)
			var/list/sound_hearers = list()

			for(var/mob/living/carbon/HearingGarou in range(17))
				if(isgarou(HearingGarou) || iswerewolf(HearingGarou))
					sound_hearers += HearingGarou

			var/howl_details
			var/final_message
			for(var/mob/living/carbon/Garou in GLOB.player_list)
				if(isgarou(Garou) || iswerewolf(Garou) && !owner)
					if(!sound_hearers.Find(Garou))
						Garou.playsound_local(get_turf(Garou), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 25, FALSE)
					howl_details = get_message(Garou, origin_turf)
					final_message = message + howl_details
					to_chat(Garou, final_message, confidential = TRUE)


/datum/action/gift/howling/proc/get_message(mob/living/carbon/Garou, turf/origin_turf)

	var/distance = get_dist(Garou, origin_turf)
	var/dirtext = " to the "
	var/direction = get_dir(Garou, origin_turf)

	switch(direction)
		if(NORTH)
			dirtext += "north"
		if(SOUTH)
			dirtext += "south"
		if(EAST)
			dirtext += "east"
		if(WEST)
			dirtext += "west"
		if(NORTHWEST)
			dirtext += "northwest"
		if(NORTHEAST)
			dirtext += "northeast"
		if(SOUTHWEST)
			dirtext += "southwest"
		if(SOUTHEAST)
			dirtext += "southeast"
		else //Where ARE you.
			dirtext = "although I cannot make out an exact direction"

	var/disttext
	switch(distance)
		if(0 to 20)
			disttext = " within 20 feet"
		if(20 to 40)
			disttext = " 20 to 40 feet away"
		if(40 to 80)
			disttext = " 40 to 80 feet away"
		if(80 to 160)
			disttext = " far"
		else
			disttext = " very far"

	var/place = get_area_name(origin_turf)

	var/returntext = "[disttext],[dirtext], at [place]."

	return returntext

#undef DOGGY_ANIMATION_COOLDOWN
