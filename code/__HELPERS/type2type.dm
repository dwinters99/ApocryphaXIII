/*
 * Holds procs designed to change one type of value, into another.
 * Contains:
 *			file2list
 *			angle2dir
 *			angle2text
 *			worldtime2text
 *			text2dir_extended & dir2text_short
 */



//Splits the text of a file at seperator and returns them in a list.
//returns an empty list if the file doesn't exist
/world/proc/file2list(filename, seperator="\n", trim = TRUE)
	if (trim)
		return splittext(trim(file2text(filename)),seperator)
	return splittext(file2text(filename),seperator)

//Turns a direction into text
/proc/dir2text(direction)
	switch(direction)
		if(NORTH)
			return "north"
		if(SOUTH)
			return "south"
		if(EAST)
			return "east"
		if(WEST)
			return "west"
		if(NORTHEAST)
			return "northeast"
		if(SOUTHEAST)
			return "southeast"
		if(NORTHWEST)
			return "northwest"
		if(SOUTHWEST)
			return "southwest"
		else
	return

//Turns text into proper directions
/proc/text2dir(direction)
	switch(uppertext(direction))
		if("NORTH")
			return NORTH
		if("SOUTH")
			return SOUTH
		if("EAST")
			return EAST
		if("WEST")
			return WEST
		if("NORTHEAST")
			return NORTHEAST
		if("NORTHWEST")
			return NORTHWEST
		if("SOUTHEAST")
			return SOUTHEAST
		if("SOUTHWEST")
			return SOUTHWEST
		else
	return

//Converts an angle (degrees) into a ss13 direction
GLOBAL_LIST_INIT(modulo_angle_to_dir, list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST))
#define angle2dir(X) (GLOB.modulo_angle_to_dir[round((((X%360)+382.5)%360)/45)+1])

/proc/angle2dir_cardinal(degree)
	degree = SIMPLIFY_DEGREES(degree)
	switch(round(degree, 0.1))
		if(315.5 to 360, 0 to 45.5)
			return NORTH
		if(45.6 to 135.5)
			return EAST
		if(135.6 to 225.5)
			return SOUTH
		if(225.6 to 315.5)
			return WEST

//returns the north-zero clockwise angle in degrees, given a direction
/proc/dir2angle(D)
	switch(D)
		if(NORTH)
			return 0
		if(SOUTH)
			return 180
		if(EAST)
			return 90
		if(WEST)
			return 270
		if(NORTHEAST)
			return 45
		if(SOUTHEAST)
			return 135
		if(NORTHWEST)
			return 315
		if(SOUTHWEST)
			return 225
		else
			return null

//Returns the angle in english
/proc/angle2text(degree)
	return dir2text(angle2dir(degree))

//Converts a blend_mode constant to one acceptable to icon.Blend()
/proc/blendMode2iconMode(blend_mode)
	switch(blend_mode)
		if(BLEND_MULTIPLY)
			return ICON_MULTIPLY
		if(BLEND_ADD)
			return ICON_ADD
		if(BLEND_SUBTRACT)
			return ICON_SUBTRACT
		else
			return ICON_OVERLAY

//Converts a rights bitfield into a string
/proc/rights2text(rights, seperator="", prefix = "+")
	seperator += prefix
	if(rights & R_BUILD)
		. += "[seperator]BUILDMODE"
	if(rights & R_ADMIN)
		. += "[seperator]ADMIN"
	if(rights & R_BAN)
		. += "[seperator]BAN"
	if(rights & R_FUN)
		. += "[seperator]FUN"
	if(rights & R_SERVER)
		. += "[seperator]SERVER"
	if(rights & R_DEBUG)
		. += "[seperator]DEBUG"
	if(rights & R_POSSESS)
		. += "[seperator]POSSESS"
	if(rights & R_PERMISSIONS)
		. += "[seperator]PERMISSIONS"
	if(rights & R_STEALTH)
		. += "[seperator]STEALTH"
	if(rights & R_POLL)
		. += "[seperator]POLL"
	if(rights & R_VAREDIT)
		. += "[seperator]VAREDIT"
	if(rights & R_SOUND)
		. += "[seperator]SOUND"
	if(rights & R_SPAWN)
		. += "[seperator]SPAWN"
	if(rights & R_AUTOADMIN)
		. += "[seperator]AUTOLOGIN"
	if(rights & R_DBRANKS)
		. += "[seperator]DBRANKS"
	if(!.)
		. = "NONE"
	return .

//colour formats
/proc/rgb2hsl(red, green, blue)
	red /= 255;green /= 255;blue /= 255;
	var/max = max(red,green,blue)
	var/min = min(red,green,blue)
	var/range = max-min

	var/hue=0;var/saturation=0;var/lightness=0;
	lightness = (max + min)/2
	if(range != 0)
		if(lightness < 0.5)
			saturation = range/(max+min)
		else
			saturation = range/(2-max-min)

		var/dred = ((max-red)/(6*max)) + 0.5
		var/dgreen = ((max-green)/(6*max)) + 0.5
		var/dblue = ((max-blue)/(6*max)) + 0.5

		if(max==red)
			hue = dblue - dgreen
		else if(max==green)
			hue = dred - dblue + (1/3)
		else
			hue = dgreen - dred + (2/3)
		if(hue < 0)
			hue++
		else if(hue > 1)
			hue--

	return list(hue, saturation, lightness)

