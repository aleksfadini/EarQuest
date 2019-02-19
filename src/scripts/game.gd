#### WIP
##### add dark stones in the ground to make interesting bg
#### change stone sizes randomly
#### Add " world map" lowest buttons

extends Node2D

# possible locations (and ear-training drills)
enum LOC_STATE {int_u,int_d,int_r,int_h,triads}
# starting location (will be decided from the map)
export var location = LOC_STATE.int_u
#	available spells: (eventually will be into global vars or spellbook singleton)
#var selectedSpells = playervars.selectedSpells
# time in seconds for a critical tick to happen
var critical_time = 0.1
# Time allowed to score a critical in ticks
export var critical_max_ticks = 30
# mouse click state
#enum MS_STATE { dragging, released }

#  Nodes Names for further reference
onready var BoardCont = $Overlay/HBox/MidVBox/BoardCont/Board
onready var SideBtns = $Overlay/HBox/MidVBox/SideCont/SideBtns
onready var HPBar = $Overlay/HBox/Top/HPBar
onready var MPBar = $Overlay/HBox/Top/MPBar
onready var HGlass = $Overlay/HBox/Top/HGlass
onready var ScoreLabel = $Overlay/HBox/Top/score_label
onready var SelSpellLabel = $Overlay/HBox/Top/SelSpell
onready var SelLetter = $Overlay/HBox/Top/SelSpell
var Rune=preload("res://src/scenes/game/rune.tscn")
var Spell=preload("res://src/scenes/game/spell.tscn")

# Meta-Tools vars
var verbose_on = true

#################################################
# Used in scrips
# The spell that will be casted (determined by the buttons
# and the function spellBtnPressed)
var activeSpell = {"name":"fireball","level":1}
# possibilities of intervals or triads (maybe useless)
var options_array = []
var right_answer_name_and_notes = []
# board Labels Values (initialize randomly):
#var board_labels = ["1","2","3","4","5","6","7","8","9","10","11"]
# HP,MP power management
var HP_cur = playervars.HP_cur setget set_HP_cur,get_HP_cur
var MP_cur = playervars.MP_cur setget set_MP_cur,get_MP_cur
var critical_timer
var critical_ticks_elapsed = 0
# True if spell is cast within critical time
var spellInCriticalArea = false

func _ready():
	print_this(["initializing"])
	initialize_parallax()
	initialize_location()
	# initialize first spell
	# WIP
#	set_activeSpell(available_spells[0][0],available_spells[0][1])
  #	activeSpell.level = available_spells[0]
	initialize_board()
	initializeSpellBar()
	initializeSpellCastSystem()
#	refresh_board()
#	play_guess()
	# Initialize spellCasting timer
#	critical_timer = Timer.new()
#	critical_timer.connect("timeout",self,"_note_duration")
##	critical_timer.one_shot = true
#	critical_timer.wait_time = critical_time
##	critical_timer.add_to_group("timers")
#	add_child(critical_timer)
#	critical_timer.start()
	


#	initialize data of location and general difficulty,
#	type of exercise, eventually progress scaling
func initialize_location():
	if location == LOC_STATE.int_u:
		pass
	pass


# Initializes the board
# (each rune button is in the group Rune_Btn)
func initialize_board():
	#place all rune nodes in board Container
#	for each in BoardCont.get_children():
	for each in 25:
#	for each in pn.Int_Names.size()-1:
		var instanced_rune = Rune.instance()
		# add each rune to the group "Rune_Btn"
#			instanced_rune.add_to_group("rune")
		# number each Rune in the script (Starting from 0)
		print_this(["instanced rune: ",each])
		instanced_rune.btn_nb = each
		# connect each signal
		instanced_rune.connect("activated",self,"onGuessBtnPressed")
		# apply correct label	
		if each < pn.Int_Names.size()-1:
			# skip Int_Names[0], since it is a unison
			instanced_rune.label = pn.Int_Names[each+1]
		else:
			# once you get to the end of the array, exit
			pass
		# make inactive (USELESS)
		# WIP
		# Why this is not working??
		# I only see 16 buttons
