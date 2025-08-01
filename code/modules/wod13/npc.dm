#define BANDIT_TYPE_NPC /mob/living/carbon/human/npc/bandit
#define POLICE_TYPE_NPC /mob/living/carbon/human/npc/police

/mob/living/carbon/human/npc
	name = "Loh ebanii"
	/// Until we do a full NPC refactor (see: rewriting every single bit of code)
	/// use this to determine NPC weapons and their chances to spawn with them -- assuming you want the NPC to do that
	/// Otherwise just set it under the NPC's type as
	/// my_weapon = type_path
	/// my_backup_weapon = type_path
	/// This only determines my_weapon, you set my_backup_weapon yourself
	/// The last entry in the list for a type of NPC should always have 100 as the index
	var/static/list/role_weapons_chances = list(
		BANDIT_TYPE_NPC = list(
			/obj/item/gun/ballistic/automatic/vampire/deagle = 33,
			/obj/item/gun/ballistic/vampire/revolver/snub = 33,
			/obj/item/melee/vampirearms/baseball = 100,
		),
		POLICE_TYPE_NPC = list(
			/obj/item/gun/ballistic/vampire/revolver = 66,
			/obj/item/gun/ballistic/automatic/vampire/ar15 = 100,
		)
	)
	a_intent = INTENT_HELP
	var/datum/socialrole/socialrole

	var/is_talking = FALSE
	var/last_annoy = 0
	COOLDOWN_DECLARE(car_dodge)
	var/hostile = FALSE
	var/fights_anyway = FALSE
	var/last_danger_meet = 0
	var/mob/living/danger_source
	var/atom/movable/less_danger
	var/mob/living/last_attacker
	var/last_health = 100
	var/mob/living/last_damager

	var/turf/walktarget	//dlya movementa

	var/last_grab = 0

	var/tupik_steps = 0
	var/tupik_loc

	var/stopturf = 1

	var/extra_mags=2
	var/extra_loaded_rounds=10

	var/has_weapon = FALSE

	var/my_weapon_type = null
	var/obj/item/my_weapon = null

	var/my_backup_weapon_type = null
	var/obj/item/my_backup_weapon = null

	var/spawned_weapon = FALSE

	var/spawned_backup_weapon = FALSE

	var/ghoulificated = FALSE

	var/staying = FALSE

	var/lifespan = 0	//How many cycles. He'll be deleted if over than a ten thousand
	var/old_movement = FALSE
	var/max_stat = 2

	var/list/spotted_bodies = list()

	var/is_criminal = FALSE

	var/list/drop_on_death_list = null

/mob/living/carbon/human/npc/LateInitialize()
	. = ..()
	if(role_weapons_chances.Find(type))
		for(var/weapon in role_weapons_chances[type])
			if(prob(role_weapons_chances[type][weapon]))
				my_weapon = new weapon(src)
				break
	if(!my_weapon && my_weapon_type)
		my_weapon = new my_weapon_type(src)



	if(my_weapon)
		has_weapon = TRUE
		equip_to_appropriate_slot(my_weapon)
		if(istype(my_weapon, /obj/item/gun/ballistic))
			RegisterSignal(my_weapon, COMSIG_GUN_FIRED, PROC_REF(handle_gun))
			RegisterSignal(my_weapon, COMSIG_GUN_EMPTY, PROC_REF(handle_empty_gun))
		register_sticky_item(my_weapon)

	if(my_backup_weapon_type)
		my_backup_weapon = new my_backup_weapon_type(src)
		equip_to_appropriate_slot(my_backup_weapon)
		register_sticky_item(my_backup_weapon)

//====================Sticky Item Handling====================
/mob/living/carbon/human/npc/proc/register_sticky_item(obj/item/my_item)
	ADD_TRAIT(my_item, TRAIT_NODROP, NPC_ITEM_TRAIT)
	if(!drop_on_death_list?.len)
		drop_on_death_list = list()
	drop_on_death_list += my_item

/mob/living/carbon/human/npc/death(gibbed)
	. = ..()
	if(drop_on_death_list?.len)
		for(var/obj/item/dropping_item in drop_on_death_list)
			drop_on_death_list -= dropping_item
			if(HAS_TRAIT_FROM(dropping_item, TRAIT_NODROP, NPC_ITEM_TRAIT))
				REMOVE_TRAIT(dropping_item, TRAIT_NODROP, NPC_ITEM_TRAIT)
			dropItemToGround(dropping_item, TRUE)

//If an npc's item has TRAIT_NODROP, we NEVER drop it, even if it is forced.
/mob/living/carbon/human/npc/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	if(I && HAS_TRAIT(I, TRAIT_NODROP))
		return FALSE
	. = ..()
