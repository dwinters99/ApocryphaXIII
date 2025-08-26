/mob/living/verb/layerchange()
	set name = "Change Layer"
	set category = "IC"

	if(!canface())
		to_chat(usr, span_warning("You can't change layer right now."))
		return

	var/newlayer = input(src, "Change your layer. Default: 4, Max: 4.5, Min: 3.5 :", "Layer", 4) as num|null

	if((newlayer > 4.5) || (newlayer < 3.5))
		to_chat(usr, span_warning("[newlayer] is not a valid layer. Max is 4.5, minimum is 3.5."))
	else
		to_chat(usr, span_notice("Your layer is now [newlayer]."))
		usr.layer = newlayer