/proc/hsl2rgb(hue, saturation, lightness)
	var/red;var/green;var/blue;
	if(saturation == 0)
		red = lightness * 255
		green = red
		blue = red
	else
		var/a;var/b;
		if(lightness < 0.5)
			b = lightness*(1+saturation)
		else
			b = (lightness+saturation) - (saturation*lightness)
		a = 2*lightness - b

		red = round(255 * hue2rgb(a, b, hue+(1/3)))
		green = round(255 * hue2rgb(a, b, hue))
		blue = round(255 * hue2rgb(a, b, hue-(1/3)))

	return list(red, green, blue)

/proc/hue2rgb(a, b, hue)
	if(hue < 0)
		hue++
	else if(hue > 1)
		hue--
	if(6*hue < 1)
		return (a+(b-a)*6*hue)
	if(2*hue < 1)
		return b
	if(3*hue < 2)
		return (a+(b-a)*((2/3)-hue)*6)
	return a

/// For finding out what body parts a body zone covers, the inverse of the below basically
/proc/zone2body_parts_covered(def_zone)
	switch(def_zone)
		if(BODY_ZONE_CHEST)
			return list(CHEST, GROIN)
		if(BODY_ZONE_HEAD)
			return list(HEAD)
		if(BODY_ZONE_L_ARM)
			return list(ARM_LEFT, HAND_LEFT)
		if(BODY_ZONE_R_ARM)
			return list(ARM_RIGHT, HAND_RIGHT)
		if(BODY_ZONE_L_LEG)
			return list(LEG_LEFT, FOOT_LEFT)
		if(BODY_ZONE_R_LEG)
			return list(LEG_RIGHT, FOOT_RIGHT)

//Turns a Body_parts_covered bitfield into a list of organ/limb names.
//(I challenge you to find a use for this) -I found a use for it!!
/proc/body_parts_covered2organ_names(bpc)
	var/list/covered_parts = list()

	if(!bpc)
		return 0

	if(bpc & FULL_BODY)
		covered_parts |= list(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM,BODY_ZONE_HEAD,BODY_ZONE_CHEST,BODY_ZONE_L_LEG,BODY_ZONE_R_LEG)

	else
		if(bpc & HEAD)
			covered_parts |= list(BODY_ZONE_HEAD)
		if(bpc & CHEST)
			covered_parts |= list(BODY_ZONE_CHEST)
		if(bpc & GROIN)
			covered_parts |= list(BODY_ZONE_CHEST)

		if(bpc & ARMS)
			covered_parts |= list(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM)
		else
			if(bpc & ARM_LEFT)
				covered_parts |= list(BODY_ZONE_L_ARM)
			if(bpc & ARM_RIGHT)
				covered_parts |= list(BODY_ZONE_R_ARM)

		if(bpc & HANDS)
			covered_parts |= list(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM)
		else
			if(bpc & HAND_LEFT)
				covered_parts |= list(BODY_ZONE_L_ARM)
			if(bpc & HAND_RIGHT)
				covered_parts |= list(BODY_ZONE_R_ARM)

		if(bpc & LEGS)
			covered_parts |= list(BODY_ZONE_L_LEG,BODY_ZONE_R_LEG)
		else
			if(bpc & LEG_LEFT)
				covered_parts |= list(BODY_ZONE_L_LEG)
			if(bpc & LEG_RIGHT)
				covered_parts |= list(BODY_ZONE_R_LEG)

		if(bpc & FEET)
			covered_parts |= list(BODY_ZONE_L_LEG,BODY_ZONE_R_LEG)
		else
			if(bpc & FOOT_LEFT)
				covered_parts |= list(BODY_ZONE_L_LEG)
			if(bpc & FOOT_RIGHT)
				covered_parts |= list(BODY_ZONE_R_LEG)

	return covered_parts

/proc/slot2body_zone(slot)
	switch(slot)
		if(ITEM_SLOT_BACK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_ICLOTHING, ITEM_SLOT_BELT, ITEM_SLOT_ID)
			return BODY_ZONE_CHEST

		if(ITEM_SLOT_GLOVES, ITEM_SLOT_HANDS, ITEM_SLOT_HANDCUFFED)
			return pick(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)

		if(ITEM_SLOT_HEAD, ITEM_SLOT_NECK, ITEM_SLOT_NECK, ITEM_SLOT_EARS)
			return BODY_ZONE_HEAD

		if(ITEM_SLOT_MASK)
			return BODY_ZONE_PRECISE_MOUTH

		if(ITEM_SLOT_EYES)
			return BODY_ZONE_PRECISE_EYES

		if(ITEM_SLOT_FEET)
			return pick(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)

		if(ITEM_SLOT_LEGCUFFED)
			return pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