#		instanced_rune.state=1
		BoardCont.add_child(instanced_rune)


# Initializes the board
# (each rune button is in the group Rune_Btn)
func initializeSpellBar():
	# Place all spells nodes in SideBtns
	for each in playervars.selectedSpells:
		var instanced_spell = Spell.instance()
		# number each spell in the script 
		print_this(["instanced spell: ",each])
		instanced_spell.spell_name = each
		# connect each signal
		instanced_spell.connect("spell_activated",self,"spellBtnPressed")
		# add each as an instance
		SideBtns.add_child(instanced_spell)
	# Add the general Spell Casting Button
	var instanced_spell = Spell.instance()
	instanced_spell.spell_name = "cast"
	instanced_spell.connect("spell_activated",self,"spellBtnPressed")
	SideBtns.add_child(instanced_spell)

#   This func distributes labels to the pentagon
func refresh_board():
	# Activate N runes according to spell level
		#get all nodes in board Container
	for each in BoardCont.get_children():
#		print_this(["each",each])
		# Make each button inactive (invisible)
		# set to state 0, meaning inactive
		each.state = 0
		## if rune corresponds to label that is lower than spell level,
		## make it active
		if each.get_index()< activeSpell.level:
#			print_this(["options_array[each.btn_nb-1]",options_array[each.btn_nb-1]])
#			each.label = options_array[each.btn_nb-1]
			# set to state 1, meaning active
			each.state = 1
#	for i in board_labels.size():
#		if
		# for each bal, set the label text to options_array
#		board_labels.append(options_array[i])
#	pass

func initialize_parallax():
	#	Different Parallax
	for i in 6:
		var BG_name = "SplitScreen/Top/bg" + str(i)
		var BG_node = get_node(BG_name)
		# WIP ADD AUTOMATIC TEXTURE MANAGEMENT!!!	
		# Do Not Slow Down Front BG layers 
		# (optional, already the default option)
#		if BG_name <= 2:
#			BG_node.set("slow_down",0)
		# Slow down background layers
		# Verify that the background is not flowing too slowly
		if int(BG_name) >= 1:
			BG_node.set("slow_down",float(0.2)*(i-1))
#		BG_node.set("slow_down",float(0.2)*i)
	print_this(["parallax initialized"])

func initializeSpellCastSystem():
	# to a "initialize casting system function"
	critical_timer = Timer.new()
	critical_timer.connect("timeout",self,"_onCriticalTick")
	critical_timer.one_shot = false
	critical_timer.wait_time = critical_time
	add_child(critical_timer)
	critical_timer.add_to_group("timers")
	#WIP
	# connect it to the hourglass
	

# USELESS?
# takes and array ["spell name",level] and
# and uses it to update into the
# activeSpell dictionnary spell:"spell_name", level:level
# ex: [fireball,8] => {spell:"firaball",level:8}
#func set_activeSpell(spell_name,level):
#	activeSpell.spell = str(spell_name)
#	activeSpell.level = int(level)
#	# notifty selection to screen
#	notify("S", "selected: " + activeSpell.spell)
#	print_this(["actve_spell",activeSpell])



# This is the notification system
# to give  feedback about what is happening
func notify(letter,content):
	SelLetter.set_text(letter)
	# should show a "S"
	# WIP
	SelSpellLabel.set_text(content)

#   This func generates right guess and some fake options
# depending on the spell level, and puts it in the arrays
# options_array and right_answer
func gen_guess():
	# reset the options_array
	options_array.clear()
	right_answer_name_and_notes.clear()
	# if the location requires an interval
	if location != LOC_STATE.triads:
		# then initialize the array with all interval names
		for i in pn.Int_Names.size():
			options_array.append(pn.Int_Names[i])
		# take out the first interval, it's a unison
		options_array.pop_front()
	# determine right generation depeding on location us pn funcionts
	if location == LOC_STATE.int_u:
		var dir_int = "u"
	if location == LOC_STATE.int_d:
		var dir_int = "d"
	if location == LOC_STATE.int_r:
		var dir_int = "r"
	# if the location requires a melodic interval, generate it
	if location != LOC_STATE.triads and location != LOC_STATE.int_h:
		right_answer_name_and_notes = pn.gen_mel_int(options_array[activeSpell.level],"u")
	# Take out options beyond spell level
	for i in (options_array.size()-activeSpell.level):
		options_array.pop_back()
	# set answer name
	var answer_name = right_answer_name_and_notes[0]
	
	### Probably don't need this