//============================================================


/datum/movespeed_modifier/npc
	multiplicative_slowdown = 2

/datum/socialrole
	//For randomizing
	var/list/s_tones = list("albino",
		"caucasian1",
		"caucasian2",
		"caucasian3",
		"latino",
		"mediterranean",
		"asian1",
		"asian2",
		"arab",
		"indian",
		"african1",
		"african2")
	var/min_age = 18
	var/max_age = 85
	var/preferedgender
	var/list/male_names = list("Jack",
		"Robert",
		"Cornelius",
		"Tyler")
	var/list/female_names = list("Marla")
	var/list/surnames = list("Durden",
		"Polson",
		"Singer")

	//Hair shit
	var/list/hair_colors = list("#040404",	//Black
		"#120b05",	//Dark Brown
		"#342414",	//Brown
		"#554433",	//Light Brown
		"#695c3b",	//Dark Blond
		"#ad924e",	//Blond
		"#dac07f",	//Light Blond
		"#802400",	//Ginger
		"#a5380e",	//Ginger alt
		"#ffeace",	//Albino
		"#650b0b",	//Punk Red
		"#14350e",	//Punk Green
		"#080918")	//Punk Blue

	var/list/male_hair = list("Bald",
		"Afro",
		"Afro 2",
		"Afro (Large)",
		"Balding Hair",
		"Bedhead",
		"Bedhead 2",
		"Bedhead 3",
		"Boddicker",
		"Bowlcut",
		"Bowlcut 2",
		"Business Hair",
		"Business Hair 2",
		"Business Hair 3",
		"Business Hair 4",
		"Bun (Manbun)",
		"Buzzcut",
		"Comet",
		"CIA",
		"Coffee House",
		"Combover",
		"Crewcut",
		"Father",
		"Flat Top",
		"Gelled Back",
		"Joestar",
		"Keanu Hair",
		"Mohawk",
		"Mohawk (Shaved)",
		"Mohawk (Unshaven)",
		"Oxton",
		"Pompadour",
		"Ronin",
		"Shaved")
	var/list/male_facial = list("Beard (Abraham Lincoln)",
		"Beard (Chinstrap)",
		"Beard (Dwarf)",
		"Beard (Full)",
		"Beard (Cropped Fullbeard)",
		"Beard (Goatee)",
		"Beard (Hipster)",
		"Beard (Neckbeard)",
		"Beard (Very Long)",
		"Beard (Martial Artist)",
		"Beard (Moonshiner)",
		"Beard (Long)",
		"Beard (Volaju)",
		"Beard (Three o Clock Shadow)",
		"Beard (Five o Clock Shadow)",
		"Beard (Seven o Clock Shadow)",
		"Moustache (Fu Manchu)",
		"Moustache (Hulk Hogan)",
		"Moustache (Watson)",
		"Sideburns (Elvis)",
		"Sideburns (Mutton Chops)",
		"Sideburns",
		"Shaved")
	var/list/female_hair = list("Ahoge",
		"Long Bedhead",
		"Beehive",
		"Beehive 2",
		"Bob Hair",
		"Bob Hair 2",
		"Bob Hair 3",
		"Bob Hair 4",
		"Bobcurl",
		"Braided",
		"Braided Front",
		"Braid (Short)",
		"Braid (Low)",
		"Bun Head",
		"Bun Head 2",
		"Bun Head 3",
		"Bun (Large)",
		"Bun (Tight)",
		"Double Bun",
		"Emo",
		"Emo Fringe",
		"Feather",
		"Gentle",
		"Long Hair 1",
		"Long Hair 2",
		"Long Hair 3",
		"Long Over Eye",
		"Long Emo",
		"Long Fringe",
		"Ponytail",
		"Ponytail 2",
		"Ponytail 3",
		"Ponytail 4",
		"Ponytail 5",
		"Ponytail 6",
		"Ponytail 7",
		"Ponytail (High)",
		"Ponytail (Short)",
		"Ponytail (Long)",
		"Ponytail (Country)",
		"Ponytail (Fringe)",
		"Poofy",
		"Short Hair Rosa",
		"Shoulder-length Hair",
		"Volaju")

	//For equiping with random
	var/list/backpacks = list(/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather)
	var/list/shoes = list()
	var/list/uniforms = list()
	var/list/belts = list()
	var/list/suits = list()
	var/list/hats = list()
	var/list/gloves = list()
	var/list/masks = list()
	var/list/neck = list()
	var/list/ears = list()
	var/list/glasses = list()
	var/list/inhand_items = list()
	var/list/pockets = list()

	//For workers and police
	var/obj/item/card/id/id_type

	//What will npc use in fight, if so
	var/obj/item/melee/melee_weapon
	var/obj/item/gun/range_weapon

	//For reaction
	var/list/male_phrases = list(
		"My wife is waiting for me at home...",
		"Sorry, pal, not today.",
		"Go find yourself someone at the bar, I'm busy.")
	var/list/female_phrases = list(
		"Buy yourself a watch.",
		"I'm going to scream if you keep it up!",
		"Don't touch me.")
	var/list/neutral_phrases = list(
		"Fuck off.",
		"Go on your way.",
		"Not the best time to talk right now, pal.",
		"Мgmmph...",
		"Do I know you?",
		"I don't have much time.")
	var/list/random_phrases = list(
		"You a foreigner?...",
		"It seems I've been going around here in circles for the third time, already.",
		"Watch where you're walkin'!",
		"Go back to the drains where you came from.",
		"Tourists... Pheh.",
		"Rumors travel fast.")
	var/list/answer_phrases = list(
		"I agree.",
		"Yes-yes...",
		"Exactly.",
		"Maybe.",
		"Exactly.",
		"Affirmative..")
	var/list/help_phrases = list(
		"Help!",
		"Help Me!!",
		"What the hell's going on here?!",
		"Shoot!!")
	var/list/car_dodged = list(
		"WOAH!",
		"Watch where you're going!",
		"Holy shit!",
		"Watch it!",
		"Learn to drive!",
		"You almost ran me over!",
		"What the fuck?!"
	)

	var/is_criminal = FALSE

