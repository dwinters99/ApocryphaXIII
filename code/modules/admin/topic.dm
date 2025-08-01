/datum/admins/proc/CheckAdminHref(href, href_list)
	var/auth = href_list["admin_token"]
	. = auth && (auth == href_token || auth == GLOB.href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] clicked an href with [msg] authorization key!")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("Debug mode enabled, call not blocked. Please ask your coders to review this round's logs.")
		log_world("UAH: [href]")
		return TRUE
	log_admin_private("[key_name(usr)] clicked an href with [msg] authorization key! [href]")

/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		message_admins("[usr.key] has attempted to override the admin panel!")
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		return

	if(!CheckAdminHref(href, href_list))
		return

	if(href_list["ahelp"])
		if(!check_rights(R_ADMIN, TRUE))
			return

		var/ahelp_ref = href_list["ahelp"]
		var/datum/help_ticket/admin/AH = locate(ahelp_ref)
		if(AH)
			AH.Action(href_list["ahelp_action"])
		else
			to_chat(usr, "Ticket [ahelp_ref] has been deleted!", confidential = TRUE)

	else if(href_list["ahelp_tickets"])
		GLOB.ahelp_tickets.BrowseTickets(text2num(href_list["ahelp_tickets"]))

	else if(href_list["stickyban"])
		stickyban(href_list["stickyban"],href_list)

	else if(href_list["getplaytimewindow"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["getplaytimewindow"]) in GLOB.mob_list
		if(!M)
			to_chat(usr, "<span class='danger'>ERROR: Mob not found.</span>", confidential = TRUE)
			return
		cmd_show_exp_panel(M.client)

	else if(href_list["toggleexempt"])
		if(!check_rights(R_ADMIN))
			return
		var/client/C = locate(href_list["toggleexempt"]) in GLOB.clients
		if(!C)
			to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>", confidential = TRUE)
			return
		toggle_exempt_status(C)

	else if(href_list["makeAntag"])
		if(!check_rights(R_ADMIN))
			return
		if (!SSticker.mode)
			to_chat(usr, "<span class='danger'>Not until the round starts!</span>", confidential = TRUE)
			return
		switch(href_list["makeAntag"])
			if("swat")
				if(src.makeSwat())
					message_admins("[key_name(usr)] created a SWAT team.")
					log_admin("[key_name(usr)] created a SWAT team.")
				else
					message_admins("[key_name_admin(usr)] tried to create a SWAT team. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to create a SWAT team.")
			if("nationalguard")
				if(src.makeNationalGuard())
					message_admins("[key_name(usr)] created national guard squad.")
					log_admin("[key_name(usr)] created national guard squad.")
				else
					message_admins("[key_name_admin(usr)] tried to create national guard squad. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to create national guard squad.")
			if("traitors")
				if(src.makeTraitors())
					message_admins("[key_name_admin(usr)] created traitors.")
					log_admin("[key_name(usr)] created traitors.")
				else
					message_admins("[key_name_admin(usr)] tried to create traitors. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to create traitors.")
			if("changelings")
				if(src.makeChangelings())
					message_admins("[key_name(usr)] created changelings.")
					log_admin("[key_name(usr)] created changelings.")
				else
					message_admins("[key_name_admin(usr)] tried to create changelings. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to create changelings.")
			if("revs")
				if(src.makeRevs())
					message_admins("[key_name(usr)] started a revolution.")
					log_admin("[key_name(usr)] started a revolution.")
				else
					message_admins("[key_name_admin(usr)] tried to start a revolution. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to start a revolution.")
			if("cult")
				if(src.makeCult())
					message_admins("[key_name(usr)] started a cult.")
					log_admin("[key_name(usr)] started a cult.")
				else
					message_admins("[key_name_admin(usr)] tried to start a cult. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to start a cult.")
			if("wizard")
				message_admins("[key_name(usr)] is creating a wizard...")
				if(src.makeWizard())
					message_admins("[key_name(usr)] created a wizard.")
					log_admin("[key_name(usr)] created a wizard.")
				else
					message_admins("[key_name_admin(usr)] tried to create a wizard. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to create a wizard.")
			if("nukeops")
				message_admins("[key_name(usr)] is creating a nuke team...")
				if(src.makeNukeTeam())
					message_admins("[key_name(usr)] created a nuke team.")
					log_admin("[key_name(usr)] created a nuke team.")
				else
					message_admins("[key_name_admin(usr)] tried to create a nuke team. Unfortunately, there were not enough candidates available.")
					log_admin("[key_name(usr)] failed to create a nuke team.")
			if("ninja")
				message_admins("[key_name(usr)] spawned a ninja.")
				log_admin("[key_name(usr)] spawned a ninja.")
				src.makeSpaceNinja()
			if("aliens")
				message_admins("[key_name(usr)] started an alien infestation.")
				log_admin("[key_name(usr)] started an alien infestation.")
				src.makeAliens()
			if("deathsquad")
				message_admins("[key_name(usr)] is creating a death squad...")
				if(src.makeDeathsquad())
					message_admins("[key_name(usr)] created a death squad.")
					log_admin("[key_name(usr)] created a death squad.")
				else
					message_admins("[key_name_admin(usr)] tried to create a death squad. Unfortunately, there were not enough candidates available.")
					log_admin("[key_name(usr)] failed to create a death squad.")
			if("blob")
				var/strength = input("Set Blob Resource Gain Rate","Set Resource Rate",1) as num|null
				if(!strength)
					return
				message_admins("[key_name(usr)] spawned a blob with base resource gain [strength].")
				log_admin("[key_name(usr)] spawned a blob with base resource gain [strength].")
				new/datum/round_event/ghost_role/blob(TRUE, strength)
			if("centcom")
				message_admins("[key_name(usr)] is creating a CentCom response team...")
				if(src.makeEmergencyresponseteam())
					message_admins("[key_name(usr)] created a CentCom response team.")
					log_admin("[key_name(usr)] created a CentCom response team.")
				else
					message_admins("[key_name_admin(usr)] tried to create a CentCom response team. Unfortunately, there were not enough candidates available.")
					log_admin("[key_name(usr)] failed to create a CentCom response team.")
			if("abductors")
				message_admins("[key_name(usr)] is creating an abductor team...")
				if(src.makeAbductorTeam())
					message_admins("[key_name(usr)] created an abductor team.")
					log_admin("[key_name(usr)] created an abductor team.")
				else
					message_admins("[key_name_admin(usr)] tried to create an abductor team. Unfortunately there were not enough candidates available.")
					log_admin("[key_name(usr)] failed to create an abductor team.")
			if("revenant")
				if(src.makeRevenant())
					message_admins("[key_name(usr)] created a revenant.")
					log_admin("[key_name(usr)] created a revenant.")
				else
					message_admins("[key_name_admin(usr)] tried to create a revenant. Unfortunately, there were no candidates available.")
					log_admin("[key_name(usr)] failed to create a revenant.")

	else if(href_list["forceevent"])
		if(!check_rights(R_FUN))
			return
		var/datum/round_event_control/E = locate(href_list["forceevent"]) in SSevents.control
		if(E)
			E.admin_setup(usr)
			var/datum/round_event/event = E.runEvent()
			if(event.announceWhen>0)
				event.processing = FALSE
				var/prompt = alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No", "Cancel")
				switch(prompt)
					if("Yes")
						event.announceChance = 100
					if("Cancel")
						event.kill()
						return
					if("No")
						event.announceChance = 0
				event.processing = TRUE
			message_admins("[key_name_admin(usr)] has triggered an event. ([E.name])")
			log_admin("[key_name(usr)] has triggered an event. ([E.name])")
		return

	else if(href_list["editrightsbrowser"])
		edit_admin_permissions(0)

	else if(href_list["editrightsbrowserlog"])
		edit_admin_permissions(1, href_list["editrightstarget"], href_list["editrightsoperation"], href_list["editrightspage"])

	if(href_list["editrightsbrowsermanage"])
		if(href_list["editrightschange"])
			change_admin_rank(ckey(href_list["editrightschange"]), href_list["editrightschange"], TRUE)
		else if(href_list["editrightsremove"])
			remove_admin(ckey(href_list["editrightsremove"]), href_list["editrightsremove"], TRUE)
		else if(href_list["editrightsremoverank"])
			remove_rank(href_list["editrightsremoverank"])
		edit_admin_permissions(2)

	else if(href_list["editrights"])
		edit_rights_topic(href_list)

	else if(href_list["gamemode_panel"])
		if(!check_rights(R_ADMIN))
			return
		SSticker.mode.admin_panel()

	else if(href_list["call_shuttle"])
		if(!check_rights(R_ADMIN))
			return


		switch(href_list["call_shuttle"])
			if("1")
				if(EMERGENCY_AT_LEAST_DOCKED)
					return
				SSshuttle.emergency.request()
				log_admin("[key_name(usr)] called the Emergency Shuttle.")
				message_admins("<span class='adminnotice'>[key_name_admin(usr)] called the Emergency Shuttle to the station.</span>")

			if("2")
				if(EMERGENCY_AT_LEAST_DOCKED)
					return
				switch(SSshuttle.emergency.mode)
					if(SHUTTLE_CALL)
						SSshuttle.emergency.cancel()
						log_admin("[key_name(usr)] sent the Emergency Shuttle back.")
						message_admins("<span class='adminnotice'>[key_name_admin(usr)] sent the Emergency Shuttle back.</span>")
					else
						SSshuttle.emergency.cancel()
						log_admin("[key_name(usr)] called the Emergency Shuttle.")
						message_admins("<span class='adminnotice'>[key_name_admin(usr)] called the Emergency Shuttle to the station.</span>")



	else if(href_list["edit_shuttle_time"])
		if(!check_rights(R_SERVER))
			return

		var/timer = input("Enter new shuttle duration (seconds):","Edit Shuttle Timeleft", SSshuttle.emergency.timeLeft() ) as num|null
		if(!timer)
			return
		SSshuttle.emergency.setTimer(timer SECONDS)
		log_admin("[key_name(usr)] edited the Emergency Shuttle's timeleft to [timer] seconds.")
		minor_announce("The emergency shuttle will reach its destination in [DisplayTimeText(timer SECONDS)].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] edited the Emergency Shuttle's timeleft to [timer] seconds.</span>")
	else if(href_list["trigger_centcom_recall"])
		if(!check_rights(R_ADMIN))
			return

		usr.client.trigger_centcom_recall()

	else if(href_list["move_shuttle"])
		if(!check_rights(R_ADMIN))
			return

		var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(href_list["move_shuttle"])
		if(!shuttle)
			return
		shuttle.admin_fly_shuttle(usr)

	else if(href_list["unlock_shuttle"])
		if(!check_rights(R_ADMIN))
			return

		var/obj/machinery/computer/shuttle/shuttle_console = locate(href_list["unlock_shuttle"])
		if(!shuttle_console)
			return
		shuttle_console.admin_controlled = !shuttle_console.admin_controlled
		to_chat(usr, "[shuttle_console] was [shuttle_console.admin_controlled ? "locked" : "unlocked"].", confidential = TRUE)

	else if(href_list["toggle_continuous"])
		if(!check_rights(R_ADMIN))
			return
		var/list/continuous = CONFIG_GET(keyed_list/continuous)
		if(!continuous[SSticker.mode.config_tag])
			continuous[SSticker.mode.config_tag] = TRUE
		else
			continuous[SSticker.mode.config_tag] = FALSE

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled the round to [continuous[SSticker.mode.config_tag] ? "continue if all antagonists die" : "end with the antagonists"].</span>")
		check_antagonists()

	else if(href_list["toggle_midround_antag"])
		if(!check_rights(R_ADMIN))
			return

		var/list/midround_antag = CONFIG_GET(keyed_list/midround_antag)
		if(!midround_antag[SSticker.mode.config_tag])
			midround_antag[SSticker.mode.config_tag] = TRUE
		else
			midround_antag[SSticker.mode.config_tag] = FALSE

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled the round to [midround_antag[SSticker.mode.config_tag] ? "use" : "skip"] the midround antag system.</span>")
		check_antagonists()

	else if(href_list["alter_midround_time_limit"])
		if(!check_rights(R_ADMIN))
			return

		var/timer = input("Enter new maximum time",, CONFIG_GET(number/midround_antag_time_check)) as num|null
		if(!timer)
			return
		CONFIG_SET(number/midround_antag_time_check, timer)
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] edited the maximum midround antagonist time to [timer] minutes.</span>")
		check_antagonists()

	else if(href_list["alter_midround_life_limit"])
		if(!check_rights(R_ADMIN))
			return

		var/ratio = input("Enter new life ratio",, CONFIG_GET(number/midround_antag_life_check) * 100) as num|null
		if(!ratio)
			return
		CONFIG_SET(number/midround_antag_life_check, ratio / 100)

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] edited the midround antagonist living crew ratio to [ratio]% alive.</span>")
		check_antagonists()

	else if(href_list["toggle_noncontinuous_behavior"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.mode.round_ends_with_antag_death)
			SSticker.mode.round_ends_with_antag_death = 1
		else
			SSticker.mode.round_ends_with_antag_death = 0

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] edited the midround antagonist system to [SSticker.mode.round_ends_with_antag_death ? "end the round" : "continue as extended"] upon failure.</span>")
		check_antagonists()

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))
			return
		if(!SSticker.delay_end)
			SSticker.admin_delay_notice = input(usr, "Enter a reason for delaying the round end", "Round Delay Reason") as null|text
			if(isnull(SSticker.admin_delay_notice))
				return
		else
			if(alert(usr, "Really cancel current round end delay? The reason for the current delay is: \"[SSticker.admin_delay_notice]\"", "Undelay round end", "Yes", "No") != "Yes")
				return
			SSticker.admin_delay_notice = null
		SSticker.delay_end = !SSticker.delay_end
		var/reason = SSticker.delay_end ? "for reason: [SSticker.admin_delay_notice]" : "."//laziness
		var/msg = "[SSticker.delay_end ? "delayed" : "undelayed"] the round end [reason]"
		log_admin("[key_name(usr)] [msg]")
		message_admins("[key_name_admin(usr)] [msg]")
		if(SSticker.ready_for_reboot && !SSticker.delay_end) //we undelayed after standard reboot would occur
			SSticker.standard_reboot()

	else if(href_list["end_round"])
		if(!check_rights(R_ADMIN))
			return

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] is considering ending the round.</span>")
		if(alert(usr, "This will end the round, are you SURE you want to do this?", "Confirmation", "Yes", "No") == "Yes")
			if(alert(usr, "Final Confirmation: End the round NOW?", "Confirmation", "Yes", "No") == "Yes")
				message_admins("<span class='adminnotice'>[key_name_admin(usr)] has ended the round.</span>")
				SSticker.force_ending = 1 //Yeah there we go APC destroyed mission accomplished
				return
			else
				message_admins("<span class='adminnotice'>[key_name_admin(usr)] decided against ending the round.</span>")
		else
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] decided against ending the round.</span>")

	else if(href_list["simplemake"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.", confidential = TRUE)
			return

		var/delmob = TRUE
		if(!isobserver(M))
			switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
				if("Cancel")
					return
				if("No")
					delmob = FALSE

		log_admin("[key_name(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]].; deletemob=[delmob]")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]].; deletemob=[delmob]</span>")
		switch(href_list["simplemake"])
			if("observer")
				M.change_mob_type( /mob/dead/observer , null, null, delmob )
			if("drone")
				M.change_mob_type( /mob/living/carbon/alien/humanoid/drone , null, null, delmob )
			if("hunter")
				M.change_mob_type( /mob/living/carbon/alien/humanoid/hunter , null, null, delmob )
			if("queen")
				M.change_mob_type( /mob/living/carbon/alien/humanoid/royal/queen , null, null, delmob )
			if("praetorian")
				M.change_mob_type( /mob/living/carbon/alien/humanoid/royal/praetorian , null, null, delmob )
			if("sentinel")
				M.change_mob_type( /mob/living/carbon/alien/humanoid/sentinel , null, null, delmob )
			if("larva")
				M.change_mob_type( /mob/living/carbon/alien/larva , null, null, delmob )
			if("human")
				var/posttransformoutfit = usr.client.robust_dress_shop()
				if (!posttransformoutfit)
					return
				var/mob/living/carbon/human/newmob = M.change_mob_type( /mob/living/carbon/human , null, null, delmob )
				if(posttransformoutfit && istype(newmob))
					newmob.equipOutfit(posttransformoutfit)
			if("slime")
				M.change_mob_type( /mob/living/simple_animal/slime , null, null, delmob )
			if("monkey")
				M.change_mob_type( /mob/living/carbon/human/species/monkey , null, null, delmob )
			if("robot")
				M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")
				M.change_mob_type( /mob/living/simple_animal/pet/cat , null, null, delmob )
			if("runtime")
				M.change_mob_type( /mob/living/simple_animal/pet/cat/runtime , null, null, delmob )
			if("corgi")
				M.change_mob_type( /mob/living/simple_animal/pet/dog/corgi , null, null, delmob )
			if("ian")
				M.change_mob_type( /mob/living/simple_animal/pet/dog/corgi/ian , null, null, delmob )
			if("pug")
				M.change_mob_type( /mob/living/simple_animal/pet/dog/pug , null, null, delmob )
			if("crab")
				M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("coffee")
				M.change_mob_type( /mob/living/simple_animal/crab/coffee , null, null, delmob )
			if("parrot")
				M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
			if("polyparrot")
				M.change_mob_type( /mob/living/simple_animal/parrot/poly , null, null, delmob )
			if("constructjuggernaut")
				M.change_mob_type( /mob/living/simple_animal/hostile/construct/juggernaut , null, null, delmob )
			if("constructartificer")
				M.change_mob_type( /mob/living/simple_animal/hostile/construct/artificer , null, null, delmob )
			if("constructwraith")
				M.change_mob_type( /mob/living/simple_animal/hostile/construct/wraith , null, null, delmob )
			if("shade")
				M.change_mob_type( /mob/living/simple_animal/shade , null, null, delmob )

	else if(href_list["boot2"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["boot2"])
		if(ismob(M))
			if(!check_if_greater_rights_than(M.client))
				to_chat(usr, "<span class='danger'>Error: They have more rights than you do.</span>", confidential = TRUE)
				return
			if(alert(usr, "Kick [key_name(M)]?", "Confirm", "Yes", "No") != "Yes")
				return
			if(!M)
				to_chat(usr, "<span class='danger'>Error: [M] no longer exists!</span>", confidential = TRUE)
				return
			if(!M.client)
				to_chat(usr, "<span class='danger'>Error: [M] no longer has a client!</span>", confidential = TRUE)
				return
			to_chat(M, "<span class='danger'>You have been kicked from the server by [usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"].</span>", confidential = TRUE)
			log_admin("[key_name(usr)] kicked [key_name(M)].")
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] kicked [key_name_admin(M)].</span>")
			qdel(M.client)

	else if(href_list["addmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addmessage"]
		create_message("message", target_key, secret = 0)

	else if(href_list["addnote"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addnote"]
		create_message("note", target_key)

	else if(href_list["addwatch"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addwatch"]
		create_message("watchlist entry", target_key, secret = 1)

	else if(href_list["addmemo"])
		if(!check_rights(R_ADMIN))
			return
		create_message("memo", secret = 0, browse = 1)

	else if(href_list["addmessageempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("message", secret = 0)

	else if(href_list["addnoteempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("note")

	else if(href_list["addwatchempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("watchlist entry", secret = 1)

	else if(href_list["deletemessage"])
		if(!check_rights(R_ADMIN))
			return
		var/safety = alert("Delete message/note?",,"Yes","No");
		if (safety == "Yes")
			var/message_id = href_list["deletemessage"]
			delete_message(message_id)

	else if(href_list["deletemessageempty"])
		if(!check_rights(R_ADMIN))
			return
		var/safety = alert("Delete message/note?",,"Yes","No");
		if (safety == "Yes")
			var/message_id = href_list["deletemessageempty"]
			delete_message(message_id, browse = TRUE)

	else if(href_list["editmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessage"]
		edit_message(message_id)

	else if(href_list["editmessageempty"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageempty"]
		edit_message(message_id, browse = 1)

	else if(href_list["editmessageexpiry"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageexpiry"]
		edit_message_expiry(message_id)

	else if(href_list["editmessageexpiryempty"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageexpiryempty"]
		edit_message_expiry(message_id, browse = 1)

	else if(href_list["editmessageseverity"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageseverity"]
		edit_message_severity(message_id)

	else if(href_list["secretmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["secretmessage"]
		toggle_message_secrecy(message_id)

	else if(href_list["searchmessages"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["searchmessages"]
		browse_messages(index = target)

	else if(href_list["nonalpha"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["nonalpha"]
		target = text2num(target)
		browse_messages(index = target)

	else if(href_list["showmessages"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["showmessages"]
		browse_messages(index = target)

	else if(href_list["showmemo"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("memo")

	else if(href_list["showwatch"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("watchlist entry")

	else if(href_list["showwatchfilter"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("watchlist entry", filter = 1)

	else if(href_list["showmessageckey"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["showmessageckey"]
		var/agegate = TRUE
		if (href_list["showall"])
			agegate = FALSE
		browse_messages(target_ckey = target, agegate = agegate)

	else if(href_list["showmessageckeylinkless"])
		var/target = href_list["showmessageckeylinkless"]
		browse_messages(target_ckey = target, linkless = 1)

	else if(href_list["messageedits"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/db_query/query_get_message_edits = SSdbcore.NewQuery(
			"SELECT edits FROM [format_table_name("messages")] WHERE id = :message_id",
			list("message_id" = href_list["messageedits"])
		)
		if(!query_get_message_edits.warn_execute())
			qdel(query_get_message_edits)
			return
		if(query_get_message_edits.NextRow())
			var/edit_log = query_get_message_edits.item[1]
			if(!QDELETED(usr))
				var/datum/browser/browser = new(usr, "Note edits", "Note edits")
				browser.set_content(jointext(edit_log, ""))
				browser.open()
		qdel(query_get_message_edits)

	else if(href_list["mute"])
		if(!check_rights(R_ADMIN))
			return
		cmd_admin_mute(href_list["mute"], text2num(href_list["mute_type"]))

	else if(href_list["c_mode"])
		return HandleCMode()

	else if(href_list["f_secret"])
		return HandleFSecret()

	else if(href_list["f_dynamic_roundstart"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode.", null, null, null, null)
		var/roundstart_rules = list()
		for (var/rule in subtypesof(/datum/dynamic_ruleset/roundstart))
			var/datum/dynamic_ruleset/roundstart/newrule = new rule()
			roundstart_rules[newrule.name] = newrule
		var/added_rule = input(usr,"What ruleset do you want to force? This will bypass threat level and population restrictions.", "Rigging Roundstart", null) as null|anything in sort_list(roundstart_rules)
		if (added_rule)
			GLOB.dynamic_forced_roundstart_ruleset += roundstart_rules[added_rule]
			log_admin("[key_name(usr)] set [added_rule] to be a forced roundstart ruleset.")
			message_admins("[key_name(usr)] set [added_rule] to be a forced roundstart ruleset.", 1)
			Game()

	else if(href_list["f_dynamic_roundstart_clear"])
		if(!check_rights(R_ADMIN))
			return
		GLOB.dynamic_forced_roundstart_ruleset = list()
		Game()
		log_admin("[key_name(usr)] cleared the rigged roundstart rulesets. The mode will pick them as normal.")
		message_admins("[key_name(usr)] cleared the rigged roundstart rulesets. The mode will pick them as normal.", 1)

	else if(href_list["f_dynamic_roundstart_remove"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/dynamic_ruleset/roundstart/rule = locate(href_list["f_dynamic_roundstart_remove"])
		GLOB.dynamic_forced_roundstart_ruleset -= rule
		Game()
		log_admin("[key_name(usr)] removed [rule] from the forced roundstart rulesets.")
		message_admins("[key_name(usr)] removed [rule] from the forced roundstart rulesets.", 1)

	else if (href_list["f_dynamic_options"])
		if(!check_rights(R_ADMIN))
			return

		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_roundstart_centre"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		var/new_centre = input(usr,"Change the centre of the dynamic mode threat curve. A negative value will give a more peaceful round ; a positive value, a round with higher threat. Any number between -5 and +5 is allowed.", "Change curve centre", null) as num
		if (new_centre < -5 || new_centre > 5)
			return alert(usr, "Only values between -5 and +5 are allowed.", null, null, null, null)

		log_admin("[key_name(usr)] changed the distribution curve center to [new_centre].")
		message_admins("[key_name(usr)] changed the distribution curve center to [new_centre]", 1)
		GLOB.dynamic_curve_centre = new_centre
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_roundstart_width"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		var/new_width = input(usr,"Change the width of the dynamic mode threat curve. A higher value will favour extreme rounds ; a lower value, a round closer to the average. Any Number between 0.5 and 4 are allowed.", "Change curve width", null) as num
		if (new_width < 0.5 || new_width > 4)
			return alert(usr, "Only values between 0.5 and +2.5 are allowed.", null, null, null, null)

		log_admin("[key_name(usr)] changed the distribution curve width to [new_width].")
		message_admins("[key_name(usr)] changed the distribution curve width to [new_width]", 1)
		GLOB.dynamic_curve_width = new_width
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_roundstart_latejoin_min"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)
		var/new_min = input(usr,"Change the minimum delay of latejoin injection in minutes.", "Change latejoin injection delay minimum", null) as num
		if(new_min <= 0)
			return alert(usr, "The minimum can't be zero or lower.", null, null, null, null)
		if((new_min MINUTES) > GLOB.dynamic_latejoin_delay_max)
			return alert(usr, "The minimum must be lower than the maximum.", null, null, null, null)

		log_admin("[key_name(usr)] changed the latejoin injection minimum delay to [new_min] minutes.")
		message_admins("[key_name(usr)] changed the latejoin injection minimum delay to [new_min] minutes", 1)
		GLOB.dynamic_latejoin_delay_min = (new_min MINUTES)
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_roundstart_latejoin_max"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)
		var/new_max = input(usr,"Change the maximum delay of latejoin injection in minutes.", "Change latejoin injection delay maximum", null) as num
		if(new_max <= 0)
			return alert(usr, "The maximum can't be zero or lower.", null, null, null, null)
		if((new_max MINUTES) < GLOB.dynamic_latejoin_delay_min)
			return alert(usr, "The maximum must be higher than the minimum.", null, null, null, null)

		log_admin("[key_name(usr)] changed the latejoin injection maximum delay to [new_max] minutes.")
		message_admins("[key_name(usr)] changed the latejoin injection maximum delay to [new_max] minutes", 1)
		GLOB.dynamic_latejoin_delay_max = (new_max MINUTES)
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_roundstart_midround_min"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)
		var/new_min = input(usr,"Change the minimum delay of midround injection in minutes.", "Change midround injection delay minimum", null) as num
		if(new_min <= 0)
			return alert(usr, "The minimum can't be zero or lower.", null, null, null, null)
		if((new_min MINUTES) > GLOB.dynamic_midround_delay_max)
			return alert(usr, "The minimum must be lower than the maximum.", null, null, null, null)

		log_admin("[key_name(usr)] changed the midround injection minimum delay to [new_min] minutes.")
		message_admins("[key_name(usr)] changed the midround injection minimum delay to [new_min] minutes", 1)
		GLOB.dynamic_midround_delay_min = (new_min MINUTES)
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_roundstart_midround_max"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)
		var/new_max = input(usr,"Change the maximum delay of midround injection in minutes.", "Change midround injection delay maximum", null) as num
		if(new_max <= 0)
			return alert(usr, "The maximum can't be zero or lower.", null, null, null, null)
		if((new_max MINUTES) > GLOB.dynamic_midround_delay_max)
			return alert(usr, "The maximum must be higher than the minimum.", null, null, null, null)

		log_admin("[key_name(usr)] changed the midround injection maximum delay to [new_max] minutes.")
		message_admins("[key_name(usr)] changed the midround injection maximum delay to [new_max] minutes", 1)
		GLOB.dynamic_midround_delay_max = (new_max MINUTES)
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_force_extended"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		GLOB.dynamic_forced_extended = !GLOB.dynamic_forced_extended
		log_admin("[key_name(usr)] set 'forced_extended' to [GLOB.dynamic_forced_extended].")
		message_admins("[key_name(usr)] set 'forced_extended' to [GLOB.dynamic_forced_extended].")
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_no_stacking"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		GLOB.dynamic_no_stacking = !GLOB.dynamic_no_stacking
		log_admin("[key_name(usr)] set 'no_stacking' to [GLOB.dynamic_no_stacking].")
		message_admins("[key_name(usr)] set 'no_stacking' to [GLOB.dynamic_no_stacking].")
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_classic_secret"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		GLOB.dynamic_classic_secret = !GLOB.dynamic_classic_secret
		log_admin("[key_name(usr)] set 'classic_secret' to [GLOB.dynamic_classic_secret].")
		message_admins("[key_name(usr)] set 'classic_secret' to [GLOB.dynamic_classic_secret].")
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_stacking_limit"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		GLOB.dynamic_stacking_limit = input(usr,"Change the threat limit at which round-endings rulesets will start to stack.", "Change stacking limit", null) as num
		log_admin("[key_name(usr)] set 'stacking_limit' to [GLOB.dynamic_stacking_limit].")
		message_admins("[key_name(usr)] set 'stacking_limit' to [GLOB.dynamic_stacking_limit].")
		dynamic_mode_options(usr)

	else if(href_list["f_dynamic_forced_threat"])
		if(!check_rights(R_ADMIN))
			return

		if(SSticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)

		if(!SSticker.is_mode("dynamic"))
			return alert(usr, "The game mode has to be dynamic mode!", null, null, null, null)

		var/new_value = input(usr, "Enter the forced threat level for dynamic mode.", "Forced threat level") as num
		if (new_value > 100)
			return alert(usr, "The value must be be under 100.", null, null, null, null)
		GLOB.dynamic_forced_threat_level = new_value

		log_admin("[key_name(usr)] set 'forced_threat_level' to [GLOB.dynamic_forced_threat_level].")
		message_admins("[key_name(usr)] set 'forced_threat_level' to [GLOB.dynamic_forced_threat_level].")
		dynamic_mode_options(usr)

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))
			return

		if (SSticker.HasRoundStarted())
			if (tgui_alert(usr, "The game has already started. Would you like to save this as the default mode effective next round?", "Save mode", list("Yes", "Cancel"), timeout = 0) == "Yes")
				SSticker.save_mode(href_list["c_mode2"])
			HandleCMode()
			return
		GLOB.master_mode = href_list["c_mode2"]
		log_admin("[key_name(usr)] set the mode as [GLOB.master_mode].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] set the mode as [GLOB.master_mode].</span>")
		to_chat(world, "<span class='adminnotice'><b>The mode is now: [GLOB.master_mode]</b></span>", confidential = TRUE)
		Game() // updates the main game menu
		if (tgui_alert(usr, "Would you like to save this as the default mode for the server?", "Save mode", list("Yes", "No"), timeout = 0) == "Yes")
			SSticker.save_mode(GLOB.master_mode)
		HandleCMode()

	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))
			return

		if(SSticker.HasRoundStarted())
			return alert(usr, "The game has already started.", null, null, null, null)
		if(GLOB.master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		GLOB.secret_force_mode = href_list["f_secret2"]
		log_admin("[key_name(usr)] set the forced secret mode as [GLOB.secret_force_mode].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] set the forced secret mode as [GLOB.secret_force_mode].</span>")
		Game() // updates the main game menu
		HandleFSecret()

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		log_admin("[key_name(usr)] attempting to monkeyize [key_name(H)].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)].</span>")
		H.monkeyize()

	else if(href_list["humanone"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/Mo = locate(href_list["humanone"])
		if(!ismonkey(Mo))
			to_chat(usr, "This can only be used on monkeys.", confidential = TRUE)
			return

		log_admin("[key_name(usr)] attempting to humanize [key_name(Mo)].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] attempting to humanize [key_name_admin(Mo)].</span>")
		Mo.humanize()

	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		log_admin("[key_name(usr)] attempting to corgize [key_name(H)].")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] attempting to corgize [key_name_admin(H)].</span>")
		H.corgize()


	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))
			return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			to_chat(usr, "this can only be used on instances of type /mob.", confidential = TRUE)

		var/speech = input("What will [key_name(M)] say?", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)
			return
		M.say(speech, forced = "admin speech")
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]</span>")

	else if(href_list["sendtoprison"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendtoprison"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.", confidential = TRUE)
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai.", confidential = TRUE)
			return

		if(alert(usr, "Send [key_name(M)] to Prison?", "Message", "Yes", "No") != "Yes")
			return

		M.forceMove(pick(GLOB.prisonwarp))
		to_chat(M, "<span class='adminnotice'>You have been sent to Prison!</span>", confidential = TRUE)

		log_admin("[key_name(usr)] has sent [key_name(M)] to Prison!")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to Prison!")

	else if(href_list["sendbacktolobby"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendbacktolobby"])

		if(!isobserver(M))
			to_chat(usr, "<span class='notice'>You can only send ghost players back to the Lobby.</span>", confidential = TRUE)
			return

		if(!M.client)
			to_chat(usr, "<span class='warning'>[M] doesn't seem to have an active client.</span>", confidential = TRUE)
			return

		if(alert(usr, "Send [key_name(M)] back to Lobby?", "Message", "Yes", "No") != "Yes")
			return

		GLOB.respawn_timers[M.client.ckey] = 0

		log_admin("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")
		message_admins("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")

		var/mob/dead/new_player/NP = new()
		NP.ckey = M.ckey
		qdel(M)

	else if(href_list["tdome1"])
		if(!check_rights(R_FUN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome1"])
		if(!isliving(M))
			to_chat(usr, "This can only be used on instances of type /mob/living.", confidential = TRUE)
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai.", confidential = TRUE)
			return
		var/mob/living/L = M

		for(var/obj/item/I in L)
			L.dropItemToGround(I, TRUE)

		L.Unconscious(100)
		sleep(5)
		L.forceMove(pick(GLOB.tdome1))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), L, "<span class='adminnotice'>You have been sent to the Thunderdome.</span>"), 5 SECONDS)
		log_admin("[key_name(usr)] has sent [key_name(L)] to the thunderdome. (Team 1)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(L)] to the thunderdome. (Team 1)")

	else if(href_list["tdome2"])
		if(!check_rights(R_FUN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome2"])
		if(!isliving(M))
			to_chat(usr, "This can only be used on instances of type /mob/living.", confidential = TRUE)
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai.", confidential = TRUE)
			return
		var/mob/living/L = M

		for(var/obj/item/I in L)
			L.dropItemToGround(I, TRUE)

		L.Unconscious(100)
		sleep(5)
		L.forceMove(pick(GLOB.tdome2))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), L, "<span class='adminnotice'>You have been sent to the Thunderdome.</span>"), 5 SECONDS)
		log_admin("[key_name(usr)] has sent [key_name(L)] to the thunderdome. (Team 2)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(L)] to the thunderdome. (Team 2)")

	else if(href_list["tdomeadmin"])
		if(!check_rights(R_FUN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeadmin"])
		if(!isliving(M))
			to_chat(usr, "This can only be used on instances of type /mob/living.", confidential = TRUE)
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai.", confidential = TRUE)
			return
		var/mob/living/L = M

		L.Unconscious(100)
		sleep(5)
		L.forceMove(pick(GLOB.tdomeadmin))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), L, "<span class='adminnotice'>You have been sent to the Thunderdome.</span>"), 5 SECONDS)
		log_admin("[key_name(usr)] has sent [key_name(L)] to the thunderdome. (Admin.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(L)] to the thunderdome. (Admin.)")

	else if(href_list["tdomeobserve"])
		if(!check_rights(R_FUN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeobserve"])
		if(!isliving(M))
			to_chat(usr, "This can only be used on instances of type /mob/living.", confidential = TRUE)
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai.", confidential = TRUE)
			return
		var/mob/living/L = M

		for(var/obj/item/I in L)
			L.dropItemToGround(I, TRUE)

		if(ishuman(L))
			var/mob/living/carbon/human/observer = L
			observer.equip_to_slot_or_del(new /obj/item/clothing/under/suit/black(observer), ITEM_SLOT_ICLOTHING)
			observer.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(observer), ITEM_SLOT_FEET)
		L.Unconscious(100)
		sleep(5)
		L.forceMove(pick(GLOB.tdomeobserve))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), L, "<span class='adminnotice'>You have been sent to the Thunderdome.</span>"), 5 SECONDS)
		log_admin("[key_name(usr)] has sent [key_name(L)] to the thunderdome. (Observer.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(L)] to the thunderdome. (Observer.)")

	else if(href_list["revive"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "This can only be used on instances of type /mob/living.", confidential = TRUE)
			return

		L.revive(full_heal = TRUE, admin_revive = TRUE)
		message_admins("<span class='danger'>Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!</span>")
		log_admin("[key_name(usr)] healed / Revived [key_name(L)].")

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		var/move = TRUE
		switch(alert(usr,"Move new AI to AI spawn location?","Move AI?", "Yes", "No","Cancel"))
			if("Cancel")
				return
			if("No")
				move = FALSE
		if(QDELETED(H))
			to_chat(usr, "<span class='danger'>Subject was deleted already. Transform canceled.</span>")
			return
		message_admins("<span class='danger'>Admin [key_name_admin(usr)] AIized [key_name_admin(H)]!</span>")
		log_admin("[key_name(usr)] AIized [key_name(H)].")
		H.AIize(TRUE, H.client, move)

	else if(href_list["makealien"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makealien"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		usr.client.cmd_admin_alienize(H)

	else if(href_list["makeslime"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makeslime"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		usr.client.cmd_admin_slimeize(H)

	else if(href_list["makeblob"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makeblob"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		usr.client.cmd_admin_blobize(H)


	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return

		usr.client.cmd_admin_robotize(H)

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))
			return

		var/mob/M = locate(href_list["makeanimal"])
		if(isnewplayer(M))
			to_chat(usr, "This cannot be used on instances of type /mob/dead/new_player.", confidential = TRUE)
			return

		usr.client.cmd_admin_animalize(M)

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["adminplayerobservefollow"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/atom/movable/AM = locate(href_list["adminplayerobservefollow"])

		var/client/C = usr.client
		var/can_ghost = TRUE
		if(!isobserver(usr))
			can_ghost = C.admin_ghost()

		if(!can_ghost)
			return
		var/mob/dead/observer/A = C.mob
		A.ManualFollow(AM)

	else if(href_list["admingetmovable"])
		if(!check_rights(R_ADMIN))
			return

		var/atom/movable/AM = locate(href_list["admingetmovable"])
		if(QDELETED(AM))
			return
		AM.forceMove(get_turf(usr))

	else if(href_list["adminplayerobservecoodjump"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isobserver(usr))
			C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["adminchecklaws"])
		if(!check_rights(R_ADMIN))
			return
		output_ai_laws()

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.", confidential = TRUE)
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = get_turf(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
			else
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

		//Job + antagonist
		if(M.mind)
			special_role_description = "Role: <b>[M.mind.assigned_role]</b>; Antagonist: <font color='red'><b>"
			var/i = 0
			for(var/datum/antagonist/A in M.mind.antag_datums)
				special_role_description += "[A.name]"
				if(++i != length(M.mind.antag_datums))
					special_role_description += ", "
			special_role_description += "</b></font>"
		else
			special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if(CONSCIOUS)
					status = "Alive"
				if(SOFT_CRIT)
					status = "<font color='orange'><b>Dying</b></font>"
				if(UNCONSCIOUS)
					status = "<font color='orange'><b>Unconscious</b></font>"
				if(HARD_CRIT)
					status = "<font color='orange'><b>Unconscious and Dying</b></font>"
				if(DEAD)
					status = "<font color='red'><b>Dead</b></font>"
			health_description = "Status = [status]"
			health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getOrganLoss(ORGAN_SLOT_BRAIN)] - Stamina: [L.getStaminaLoss()]"
		else
			health_description = "This mob type has no health to speak of."

		//Gender
		switch(M.gender)
			if(MALE,FEMALE,PLURAL)
				gender_description = "[M.gender]"
			else
				gender_description = "<font color='red'><b>[M.gender]</b></font>"

		//Full Output
		var/exportable_text = "[span_bold("Info about [M.name]:")]<br>"
		exportable_text += "Key - [span_bold(M.key)]<br>"
		exportable_text += "Mob Type - [M.type]<br>"
		exportable_text += "Gender - [gender_description]<br>"
		exportable_text += "[health_description]<br>"
		exportable_text += "Name: [span_bold(M.name)] - Real Name: [M.real_name] - Mind Name: [M.mind?"[M.mind.name]":""]<br>"
		exportable_text += "Location is [location_description]<br>"
		exportable_text += "[special_role_description]<br>"
		exportable_text += ADMIN_FULLMONTY_NONAME(M)

		to_chat(src.owner, boxed_message(exportable_text), confidential = TRUE)

	else if(href_list["addjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Add = href_list["addjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Add)
				job.total_positions += 1
				break

		src.manage_free_slots()


	else if(href_list["customjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Add = href_list["customjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Add)
				var/newtime = null
				newtime = input(usr, "How many jebs do you want?", "Add wanted posters", "[newtime]") as num|null
				if(!newtime)
					to_chat(src.owner, "Setting to amount of positions filled for the job", confidential = TRUE)
					job.total_positions = job.current_positions
					break
				job.total_positions = newtime

		src.manage_free_slots()

	else if(href_list["removejobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Remove = href_list["removejobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Remove && job.total_positions - job.current_positions > 0)
				job.total_positions -= 1
				break

		src.manage_free_slots()

	else if(href_list["unlimitjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Unlimit = href_list["unlimitjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Unlimit)
				job.total_positions = -1
				break

		src.manage_free_slots()

	else if(href_list["limitjobslot"])
		if(!check_rights(R_ADMIN))
			return

		var/Limit = href_list["limitjobslot"]

		for(var/datum/job/job in SSjob.occupations)
			if(job.title == Limit)
				job.total_positions = job.current_positions
				break

		src.manage_free_slots()


	else if(href_list["adminspawncookie"])
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human.", confidential = TRUE)
			return
		//let's keep it simple
		//milk to plasmemes and skeletons, meat to lizards, electricity bars to ethereals, cookies to everyone else
		var/cookiealt = /obj/item/food/cookie
		if(isskeleton(H))
			cookiealt = /obj/item/reagent_containers/food/condiment/milk
		else if(isplasmaman(H))
			cookiealt = /obj/item/reagent_containers/food/condiment/milk
		else if(isethereal(H))
			cookiealt = /obj/item/food/energybar
		else if(islizard(H))
			cookiealt = /obj/item/food/meat/slab
		var/obj/item/new_item = new cookiealt(H)
		if(H.put_in_hands(new_item))
			H.update_inv_hands()
		else
			qdel(new_item)
			log_admin("[key_name(H)] has their hands full, so they did not receive their [new_item.name], spawned by [key_name(src.owner)].")
			message_admins("[key_name(H)] has their hands full, so they did not receive their [new_item.name], spawned by [key_name(src.owner)].")
			return

		log_admin("[key_name(H)] got their [new_item], spawned by [key_name(src.owner)].")
		message_admins("[key_name(H)] got their [new_item], spawned by [key_name(src.owner)].")
		SSblackbox.record_feedback("amount", "admin_cookies_spawned", 1)
		to_chat(H, "<span class='adminnotice'>Your prayers have been answered!! You received the <b>best [new_item.name]!</b></span>", confidential = TRUE)
		SEND_SOUND(H, sound('sound/effects/pray_chaplain.ogg'))

	else if(href_list["adminsmite"])
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminsmite"]) in GLOB.mob_list
		if(!H || !istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human", confidential = TRUE)
			return

		usr.client.smite(H)

	else if(href_list["CentComReply"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["CentComReply"])
		usr.client.admin_headset_message(M, RADIO_CHANNEL_CENTCOM)

	else if(href_list["SyndicateReply"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["SyndicateReply"])
		usr.client.admin_headset_message(M, RADIO_CHANNEL_SYNDICATE)

	else if(href_list["HeadsetMessage"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["HeadsetMessage"])
		usr.client.admin_headset_message(M)

	else if(href_list["reject_custom_name"])
		if(!check_rights(R_ADMIN))
			return
		var/obj/item/station_charter/charter = locate(href_list["reject_custom_name"])
		if(istype(charter))
			charter.reject_proposed(usr)
	else if(href_list["jumpto"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["adjustmasquerade"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/living/carbon/human/M = locate(href_list["adjustmasquerade"])
		if(!M)
			to_chat(usr, "Error: Could not locate the specified mob.")
			return
		usr.client.cmd_admin_adjust_masquerade(M)
/*
	else if(href_list["adjusthumanity"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/living/carbon/human/M = locate(href_list["adjusthumanity"])
		if(!M)
			to_chat(usr, "Error: Could not locate the specified mob.")
			return
		usr.client.cmd_admin_adjust_humanity(M)
*/
	else if(href_list["playsoundto"])
		if(!check_rights(R_SOUND))
			return

		var/mob/M = locate(href_list["playsoundto"])
		var/S = input("", "Select a sound file",) as null|sound
		if(S)
			usr.client.play_direct_mob_sound(S, M)

	else if(href_list["individuallog"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["individuallog"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.", confidential = TRUE)
			return

		show_individual_logging_panel(M, href_list["log_src"], href_list["log_type"])
	else if(href_list["languagemenu"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["languagemenu"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.", confidential = TRUE)
			return
		var/datum/language_holder/H = M.get_language_holder()
		H.open_language_menu(usr)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.HasRoundStarted())
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			var/datum/mind/D = M
			if(!istype(D))
				to_chat(usr, "This can only be used on instances of type /mob and /mind", confidential = TRUE)
				return
			else
				D.traitor_panel()
		else
			show_traitor_panel(M)

	else if(href_list["skill"])
		if(!check_rights(R_ADMIN))
			return

		if(!SSticker.HasRoundStarted())
			alert("The game hasn't started yet!")
			return

		var/target = locate(href_list["skill"])
		var/datum/mind/target_mind
		if(ismob(target))
			var/mob/target_mob = target
			target_mind = target_mob.mind
		else if (istype(target, /datum/mind))
			target_mind = target
		else
			to_chat(usr, "This can only be used on instances of type /mob and /mind", confidential = TRUE)
			return
		show_skill_panel(target_mind)

	else if(href_list["borgpanel"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["borgpanel"])
		if(!iscyborg(M))
			to_chat(usr, "This can only be used on cyborgs", confidential = TRUE)
		else
			open_borgopanel(M)

	else if(href_list["initmind"])
		if(!check_rights(R_ADMIN))
			return
		var/mob/M = locate(href_list["initmind"])
		if(!ismob(M) || M.mind)
			to_chat(usr, "This can only be used on instances on mindless mobs", confidential = TRUE)
			return
		M.mind_initialize()

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))
			return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))
			return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))
			return
		return create_mob(usr)

	else if(href_list["dupe_marked_datum"])
		if(!check_rights(R_SPAWN))
			return
		return DuplicateObject(marked_datum, perfectcopy=1, newloc=get_turf(usr))

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty.")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5).")
			return

		var/list/offset = splittext(href_list["offset"],",")
		var/number = clamp(text2num(href_list["object_count"]), 1, ADMIN_SPAWN_CAP)
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/obj_dir = text2num(href_list["object_dir"])
		if(obj_dir && !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = null
		var/obj_name = sanitize(href_list["object_name"])


		var/atom/target //Where the object will be spawned
		var/where = href_list["object_where"]
		if (!( where in list("onfloor","frompod","inhand","inmarked") ))
			where = "onfloor"


		switch(where)
			if("inhand")
				if (!iscarbon(usr) && !iscyborg(usr))
					to_chat(usr, "Can only spawn in hand when you're a carbon mob or cyborg.", confidential = TRUE)
					where = "onfloor"
				target = usr

			if("onfloor", "frompod")
				switch(href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if("inmarked")
				if(!marked_datum)
					to_chat(usr, "You don't have any object marked. Abandoning spawn.", confidential = TRUE)
					return
				else if(!istype(marked_datum, /atom))
					to_chat(usr, "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn.", confidential = TRUE)
					return
				else
					target = marked_datum

		var/obj/structure/closet/supplypod/centcompod/pod

		if(target)
			if(where == "frompod")
				pod = new()

			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N && obj_name)
							N.name = obj_name
					else
						var/atom/O
						if(where == "frompod")
							O = new path(pod)
						else
							O = new path(target)

						if(!QDELETED(O))
							O.flags_1 |= ADMIN_SPAWNED_1
							if(obj_dir)
								O.setDir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(ismob(O))
									var/mob/M = O
									M.real_name = obj_name
							if(where == "inhand" && isliving(usr) && isitem(O))
								var/mob/living/L = usr
								var/obj/item/I = O
								L.put_in_hands(I)
								if(iscyborg(L))
									var/mob/living/silicon/robot/R = L
									if(R.model)
										R.model.add_module(I, TRUE, TRUE)
										R.activate_module(I)

		if(pod)
			new /obj/effect/pod_landingzone(target, pod)

		if (number == 1)
			log_admin("[key_name(usr)] created a [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created a [english_list(paths)]")
					break
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created [number]ea [english_list(paths)]")
					break
		return

	else if(href_list["check_antagonist"])
		if(!check_rights(R_ADMIN))
			return
		usr.client.check_antagonists()

	else if(href_list["kick_all_from_lobby"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker.IsRoundInProgress())
			var/afkonly = text2num(href_list["afkonly"])
			if(alert("Are you sure you want to kick all [afkonly ? "AFK" : ""] clients from the lobby??","Message","Yes","Cancel") != "Yes")
				to_chat(usr, "Kick clients from lobby aborted", confidential = TRUE)
				return
			var/list/listkicked = kick_clients_in_lobby("<span class='danger'>You were kicked from the lobby by [usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"].</span>", afkonly)

			var/strkicked = ""
			for(var/name in listkicked)
				strkicked += "[name], "
			message_admins("[key_name_admin(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
			log_admin("[key_name(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
		else
			to_chat(usr, "You may only use this when the game is running.", confidential = TRUE)

	else if(href_list["create_outfit_finalize"])
		if(!check_rights(R_ADMIN))
			return
		create_outfit_finalize(usr,href_list)
	else if(href_list["load_outfit"])
		if(!check_rights(R_ADMIN))
			return
		load_outfit(usr)
	else if(href_list["create_outfit_menu"])
		if(!check_rights(R_ADMIN))
			return
		create_outfit(usr)
	else if(href_list["delete_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/outfit/O = locate(href_list["chosen_outfit"]) in GLOB.custom_outfits
		delete_outfit(usr,O)
	else if(href_list["save_outfit"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/outfit/O = locate(href_list["chosen_outfit"]) in GLOB.custom_outfits
		save_outfit(usr,O)
	else if(href_list["set_selfdestruct_code"])
		if(!check_rights(R_ADMIN))
			return
		var/code = random_nukecode()
		for(var/obj/machinery/nuclearbomb/selfdestruct/SD in GLOB.nuke_list)
			SD.r_code = code
		message_admins("[key_name_admin(usr)] has set the self-destruct \
			code to \"[code]\".")

	else if(href_list["add_station_goal"])
		if(!check_rights(R_ADMIN))
			return
		var/list/type_choices = typesof(/datum/station_goal)
		var/picked = input("Choose goal type") in type_choices|null
		if(!picked)
			return
		var/datum/station_goal/G = new picked()
		if(picked == /datum/station_goal)
			var/newname = input("Enter goal name:") as text|null
			if(!newname)
				return
			G.name = newname
			var/description = input("Enter CentCom message contents:") as message|null
			if(!description)
				return
			G.report_message = description
		message_admins("[key_name(usr)] created \"[G.name]\" station goal.")
		SSticker.mode.station_goals += G
		modify_goals()

	else if(href_list["viewruntime"])
		var/datum/error_viewer/error_viewer = locate(href_list["viewruntime"])
		if(!istype(error_viewer))
			to_chat(usr, "<span class='warning'>That runtime viewer no longer exists.</span>", confidential = TRUE)
			return

		if(href_list["viewruntime_backto"])
			error_viewer.show_to(owner, locate(href_list["viewruntime_backto"]), href_list["viewruntime_linear"])
		else
			error_viewer.show_to(owner, null, href_list["viewruntime_linear"])

	else if(href_list["showrelatedacc"])
		if(!check_rights(R_ADMIN))
			return
		var/client/C = locate(href_list["client"]) in GLOB.clients
		var/thing_to_check
		if(href_list["showrelatedacc"] == "cid")
			thing_to_check = C.related_accounts_cid
		else
			thing_to_check = C.related_accounts_ip
		thing_to_check = splittext(thing_to_check, ", ")


		var/list/dat = list("Related accounts by [uppertext(href_list["showrelatedacc"])]:")
		dat += thing_to_check

		var/datum/browser/browser = new(usr, "related_[C]", "[C.ckey] Related Accounts", 420, 300)
		browser.set_content(dat.Join("<br>"))
		browser.open()

	else if(href_list["centcomlookup"])
		if(!check_rights(R_ADMIN))
			return

		if(!CONFIG_GET(string/centcom_ban_db))
			to_chat(usr, "<span class='warning'>Centcom Galactic Ban DB is disabled!</span>")
			return

		var/ckey = href_list["centcomlookup"]

		// Make the request
		var/datum/http_request/request = new()
		request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/centcom_ban_db)]/[ckey]", "", "")
		request.begin_async()
		UNTIL(request.is_complete() || !usr)
		if (!usr)
			return
		var/datum/http_response/response = request.into_response()

		var/list/bans

		var/list/dat = list("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><body>")

		if(response.errored)
			dat += "<br>Failed to connect to CentCom."
		else if(response.status_code != 200)
			dat += "<br>Failed to connect to CentCom. Status code: [response.status_code]"
		else
			if(response.body == "[]")
				dat += "<center><b>0 bans detected for [ckey]</b></center>"
			else
				bans = json_decode(response["body"])

				//Ignore bans from non-whitelisted sources, if a whitelist exists
				var/list/valid_sources
				if(CONFIG_GET(string/centcom_source_whitelist))
					valid_sources = splittext(CONFIG_GET(string/centcom_source_whitelist), ",")
					dat += "<center><b>Bans detected for [ckey]</b></center>"
				else
					//Ban count is potentially inaccurate if they're using a whitelist
					dat += "<center><b>[bans.len] ban\s detected for [ckey]</b></center>"

				for(var/list/ban in bans)
					if(valid_sources && !(ban["sourceName"] in valid_sources))
						continue
					dat += "<b>Server: </b> [sanitize(ban["sourceName"])]<br>"
					dat += "<b>RP Level: </b> [sanitize(ban["sourceRoleplayLevel"])]<br>"
					dat += "<b>Type: </b> [sanitize(ban["type"])]<br>"
					dat += "<b>Banned By: </b> [sanitize(ban["bannedBy"])]<br>"
					dat += "<b>Reason: </b> [sanitize(ban["reason"])]<br>"
					dat += "<b>Datetime: </b> [sanitize(ban["bannedOn"])]<br>"
					var/expiration = ban["expires"]
					dat += "<b>Expires: </b> [expiration ? "[sanitize(expiration)]" : "Permanent"]<br>"
					if(ban["type"] == "job")
						dat += "<b>Jobs: </b> "
						var/list/jobs = ban["jobs"]
						dat += sanitize(jobs.Join(", "))
						dat += "<br>"
					dat += "<hr>"

		dat += "<br></body>"
		var/datum/browser/popup = new(usr, "centcomlookup-[ckey]", "<div align='center'>Central Command Galactic Ban Database</div>", 700, 600)
		popup.set_content(dat.Join())
		popup.open(0)

	else if(href_list["modantagrep"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["mob"]) in GLOB.mob_list
		var/client/C = M.client
		usr.client.cmd_admin_mod_antag_rep(C, href_list["modantagrep"])
		show_player_panel(M)

	else if(href_list["slowquery"])
		if(!check_rights(R_ADMIN))
			return

		var/data = list("key" = usr.key)
		var/answer = href_list["slowquery"]
		if(answer == "yes")
			if(tgui_alert(usr, "Did you just press any admin buttons?", "Query server hang report", list("Yes", "No")) == "Yes")
				var/response = input(usr,"What were you just doing?","Query server hang report") as null|text
				if(response)
					data["response"] = response
			logger.Log(LOG_CATEGORY_DEBUG_SQL, "server hang", data)
		else if(answer == "no")
			logger.Log(LOG_CATEGORY_DEBUG_SQL, "no server hang", data)

	else if(href_list["ctf_toggle"])
		if(!check_rights(R_ADMIN))
			return
		toggle_id_ctf(usr, "centcom")

	else if(href_list["rebootworld"])
		if(!check_rights(R_ADMIN))
			return
		var/confirm = alert("Are you sure you want to reboot the server?", "Confirm Reboot", "Yes", "No")
		if(confirm == "No")
			return
		if(confirm == "Yes")
			restart()

	else if(href_list["check_teams"])
		if(!check_rights(R_ADMIN))
			return
		check_teams()

	else if(href_list["team_command"])
		if(!check_rights(R_ADMIN))
			return
		switch(href_list["team_command"])
			if("create_team")
				admin_create_team(usr)
			if("rename_team")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_rename(usr)
			if("communicate")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_communicate(usr)
			if("delete_team")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_delete(usr)
			if("add_objective")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_add_objective(usr)
			if("remove_objective")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(!T)
					return
				var/datum/objective/O = locate(href_list["tobjective"]) in T.objectives
				if(O)
					T.admin_remove_objective(usr,O)
			if("add_member")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(T)
					T.admin_add_member(usr)
			if("remove_member")
				var/datum/team/T = locate(href_list["team"]) in GLOB.antagonist_teams
				if(!T)
					return
				var/datum/mind/M = locate(href_list["tmember"]) in T.members
				if(M)
					T.admin_remove_member(usr,M)
		check_teams()

	else if(href_list["newbankey"])
		var/player_key = href_list["newbankey"]
		var/player_ip = href_list["newbanip"]
		var/player_cid = href_list["newbancid"]
		ban_panel(player_key, player_ip, player_cid)

	else if(href_list["intervaltype"]) //check for ban panel, intervaltype is used as it's the only value which will always be present
		if(href_list["roleban_delimiter"])
			ban_parse_href(href_list)
		else
			ban_parse_href(href_list, TRUE)

	else if(href_list["searchunbankey"] || href_list["searchunbanadminkey"] || href_list["searchunbanip"] || href_list["searchunbancid"])
		var/player_key = href_list["searchunbankey"]
		var/admin_key = href_list["searchunbanadminkey"]
		var/player_ip = href_list["searchunbanip"]
		var/player_cid = href_list["searchunbancid"]
		unban_panel(player_key, admin_key, player_ip, player_cid)

	else if(href_list["unbanpagecount"])
		var/page = href_list["unbanpagecount"]
		var/player_key = href_list["unbankey"]
		var/admin_key = href_list["unbanadminkey"]
		var/player_ip = href_list["unbanip"]
		var/player_cid = href_list["unbancid"]
		unban_panel(player_key, admin_key, player_ip, player_cid, page)

	else if(href_list["editbanid"])
		var/edit_id = href_list["editbanid"]
		var/player_key = href_list["editbankey"]
		var/player_ip = href_list["editbanip"]
		var/player_cid = href_list["editbancid"]
		var/role = href_list["editbanrole"]
		var/duration = href_list["editbanduration"]
		var/applies_to_admins = text2num(href_list["editbanadmins"])
		var/reason = url_decode(href_list["editbanreason"])
		var/page = href_list["editbanpage"]
		var/admin_key = href_list["editbanadminkey"]
		ban_panel(player_key, player_ip, player_cid, role, duration, applies_to_admins, reason, edit_id, page, admin_key)

	else if(href_list["unbanid"])
		var/ban_id = href_list["unbanid"]
		var/player_key = href_list["unbankey"]
		var/player_ip = href_list["unbanip"]
		var/player_cid = href_list["unbancid"]
		var/role = href_list["unbanrole"]
		var/page = href_list["unbanpage"]
		var/admin_key = href_list["unbanadminkey"]
		unban(ban_id, player_key, player_ip, player_cid, role, page, admin_key)

	else if(href_list["unbanlog"])
		var/ban_id = href_list["unbanlog"]
		ban_log(ban_id)

	else if(href_list["beakerpanel"])
		beaker_panel_act(href_list)

	else if(href_list["reloadpolls"])
		GLOB.polls.Cut()
		GLOB.poll_options.Cut()
		load_poll_data()
		poll_list_panel()

	else if(href_list["newpoll"])
		poll_management_panel()

	else if(href_list["editpoll"])
		var/datum/poll_question/poll = locate(href_list["editpoll"]) in GLOB.polls
		poll_management_panel(poll)

	else if(href_list["deletepoll"])
		var/datum/poll_question/poll = locate(href_list["deletepoll"]) in GLOB.polls
		poll.delete_poll()
		poll_list_panel()

	else if(href_list["initializepoll"])
		poll_parse_href(href_list)

	else if(href_list["submitpoll"])
		var/datum/poll_question/poll = locate(href_list["submitpoll"]) in GLOB.polls
		poll_parse_href(href_list, poll)

	else if(href_list["clearpollvotes"])
		var/datum/poll_question/poll = locate(href_list["clearpollvotes"]) in GLOB.polls
		poll.clear_poll_votes()
		poll_management_panel(poll)

	else if(href_list["addpolloption"])
		var/datum/poll_question/poll = locate(href_list["addpolloption"]) in GLOB.polls
		poll_option_panel(poll)

	else if(href_list["editpolloption"])
		var/datum/poll_option/option = locate(href_list["editpolloption"]) in GLOB.poll_options
		var/datum/poll_question/poll = locate(href_list["parentpoll"]) in GLOB.polls
		poll_option_panel(poll, option)

	else if(href_list["deletepolloption"])
		var/datum/poll_option/option = locate(href_list["deletepolloption"]) in GLOB.poll_options
		var/datum/poll_question/poll = option.delete_option()
		poll_management_panel(poll)

	else if(href_list["submitoption"])
		var/datum/poll_option/option = locate(href_list["submitoption"]) in GLOB.poll_options
		var/datum/poll_question/poll = locate(href_list["submitoptionpoll"]) in GLOB.polls
		poll_option_parse_href(href_list, poll, option)

	else if(href_list["admincommend"])
		if(!SSticker.IsRoundInProgress())
			to_chat(usr, "<span class='warning'>The round must be in progress to use this!</span>")
			return
		var/mob/heart_recepient = locate(href_list["admincommend"])
		if(tgui_alert(usr, "Are you sure you'd like to anonymously commend [heart_recepient.ckey]? NOTE: This is logged, please use this sparingly and only for actual kind behavior, not as a reward for your friends.", "<3?", list("Yes", "No")) == "No")
			return
		usr.nominate_heart(heart_recepient)

	else if(href_list["force_war"])
		if(!check_rights(R_ADMIN))
			return
		var/obj/item/nuclear_challenge/button = locate(href_list["force_war"])
		button.force_war()

	else if (href_list["interview"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/interview/I = locate(href_list["interview"])
		if (I)
			I.ui_interact(usr)

	else if (href_list["interview_man"])
		if(!check_rights(R_ADMIN))
			return
		GLOB.interviews.ui_interact(usr)

	else if (href_list["deletewhitelist"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/whitelist/whitelist = locate(href_list["deletewhitelist"])
		whitelist_option_parse_href(href_list, whitelist)

	else if (href_list["reloadwhitelists"])
		if(!check_rights(R_ADMIN))
			return
		whitelist_panel()

	else if (href_list["newwhitelist"])
		if(!check_rights(R_ADMIN))
			return
		usr.client.grant_whitelist()
		whitelist_panel()

	else if (href_list["searchwhitelistckey"])
		whitelist_panel(href_list["searchwhitelistckey"])

	//Diffrent to the DB whitelist system. This is for the player connection whitelist.txt
	else if (href_list["whitelist_newckey"])
		var/whitelistee = input("CKey to whitelist: (Adds CKey to the whitelist.txt)") as null|text
		if(whitelistee)
			whitelist_ckey(whitelistee)

	else if(href_list["show_paper"])
		if(!check_rights(R_ADMIN))
			return

		var/obj/item/paper/paper_to_show = locate(href_list["show_paper"])
		if(!paper_to_show)
			return
		paper_to_show.ui_interact(usr)
	else if(href_list["play_internet"])
		if(!check_rights(R_SOUND))
			return

		var/credit = href_list["credit"]
		var/link_url = href_list["play_internet"]
		if(!link_url)
			return

		web_sound(usr, link_url, credit)

/datum/admins/proc/HandleCMode()
	if(!check_rights(R_ADMIN))
		return

	var/dat = {"<B>What mode do you wish to play?</B><HR>"}
	for(var/mode in config.modes)
		dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
	dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];c_mode2=secret'>Secret</A><br>"}
	dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];c_mode2=random'>Random</A><br>"}
	dat += {"Now: [GLOB.master_mode]"}
	usr << browse(HTML_SKELETON(dat), "window=c_mode")

/datum/admins/proc/HandleFSecret()
	if(!check_rights(R_ADMIN))
		return

	if(SSticker.HasRoundStarted())
		return alert(usr, "The game has already started.", null, null, null, null)
	if(GLOB.master_mode != "secret")
		return alert(usr, "The game mode has to be secret!", null, null, null, null)
	var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
	for(var/mode in config.modes)
		dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
	dat += {"<A href='byond://?src=[REF(src)];[HrefToken()];f_secret2=secret'>Random (default)</A><br>"}
	dat += {"Now: [GLOB.secret_force_mode]"}
	usr << browse(HTML_SKELETON(dat), "window=f_secret")
