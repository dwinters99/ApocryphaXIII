/proc/compose_dir(mob/living/human/target, turf/targetturf, turf/ourturf, var/method = "normal")
	if(method == "Masquerade" || method == "Veil")
		if(!(GLOB.masquerade_breakers_list.len))
			return FALSE

	var/direction = get_dir(ourturf, targetturf)
	var/dirtext

	switch(direction)
		if(NORTH)
			dirtext = "the north"
		if(SOUTH)
			dirtext = "the south"
		if(EAST)
			dirtext = "the east"
		if(WEST)
			dirtext = "the west"
		if(NORTHWEST)
			dirtext = "the northwest"
		if(NORTHEAST)
			dirtext = "the northeast"
		if(SOUTHWEST)
			dirtext = "the southwest"
		if(SOUTHEAST)
			dirtext = "the southeast"
		else //Where ARE you.
			dirtext = "an unknown direction"

	var/distance = get_dist(ourturf, targetturf)
	var/disttext

	switch(distance)
		if(0 to 20)
			disttext = "20 tiles"
		if(20 to 40)
			disttext = "20 to 40 tiles"
		if(40 to 80)
			disttext = "40 to 80 tiles"
		if(80 to 160)
			disttext = "far"
		else
			disttext = "very far"

	var/place = get_area_name(targetturf)

	var/diablerietext = " They [target.diablerist ? "<b>are</b>" : "are not"] a diablerist.""

	var/violations = LOWER_TEXT(numbers_as_words[5-target.masquerade])

	var/returntext

	if(method = "Masquerade")
		returntext = "[target.true_real_name] is [disttext] away to the [dirtext] in [place]. They have violated the Masquerade [violations] times. They [target.diablerist ? "<b>are</b>" : "are not"] a diablerist."
	else if(method = "Veil")
		returntext = "[target.true_real_name] is [disttext] away to the [dirtext] in [place]. They have violated the Veil [violations] times."
	else
		returntext = "[target.true_real_name] is [disttext] away to [dirtext] in [place]."

	return returntext