#	# find the right answer position in the array
#	var right_answer_position = options_array.find(answer_name)
#	# check that the right answer was found in the array
#	# (-1 means that the function .find did not find anything)
#	if right_answer_position == -1:
#		print("ERROR! \n")
#		print("couldnt find right_answer '", answer_name,
#			"' in options array '", options_array,"'" )
#	print_this(["generated interavl (answer_name): ", answer_name,"options_array: ", options_array])

	#### THIS is all useless, was used in the pentacle
#
#
#	# take out the right answer
#	options_array.remove(right_answer_position)
#
#
#	# We eant EXACTLY 11 options, and we have 1 set already.
#	# (because the board has 11 slices)
#	# So, convert to 10
#	options_array_to_10()
#	# shuffle options_array
#	options_array=shuffleList(options_array)
#	# put right answer back in
#	options_array.append(answer_name)
#	# shuffle array again
#	options_array=shuffleList(options_array)



# This function plays the sound you have to guess
func play_guess():
	if location != LOC_STATE.triads and location != LOC_STATE.int_h:
		var answer_notes = right_answer_name_and_notes[1]
		print_this(["about to play 'answer_notes': ",answer_notes ])
		pn.play_int(answer_notes[0],answer_notes[1])
# WIP NOTE DURATION DEBUGGING PROBLEM HERE!!


### This function used to be useful in the pentacle
##	this func adds or subtracts random elements
## to options_array to make it exactly 10 elements
## elements are chosen from Interval Names
## and are within spell_level range
#func options_array_to_10():
#	if location != LOC_STATE.triads:
#		# if array smaller than 10, add elements
#		if options_array.size() < 10:
#			# for every element lacking
#			for empty_place in (10-options_array.size()):
#				randomize()
#				# get an index below spell level
#				# adding +1 to skip unison
#				var i = randi()%(activeSpell.level+1)
#				# add interval_name with that index
#				# adding +1 to skip unison
#				# print_this(["pn.Int_Names",pn.Int_Names])
#				options_array.append(pn.Int_Names[int(i+1)])
#		# if array smaller than 10, add elements
#		if options_array.size() < 10:
#			# for every element extra
#			for empty_place in (options_array.size()-10):
#				# take out last element
#				options_array.pop_back()
#	# if array bigger than 10, remove elements
#	# add extra elements to reach size 11!!
#	pass


func _on_score_counter_timeout():
	Score.score += 1
	ScoreLabel.set_text(str(Score.score) +"ft")

func _on_player_death():
	$SplitScreen/Top/score_counter.stop()
	$SplitScreen/Top/DebrisSpawner.stop_spawning()
	$SplitScreen/Top/bg.stop_scrolling()
	pass


func spellBtnPressed(spell_name):
	if spell_name == "cast":
		precastSpell()
	if spell_name != "cast":
		# set activeSpell name and level
		activeSpell.name= spell_name
		activeSpell.level=playervars.playerSpellbook[spell_name].level
		# notifty selection to screen
		notify("S", "selected: " + activeSpell.name)
		print_this(["actveSpell:", activeSpell])
	# WIP
	pass

# Cast the active spell
func precastSpell():
	#Generate a guess
	gen_guess()
	# play the guess
	play_guess()
	# refresh the board
	refresh_board()
	# start the critical Timer
	startCriticalTimer()
	# subtract mana correspondent to spell level
	subtractMana()
	print_this([activeSpell, "SPELL PREPARED!!!"])	