/mob/living/carbon/human/npc/proc/AssignSocialRole(datum/socialrole/S, dont_random = FALSE)
	if(!S)
		return
	physique = rand(1, max_stat)
	social = rand(1, max_stat)
	mentality = rand(1, max_stat)
	lockpicking = rand(1, max_stat)
	blood = rand(1, 2)
	maxHealth = round(initial(maxHealth)+(initial(maxHealth)/3)*(physique))
	health = round(initial(health)+(initial(health)/3)*(physique))
	last_health = health
	socialrole = new S()

	is_criminal = socialrole.is_criminal
	if(GLOB.winter && !length(socialrole.suits))
		socialrole.suits = list(/obj/item/clothing/suit/vampire/coat/winter, /obj/item/clothing/suit/vampire/coat/winter/alt)
	if(GLOB.winter && !length(socialrole.neck))
		if(prob(50))
			socialrole.neck = list(/obj/item/clothing/neck/vampire/scarf/red,
							/obj/item/clothing/neck/vampire/scarf,
							/obj/item/clothing/neck/vampire/scarf/blue,
							/obj/item/clothing/neck/vampire/scarf/green,
							/obj/item/clothing/neck/vampire/scarf/white)
	if(!dont_random)
		gender = pick(MALE, FEMALE)
		if(socialrole.preferedgender)
			gender = socialrole.preferedgender
		body_type = gender
		var/list/m_names = list()
		var/list/f_names = list()
		var/list/s_names = list()
		if(socialrole.male_names)
			m_names = socialrole.male_names
		else
			m_names = GLOB.first_names_male
		if(socialrole.female_names)
			f_names = socialrole.female_names
		else
			f_names = GLOB.first_names_female
		if(socialrole.surnames)
			s_names = socialrole.surnames
		else
			s_names = GLOB.last_names
		age = rand(socialrole.min_age, socialrole.max_age)
		skin_tone = pick(socialrole.s_tones)
		if(age >= 55)
			hair_color = "#a2a2a2"
			facial_hair_color = hair_color
		else
			hair_color = pick(socialrole.hair_colors)
			facial_hair_color = hair_color
		if(gender == MALE)
			hairstyle = pick(socialrole.male_hair)
			if(prob(25) || age >= 25)
				facial_hairstyle = pick(socialrole.male_facial)
			else
				facial_hairstyle = "Shaved"
			real_name = "[pick(m_names)] [pick(s_names)]"
		else
			hairstyle = pick(socialrole.female_hair)
			facial_hairstyle = "Shaved"
			real_name = "[pick(f_names)] [pick(s_names)]"
		name = real_name
		dna.real_name = real_name
		var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
		if(organ_eyes)
			organ_eyes.eye_color = random_eye_color()
		underwear = random_underwear(gender)
		if(prob(50))
			underwear_color = organ_eyes.eye_color
		if(prob(50) || gender == FEMALE)
			undershirt = random_undershirt(gender)
		if(prob(25))
			socks = random_socks()
		update_body()
		update_hair()
		update_body_parts()
		dna.update_dna_identity()

	var/datum/outfit/O = new()
	if(length(socialrole.backpacks))
		O.back = pick(socialrole.backpacks)
	if(length(socialrole.uniforms))
		O.uniform = pick(socialrole.uniforms)
	if(length(socialrole.belts))
		O.belt = pick(socialrole.belts)
	if(length(socialrole.suits))
		O.suit = pick(socialrole.suits)
	if(length(socialrole.gloves))
		O.gloves = pick(socialrole.gloves)
	if(length(socialrole.shoes))
		O.shoes = pick(socialrole.shoes)
	if(length(socialrole.hats))
		O.head = pick(socialrole.hats)
	if(length(socialrole.masks))
		O.mask = pick(socialrole.masks)
	if(length(socialrole.neck))
		O.neck = pick(socialrole.neck)
	if(length(socialrole.ears))
		O.ears = pick(socialrole.ears)
	if(length(socialrole.glasses))
		O.glasses = pick(socialrole.glasses)
	if(length(socialrole.inhand_items))
		O.r_hand = pick(socialrole.inhand_items)
	if(socialrole.id_type)
		O.id = socialrole.id_type
	if(O.uniform && length(socialrole.pockets))
		O.l_pocket = pick(socialrole.pockets)
		if(length(socialrole.pockets) > 1 && prob(50))
			var/list/another_pocket = socialrole.pockets.Copy()
			another_pocket -= O.l_pocket
			O.r_pocket = pick(another_pocket)
	equipOutfit(O)
	qdel(O)