//adapted from http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
/proc/heat2colour(temp)
	return rgb(heat2colour_r(temp), heat2colour_g(temp), heat2colour_b(temp))


/proc/heat2colour_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))


/proc/heat2colour_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221685293 * ((temp - 60) ** -0.075148492)))


/proc/heat2colour_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))


/proc/color2hex(color)	//web colors
	if(!color)
		return "#000000"

	switch(color)
		if("white")
			return "#FFFFFF"
		if("black")
			return "#000000"
		if("gray")
			return "#808080"
		if("brown")
			return "#A52A2A"
		if("red")
			return "#FF0000"
		if("darkred")
			return "#8B0000"
		if("crimson")
			return "#DC143C"
		if("orange")
			return "#FFA500"
		if("yellow")
			return "#FFFF00"
		if("green")
			return "#008000"
		if("lime")
			return "#00FF00"
		if("darkgreen")
			return "#006400"
		if("cyan")
			return "#00FFFF"
		if("blue")
			return "#0000FF"
		if("navy")
			return "#000080"
		if("teal")
			return "#008080"
		if("purple")
			return "#800080"
		if("indigo")
			return "#4B0082"
		else
			return "#FFFFFF"

/// Converts "#RRGGBB" to list(0xRR, 0xGG, 0xBB)
/proc/hex2rgb(color)
	var/r = hex2num(copytext(color, 2, 4))
	var/g = hex2num(copytext(color, 4, 6))
	var/b = hex2num(copytext(color, 6, 8))
	return list(r, g, b)

//This is a weird one:
//It returns a list of all var names found in the string
//These vars must be in the [var_name] format
//It's only a proc because it's used in more than one place

//Takes a string and a datum
//The string is well, obviously the string being checked
//The datum is used as a source for var names, to check validity
//Otherwise every single word could technically be a variable!
/proc/string2listofvars(t_string, datum/var_source)
	if(!t_string || !var_source)
		return list()

	. = list()

	var/var_found = findtext(t_string,"\[") //Not the actual variables, just a generic "should we even bother" check
	if(var_found)
		//Find var names

		// "A dog said hi [name]!"
		// splittext() --> list("A dog said hi ","name]!"
		// jointext() --> "A dog said hi name]!"
		// splittext() --> list("A","dog","said","hi","name]!")

		t_string = replacetext(t_string,"\[","\[ ")//Necessary to resolve "word[var_name]" scenarios
		var/list/list_value = splittext(t_string,"\[")
		var/intermediate_stage = jointext(list_value, null)

		list_value = splittext(intermediate_stage," ")
		for(var/value in list_value)
			if(findtext(value,"]"))
				value = splittext(value,"]") //"name]!" --> list("name","!")
				for(var/A in value)
					if(var_source.vars.Find(A))
						. += A

//assumes format #RRGGBB #rrggbb
/proc/color_hex2num(A)
	if(!A || length(A) != length_char(A))
		return 0
	var/rgb = hex2rgb(A)
	return rgb[1] + rgb[2] + rgb[3]

//word of warning: using a matrix like this as a color value will simplify it back to a string after being set
/proc/color_hex2color_matrix(string)
	var/length = length(string)
	if((length != 7 && length != 9) || length != length_char(string))
		return color_matrix_identity()
	var/r = hex2num(copytext(string, 2, 4))/255
	var/g = hex2num(copytext(string, 4, 6))/255
	var/b = hex2num(copytext(string, 6, 8))/255
	var/a = 1
	if(length == 9)
		a = hex2num(copytext(string, 8, 10))/255
	if(!isnum(r) || !isnum(g) || !isnum(b) || !isnum(a))
		return color_matrix_identity()
	return list(r,0,0,0, 0,g,0,0, 0,0,b,0, 0,0,0,a, 0,0,0,0)

//will drop all values not on the diagonal
/proc/color_matrix2color_hex(list/the_matrix)
	if(!istype(the_matrix) || the_matrix.len != 20)
		return "#ffffffff"
	return rgb(the_matrix[1]*255, the_matrix[6]*255, the_matrix[11]*255, the_matrix[16]*255)

/proc/type2parent(child)
	var/string_type = "[child]"
	var/last_slash = findlasttext(string_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return null
			if(/obj, /mob)
				return /atom/movable
			if(/area, /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(string_type, 1, last_slash))

//returns a string the last bit of a type, without the preceeding '/'
/proc/type2top(the_type)
	//handle the builtins manually
	if(!ispath(the_type))
		return
	switch(the_type)
		if(/datum)
			return "datum"
		if(/atom)
			return "atom"
		if(/obj)
			return "obj"
		if(/mob)
			return "mob"
		if(/area)
			return "area"
		if(/turf)
			return "turf"
		else //regex everything else (works for /proc too)
			return LOWER_TEXT(replacetext("[the_type]", "[type2parent(the_type)]/", ""))

/// Return html to load a url.
/// for use inside of browse() calls to html assets that might be loaded on a cdn.
/proc/url2htmlloader(url)
	return {"<html><head><meta http-equiv="refresh" content="0;URL='[url]'"/></head><body onLoad="parent.location='[url]'"></body></html>"}