# board choice activated - after preCastspell
func onGuessBtnPressed(btn_nb):
	deselect_all_board()
	# get correspondent choice from btn_nb
	var playerGuess = options_array[btn_nb]
	print_this(["Answer selected (options_array.btn_nb)", playerGuess])
	# Check if the choice is correct
	# if choice is correct,
	if playerGuess == right_answer_name_and_notes[0]:
		print_this(["answer correct"])
		# isolate right button (for feedback)
		isolateGuessBtn(btn_nb)
		#cast selected spell
		castSpell()
		# reset cast button
		resetCastButton()
	#if choice is incorrect
	else:
		spellFizzle(btn_nb)
		# spell fizzles
	# WIP
	# reset board (not necessary, already at the top)
	pass
	

func castSpell():
	print_this(["spell casted", activeSpell.name])
	if activeSpell.name == "fireball":
		print_this(["casting fireball!!!"])

# Subtract mana equally to spell level
func subtractMana():
	set_MP_cur(get_MP_cur()-activeSpell.level)	

# start the critical Timer
func startCriticalTimer():
	# set critical ticks to zero
	critical_ticks_elapsed = 0
	# initialize the critialArea flag
	spellInCriticalArea = true
	# start the timer
	critical_timer.start()
	# fill the hourglass
	HGlass.value=100

# Called each tick that the critical time is ticking
func _onCriticalTick():
	# add a tick
	critical_ticks_elapsed += 1
#	print_this([activeSpell, "Critical Timer Ticking", critical_ticks_elapsed])
	# update hourglass bar
	HGlass.value = 100*(1-(critical_ticks_elapsed/float(critical_max_ticks)))
	# blink the critical light
	blinkCriticalLight(true)
	if critical_ticks_elapsed >= critical_max_ticks:
		# Set the flag of critial to false
		spellInCriticalArea = false
		# stop the timer
		critical_timer.stop()
		# stop the blinking
		blinkCriticalLight(false)
	pass

func resetCastButton():
	# find cast button
	for each in SideBtns.get_children():
		if each.is_in_group("cast"):
			# deselect cast button
			# set to state 0, meaning inactive
			each.state = 0	
	pass

# this function turns the blinking or of off
func blinkCriticalLight(startBlinking = false):
	var criticalLight = $Overlay/HBox/Top/CritBall
	if startBlinking == false:
		criticalLight.set_animation("lightoff")
		criticalLight.play("lightoff")
	if startBlinking == true:
		criticalLight.set_animation("blinking")
		criticalLight.play("blinking")
	pass

func spellFizzle(wrong_btn_nb):
	# WIP
	# play animation of spell fizzle
	# play sound of spell fizzle!? (maybe no)
	# deactivate the wrong button
	deactivateGuessBtn(wrong_btn_nb)
	# subtract mana
	subtractMana()
	# replay the interval
	play_guess()
	pass
	
# Deactivate a specific guess Button
func deactivateGuessBtn(any_btn_nb):
		#get all nodes in board Container
	for each in BoardCont.get_children():
#		each.state = 0
		# find specific button
		if each.get_index() == any_btn_nb:
			# set to state 0, meaning inactive
			each.state = 0
	pass

# Make a specific Guess Btn the only btn visible
func isolateGuessBtn(any_btn_nb):
		#get all nodes in board Container
	for each in BoardCont.get_children():
			# set to state 0, meaning inactive
		each.state = 0
		# find specific button
		if each.get_index() == any_btn_nb:
			# set to state 0, meaning active
			each.state = 1
	pass	






###########################################
#	PAYER VARS SECTION

# when you set HP, change progress bar
func set_HP_cur(new_value):
	# change progress bar
	HPBar.value = new_value
	playervars.HP_cur = new_value
#	print("HP_cur",HP_cur)
#	print("players.HP_cur",playervars.HP_cur)
	# add condition: if HP goes to zero, death signal sent

func get_HP_cur():
	return playervars.HP_cur 

# when you set HP, change progress bar
func set_MP_cur(new_value):
	# change progress bar
	MPBar.value = new_value
	playervars.MP_cur = new_value