/mob/living/carbon/human/npc/proc/GetSayDelay(message)
	var/delay = length_char(message)
	return delay

/mob/living/carbon/human/npc/proc/RealisticSay(message)
	walk(src,0)
	if(!message)
		return
	if(is_talking)
		return
	if(stat >= HARD_CRIT)
		return
	is_talking = TRUE
	var/delay = round(length_char(message)/2)
	spawn(5)
		remove_overlay(SAY_LAYER)
		var/mutable_appearance/say_overlay = mutable_appearance('icons/mob/talk.dmi', "default0", -SAY_LAYER)
		overlays_standing[SAY_LAYER] = say_overlay
		apply_overlay(SAY_LAYER)
		spawn(max(1, delay))
			if(stat != DEAD)
				remove_overlay(SAY_LAYER)
				say(message)
				is_talking = FALSE

/mob/living/carbon/human/npc/proc/Annoy(atom/source)
	walk(src,0)
	if(CheckMove())
		return
	if(is_talking)
		return
	if(danger_source)
		return
	if(stat >= HARD_CRIT)
		return
	if(world.time <= last_annoy+50)
		return
	if(source)
		spawn(rand(3, 7))
			face_atom(source)
	last_annoy = world.time
	var/phrase
	if(prob(50))
		phrase = pick(socialrole.neutral_phrases)
	else
		if(gender == MALE)
			phrase = pick(socialrole.male_phrases)
		else
			phrase = pick(socialrole.female_phrases)
	RealisticSay(phrase)

/mob/living/carbon/human/Bump(atom/Obstacle)
	. = ..()
	var/mob/living/carbon/human/npc/NPC = locate() in get_turf(Obstacle)
	if(NPC)
		if(a_intent != INTENT_HELP)
			NPC.Annoy(src)

