#define BEYBLADE_PUKE_THRESHOLD 30 //How confused a carbon must be before they will vomit
#define BEYBLADE_PUKE_NUTRIENT_LOSS 60 //How must nutrition is lost when a carbon pukes
#define BEYBLADE_DIZZINESS_PROBABILITY 20 //How often a carbon becomes penalized
#define BEYBLADE_DIZZINESS_VALUE 10 //How long the screenshake lasts
#define BEYBLADE_CONFUSION_INCREMENT 10 //How much confusion a carbon gets when penalized
#define BEYBLADE_CONFUSION_LIMIT 40 //A max for how penalized a carbon will be for beyblading

//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, m_type = null, message = null, intentional = FALSE)
	var/param = message
	var/custom_param = findchar(act, " ")
	if(custom_param)
		param = copytext(act, custom_param + length(act[custom_param]))
		act = copytext(act, 1, custom_param)

	act = LOWER_TEXT(act)
	var/list/key_emotes = GLOB.emote_list[act]

	if(!length(key_emotes))
		if(intentional)
			to_chat(src, "<span class='notice'>'[act]' emote does not exist. Say *help for a list.</span>")
		return FALSE
	var/silenced = FALSE
	for(var/datum/emote/emote in key_emotes)
		if(!emote.check_cooldown(src, intentional))
			silenced = TRUE
			continue
		if(!emote.can_run_emote(src, TRUE, intentional, param))
			continue
		if(SEND_SIGNAL(src, COMSIG_MOB_PRE_EMOTED, emote.key, param, m_type, intentional, emote) & COMPONENT_CANT_EMOTE)
			silenced = TRUE
			continue
		emote.run_emote(src, param, m_type, intentional)
		SEND_SIGNAL(src, COMSIG_MOB_EMOTE, emote, act, m_type, message, intentional)
		SEND_SIGNAL(src, COMSIG_MOB_EMOTED(emote.key))
		return TRUE
	if(intentional && !silenced)
		to_chat(src, "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>")
	return FALSE

/datum/emote/help
	key = "help"
	mob_type_ignore_stat_typecache = list(/mob/dead/observer, /mob/living/silicon/ai)

/datum/emote/help/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sort_list(keys)
	message += keys.Join(", ")
	message += "."
	message = message.Join("")
	to_chat(user, boxed_message(message))

/datum/emote/flip
	key = "flip"
	key_third_person = "flips"
	hands_use_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer, /mob/living/silicon/ai)

/datum/emote/flip/run_emote(mob/user, params , type_override, intentional)
	. = ..()
	user.SpinAnimation(7,1)

/datum/emote/flip/check_cooldown(mob/user, intentional)
	. = ..()
	if(!.)
		return
	if(!can_run_emote(user, intentional=intentional))
		return
	if(isliving(user))
		var/mob/living/flippy_mcgee = user
		if(prob(20))
			flippy_mcgee.Knockdown(1 SECONDS)
			flippy_mcgee.visible_message(
				"<span class='notice'>[flippy_mcgee] attempts to do a flip and falls over, what a doofus!</span>",
				"<span class='notice'>You attempt to do a flip while still off balance from the last flip and fall down!</span>"
			)
			if(prob(50))
				flippy_mcgee.adjustBruteLoss(1)
		else
			flippy_mcgee.visible_message(
				"<span class='notice'>[flippy_mcgee] stumbles a bit after their flip.</span>",
				"<span class='notice'>You stumble a bit from still being off balance from your last flip.</span>"
			)

/datum/emote/spin
	key = "spin"
	key_third_person = "spins"
	hands_use_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)

/datum/emote/spin/run_emote(mob/user, params ,  type_override, intentional)
	. = ..()
	user.spin(20, 1)

/datum/emote/spin/check_cooldown(mob/living/carbon/user, intentional)
	. = ..()
	if(!.)
		return
	if(!can_run_emote(user, intentional=intentional))
		return
	if(!iscarbon(user))
		return
	var/current_confusion = user.get_confusion()
	if(current_confusion > BEYBLADE_PUKE_THRESHOLD)
		user.vomit(BEYBLADE_PUKE_NUTRIENT_LOSS, distance = 0)
		return
	if(prob(BEYBLADE_DIZZINESS_PROBABILITY))
		to_chat(user, "<span class='warning'>You feel woozy from spinning.</span>")
		user.Dizzy(BEYBLADE_DIZZINESS_VALUE)
		if(current_confusion < BEYBLADE_CONFUSION_LIMIT)
			user.add_confusion(BEYBLADE_CONFUSION_INCREMENT)


#undef BEYBLADE_PUKE_THRESHOLD
#undef BEYBLADE_PUKE_NUTRIENT_LOSS
#undef BEYBLADE_DIZZINESS_PROBABILITY
#undef BEYBLADE_DIZZINESS_VALUE
#undef BEYBLADE_CONFUSION_INCREMENT
#undef BEYBLADE_CONFUSION_LIMIT
