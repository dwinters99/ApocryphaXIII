/mob/living/verb/layerup()
	set name = "Layer Change Up"
	set category = "IC"

	if(!canface())
		to_chat(usr, span_warning("You can't change layer right now."))
		return

	var/newlayer = (layer+0.1)

	if(newlayer > 4.5)
		to_chat(usr, span_warning("You're at the highest layer!"))
	else
		to_chat(usr, span_notice("Your layer is now [newlayer]."))
		usr.layer = newlayer

/mob/living/verb/layerdown()
	set name = "Layer Change Down"
	set category = "IC"

	if(!canface())
		to_chat(usr, span_warning("You can't change layer right now."))
		return

	var/newlayer = (layer-0.1)

	if(newlayer < 3.5)
		to_chat(usr, span_warning("You're at the lowest layer!"))
	else
		to_chat(usr, span_notice("Your layer is now [newlayer]."))
		usr.layer = newlayer