#	print("HP_cur",HP_cur)
#	print("players.HP_cur",playervars.HP_cur)
	
func get_MP_cur():
	return playervars.MP_cur 

##################################################
#	This handles the input system with the board
# func _input(event):
# # this handles every event, otherwise:
# #func _unhandled_input(event):
# 	# when the mouse changes state:
# 	if event is InputEventMouseButton:
# 		if event.is_pressed():
# 			# defined dragging
# 			pointer_state = MS_STATE.dragging
# 		else:
# 			# define releasing
# 			pointer_state = MS_STATE.released
# 		pass
# 		# get all objects
# 		var space_state = get_world_2d().direct_space_state
# 		# get pointer position
# 		var pos = event.position
# 		# get what is under the pointer
# 		var overlapping = space_state.intersect_point(pos)
		# # if the pointer overlaps with another obj
		# if overlapping.size() > 0:
		# # Look through the array until you find an Area2d
		# 	for each in overlapping.size():
		# 		# get the each collider in the overlapping dictionnary
		# 		var collided_obj=overlapping[each].collider
		# 		# if the collider is a node area, get the parent node
		# 		print_this(["collided_obj: ",collided_obj])
		# 		# if it is a piece of the pentagon
		# 		if collided_obj.is_in_group("Pent_Area"):
		# 			# get parent node of collided area, which is a Rune_Btn
		# 			var collided_node = overlapping[each].collider.get_parent()
		# 			print_this(["collided_node",collided_node])
		# 			if pointer_state == MS_STATE.dragging:
		# 				deselect_all_board()
		# 				collided_node.state = BTN_STATE.pressed
		# 				#WIP
		# 				# ADD depress others!
		# 			if pointer_state == MS_STATE.released:
		# 				deselect_all_board()
		# 				collided_node.state = BTN_STATE.activated
	# if the mouse is draggin over other buttons, depress previous ones
# 	elif (event is InputEventMouseMotion
# 		and pointer_state == MS_STATE.dragging):
# 		var space_state = get_world_2d().direct_space_state
# 		# get pointer position
# 		var pos = event.position
# 		# get what is under the pointer
# 		var overlapping = space_state.intersect_point(pos)
# 		if overlapping.size() > 0:
# 		# Look through the array until you find an Area2d
# 			for each in overlapping.size():
# 				# get the each collider in the overlapping dictionnary
# 				var collided_obj=overlapping[each].collider
# 				# if the collider is a node area, get the parent node
# #				print_this(["collided_obj: ",collided_obj])
# 				# if it is a piece of the pentagon
# 				if collided_obj.is_in_group("Pent_Area"):
# 					# get parent node of collided area, which is a Rune_btn
# 					var collided_node = overlapping[each].collider.get_parent()
# 					print_this(["collided_node",collided_node])
# 					if pointer_state == MS_STATE.dragging:
# 						deselect_all_board()
# 						collided_node.state = BTN_STATE.pressed
# 						#WIP
# 						# ADD depress others!
# 					if pointer_state == MS_STATE.released:
# 						deselect_all_board()
# 						collided_node.state = BTN_STATE.activated
		# pass

func deselect_all_board():
		#get all nodes in board Container
	for each in BoardCont.get_children():
		# if node is a pentagon button
#		print("each",each)
		# if each.is_in_group("Rune_Btn"):
		each.get_child(0).pressed = false
	pass

# THIS WILL BE USELESS WHEN IT WILL BE IN THE SPELL SCRIPT
#func deselect_all_spells():
#	# get all nodes in board Container
#	for each in SideBtns.get_children():
#		# if node is a "spells" 
#		if each.is_in_group("spells"):
#			# depress it
#			each.get_child(0).pressed = false
#			# 0 would be BTN.inactive
#			each.state=0
#	pass


#########################################
#
#        META TOOLS
#
#########################################
func print_this(argument):
	# Comment out next two lines when verbose is not needed
	if verbose_on:
		print(argument)
	pass
	
	
#############################################################
# POSSIBLY USELESS TOOLS
##
# shuffles an array
func shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        randomize()
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList


