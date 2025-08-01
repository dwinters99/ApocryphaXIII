//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "Kitty!!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 0
	turns_per_move = 5
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/food/meat/slab = 1, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1, /obj/item/stack/sheet/animalhide/cat = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	///Limits how often cats can spam chasing mice.
	var/emote_cooldown = 0
	///Can this cat catch special mice?
	var/inept_hunter = FALSE
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "cat"
	can_be_held = TRUE
	held_state = "cat2"
	pet_bonus = TRUE
	pet_bonus_emote = "purrs!"

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/pet/cat/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/toggle_resting)
	add_cell_sample()

/mob/living/simple_animal/pet/cat/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CAT, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)


/mob/living/simple_animal/pet/cat/space
	name = "space cat"
	desc = "It's a cat... in space!"
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_dead = "spacecat_dead"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40
	held_state = "spacecat"

/mob/living/simple_animal/pet/cat/breadcat
	name = "bread cat"
	desc = "It's a cat... with a bread!"
	icon_state = "breadcat"
	icon_living = "breadcat"
	icon_dead = "breadcat_dead"
	collar_type = null
	held_state = "breadcat"
	butcher_results = list(/obj/item/food/meat/slab = 2, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1, /obj/item/food/breadslice/plain = 1)

/mob/living/simple_animal/pet/cat/breadcat/add_cell_sample()
	return

/mob/living/simple_animal/pet/cat/original
	name = "Batsy"
	desc = "The product of alien DNA and bored geneticists."
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	collar_type = null
	unique_pet = TRUE
	held_state = "original"

/mob/living/simple_animal/pet/cat/original/add_cell_sample()
	return
/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = "D'aaawwww."
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL
	collar_type = "kitten"

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/runtime
	name = "Runtime"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	var/memory_saved = FALSE
	held_state = "cat"

/mob/living/simple_animal/pet/cat/runtime/Initialize()
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	Read_Memory()
	. = ..()

/mob/living/simple_animal/pet/cat/runtime/Life()
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/cat/runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/cat/runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()

/mob/living/simple_animal/pet/cat/runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || (C.flags_1 & HOLOGRAM_1))
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/_proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/*
/mob/living/simple_animal/pet/cat/Life()
	//MICE!
	if(stat == DEAD)
		return
	if(key)
		return
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat && Adjacent(M))
					manual_emote("splats \the [M]!")
					M.death()
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)
*/
/mob/living/simple_animal/pet/cat/jerry //Holy shit we left jerry on donut ~ Arcane ~Fikou
	name = "Jerry"
	desc = "Tom is VERY amused."
	inept_hunter = TRUE
	gender = MALE

/mob/living/simple_animal/pet/cat/cak //I told you I'd do it, Remie
	name = "Keeki"
	desc = "It's a cat made out of cake."
	icon_state = "cak"
	icon_living = "cak"
	icon_dead = "cak_dead"
	health = 50
	maxHealth = 50
	gender = FEMALE
	harm_intent_damage = 10
	butcher_results = list(/obj/item/organ/brain = 1, /obj/item/organ/heart = 1, /obj/item/food/cakeslice/birthday = 3,  \
	/obj/item/food/meat/slab = 2)
	response_harm_continuous = "takes a bite out of"
	response_harm_simple = "take a bite out of"
	attacked_sound = 'sound/items/eatfood.ogg'
	deathmessage = "loses its false life and collapses!"
	deathsound = "bodyfall"
	held_state = "cak"

/mob/living/simple_animal/pet/cat/cak/add_cell_sample()
	return

/mob/living/simple_animal/pet/cat/cak/CheckParts(list/parts)
	..()
	var/obj/item/organ/brain/B = locate(/obj/item/organ/brain) in contents
	if(!B || !B.brainmob || !B.brainmob.mind)
		return
	B.brainmob.mind.transfer_to(src)
	to_chat(src, "<span class='big bold'>You are a cak!</span><b> You're a harmless cat/cake hybrid that everyone loves. People can take bites out of you if they're hungry, but you regenerate health \
	so quickly that it generally doesn't matter. You're remarkably resilient to any damage besides this and it's hard for you to really die at all. You should go around and bring happiness and \
	free cake to the station!</b>")
	var/new_name = stripped_input(src, "Enter your name, or press \"Cancel\" to stick with Keeki.", "Name Change")
	if(new_name)
		to_chat(src, "<span class='notice'>Your name is now <b>\"new_name\"</b>!</span>")
		name = new_name

/mob/living/simple_animal/pet/cat/cak/Life()
	..()
	if(stat)
		return
	if(health < maxHealth)
		adjustBruteLoss(-8) //Fast life regen
	for(var/obj/item/food/donut/D in range(1, src)) //Frosts nearby donuts!
		if(!D.is_decorated)
			D.decorate_donut()

/mob/living/simple_animal/pet/cat/cak/attack_hand(mob/living/L)
	..()
	if(L.a_intent == INTENT_HARM && L.reagents && !stat)
		L.reagents.add_reagent(/datum/reagent/consumable/nutriment, 0.4)
		L.reagents.add_reagent(/datum/reagent/consumable/nutriment/vitamin, 0.4)

/mob/living/simple_animal/pet/cat/vampire
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/pet/cat/vampire/Initialize()
	. = ..()
	var/id = rand(1, 7)
	icon_state = "cat[id]"
	icon_living = "cat[id]"
	icon_dead = "cat[id]_dead"

/mob/living/simple_animal/pet/cat/vampiretzi
	name = "cat?"
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 5
	maxbloodpool = 5
	mob_size = MOB_SIZE_SMALL
	icon_state = "cattzi"
	icon_living = "cattzi"
	icon_dead = "cattzi_dead"

/mob/living/simple_animal/hostile/beastmaster/cat
	name = "cat"
	desc = "Kitty!!"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/cat.ogg'
	speak_chance = 0
	turns_per_move = 3
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/food/meat/slab = 1, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1, /obj/item/stack/sheet/animalhide/cat = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	///Limits how often cats can spam chasing mice.
	var/emote_cooldown = 0
	///Can this cat catch special mice?
	var/inept_hunter = FALSE
	gold_core_spawnable = FRIENDLY_SPAWN
	can_be_held = TRUE
	held_state = "cat2"
	pet_bonus = TRUE
	pet_bonus_emote = "purrs!"

	footstep_type = FOOTSTEP_MOB_CLAW
	bloodpool = 1
	maxbloodpool = 1
	maxHealth = 30
	health = 30
	harm_intent_damage = 20
	melee_damage_lower = 15
	melee_damage_upper = 30
	speed = -0.1
	dodging = TRUE

/mob/living/simple_animal/hostile/beastmaster/cat/Initialize()
	. = ..()
	var/id = rand(1, 7)
	icon_state = "cat[id]"
	icon_living = "cat[id]"
	icon_dead = "cat[id]_dead"