/mob/living/carbon/Move(NewLoc, direct)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.update_shadow()
	if(istype(src, /mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/CPN = src
		if(CPN.CheckMove())
			walk(src,0)
		var/getaway = CPN.stopturf+1
		if(!CPN.old_movement)
			getaway = 2
		if(get_dist(src, CPN.walktarget) <= getaway)
			walk(src,0)
			CPN.walktarget = null
	if(HAS_TRAIT(src, TRAIT_RUBICON))
		if(istype(NewLoc, /turf/open/floor/plating/shit))
			return
	. = ..()


/mob/living/carbon/human/toggle_resting()
	..()
	update_shadow()

/mob/living/carbon/human/proc/update_shadow()
	if(body_position != LYING_DOWN)
		if(!overlays_standing[UNDERSHADOW_LAYER])
			var/mutable_appearance/lying_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "shadow", -UNDERSHADOW_LAYER)
			lying_overlay.pixel_z = -4
			lying_overlay.alpha = 64
			overlays_standing[UNDERSHADOW_LAYER] = lying_overlay
			apply_overlay(UNDERSHADOW_LAYER)
	else if(overlays_standing[UNDERSHADOW_LAYER])
		remove_overlay(UNDERSHADOW_LAYER)

/mob/living/carbon/human/npc/attack_hand(mob/user)
	if(user)
		if(user.a_intent == INTENT_HELP)
			Annoy(user)
		if(user.a_intent == INTENT_DISARM)
			Aggro(user, TRUE)
		if(user.a_intent == INTENT_HARM)
			for(var/mob/living/carbon/human/npc/NEPIC in oviewers(7, src))
				NEPIC.Aggro(user)
			Aggro(user, TRUE)
	..()

/mob/living/carbon/human/npc/on_hit(obj/projectile/P)
	. = ..()
	if(P)
		if(P.firer)
			for(var/mob/living/carbon/human/npc/NEPIC in oviewers(7, src))
				NEPIC.Aggro(P.firer)
			Aggro(P.firer, TRUE)
			var/witness_count
			for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
				if(NEPIC && NEPIC.stat != DEAD)
					witness_count++
				if(witness_count > 1)
					for(var/obj/item/police_radio/radio in GLOB.police_radios)
						radio.announce_crime("victim", get_turf(src))
					for(var/obj/machinery/p25transceiver/police/radio in GLOB.p25_tranceivers)
						if(radio.p25_network == "police")
							radio.announce_crime("victim", get_turf(src))
							break

/mob/living/carbon/human/npc/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	. = ..()
	if(throwingdatum?.thrower && (AM.throwforce > 5 || (AM.throwforce && src.health < src.maxHealth)))
		Aggro(throwingdatum.thrower, TRUE)

/mob/living/carbon/human/npc/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(user)
		if(W.force > 5 || (W.force && src.health < src.maxHealth))
			for(var/mob/living/carbon/human/npc/NEPIC in oviewers(7, src))
				NEPIC.Aggro(user)
			Aggro(user, TRUE)

/mob/living/carbon/human/npc/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	. = ..()
	last_grab = world.time

/mob/living/carbon/human/npc/proc/EmoteAction()
	walk(src,0)
	if(CheckMove())
		return
	var/shitemote = pick("sigh", "smile", "stare", "look", "spin", "giggle", "blink", "blush", "nod", "sniff", "shrug", "cough", "yawn")
	if(!is_talking)
		is_talking = TRUE
		spawn(rand(5, 10))
			emote(shitemote)
			is_talking = FALSE

/mob/living/carbon/human/npc/proc/StareAction()
	walk(src,0)
	if(CheckMove())
		return
	if(!is_talking)
		var/list/interest_persons = list()
		for(var/mob/living/carbon/human/H in viewers(4, src))
			if(H)
				if(H != src)
					interest_persons += H
		if(length(interest_persons))
			is_talking = TRUE
			spawn(rand(2, 7))
				face_atom(pick(interest_persons))
				spawn(rand(1, 5))
					is_talking = FALSE

/mob/living/carbon/human/npc/proc/SpeechAction()
	walk(src,0)
	if(CheckMove())
		return
	if(!is_talking)
		var/list/interest_persons = list()
		for(var/mob/living/carbon/human/npc/H in viewers(4, src))
			if(H)
				if(H != src && !H.CheckMove())
					interest_persons += H
		if(length(interest_persons))
			var/mob/living/carbon/human/npc/N = pick(interest_persons)
			face_atom(N)
			var/question = pick(socialrole.random_phrases)
			RealisticSay(question)
			spawn(rand(1, 5))
				N.face_atom(src)
				N.is_talking = TRUE
				spawn(GetSayDelay(question))
					N.is_talking = FALSE
					N.RealisticSay(pick(N.socialrole.answer_phrases))

/mob/living/carbon/human/npc/proc/ghoulificate(mob/owner)
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]`s ghoul?", null, null, null, 50, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, "<span class='ghostalert'>[owner] is ghoulificating [src].</span>")
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		key = C.key
		ghoulificated = TRUE
		set_species(/datum/species/ghoul)
		if(mind)
			if(mind.enslaved_to != owner && !HAS_TRAIT(owner, TRAIT_UNBONDING))
				mind.enslave_mind_to_creator(owner)
				to_chat(src, "<span class='userdanger'><b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [owner]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b></span>")
				return TRUE
			if(HAS_TRAIT(owner, TRAIT_UNBONDING))
				to_chat(src, "<span class='danger'><i>Precious vitae enters your mouth, an addictive drug. You feel no loyalty, though, to the source; only the substance.</i></span>")
	return FALSE


#undef BANDIT_TYPE_NPC
#undef POLICE_TYPE_NPC
