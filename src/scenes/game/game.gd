#### WIP
#### Add "cast, world map" lowest buttons
#### enlarge box with spell

extends Node2D

# possible locations (and ear-training drills)
enum LOC_STATE {int_u,int_d,int_r,int_h,triads}
# starting location (will be decided from the map)
export var location = LOC_STATE.int_u
#	available spells: (eventually will be into global vars or spellbook singleton)
export var available_spells = [["fireball",8],["heal",4]]
# Time allowed to score a critical
export var critical_time = 0.5
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
# keeps the details of the active spell
var active_spell = {"spell":"fireball","level":1}
# possibilities of intervals or triads (maybe useless)
var options_array = []
var right_answer_name_and_notes = []
# board Labels Values (initialize randomly):
var board_labels = ["1","2","3","4","5","6","7","8","9","10","11"]
# HP,MP power management
var HP_cur = playervars.HP_cur setget set_HP_cur
var MP_cur = playervars.MP_cur setget set_MP_cur
var critical_timer


func _ready():
	print_this(["initializing"])
	initialize_parallax()
	initialize_location()
	# initialize first spell
	set_active_spell(available_spells[0][0],available_spells[0][1])
  #	active_spell.level = available_spells[0]
	initialize_board()
	initializeSpellSelection()
	refresh_board()
	play_guess()
	# Initialize spellCasting timer
#	critical_timer = Timer.new()
#	critical_timer.connect("timeout",self,"_note_duration")
##	critical_timer.one_shot = true
#	critical_timer.wait_time = critical_time
##	critical_timer.add_to_group("timers")
#	add_child(critical_timer)
#	critical_timer.start()
	
	# connect it to the hourglass

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
		instanced_rune.connect("activated",self,"rune_btn_activated")
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
		
		
		
################
##   WIP: Do the initialize spell button as done in the other one
###
# Initializes the board
# (each rune button is in the group Rune_Btn)
func initializeSpellSelection():
	# Place all spells nodes in SideBtns
	for each in playervars.selectedSpells:
		var instanced_spell = Spell.instance()
		# number each spell in the script 
		print_this(["instanced spell: ",each])
		instanced_spell.spell_name = each
		# connect each signal
		instanced_spell.connect("spell_activated",self,"spell_name_activated")
		### Apply correct texture
		# qui c'e' da mettere la texture giusta
		# che corrisponde allo spell,
		# oppure inglobarla nello script dello spell stesso
		SideBtns.add_child(instanced_spell)


#   This func distributes labels to the pentagon
func refresh_board():
	# generate appropriate guess
	gen_guess()
	# activating N runes according to spell level
		#get all nodes in board Container
	for each in BoardCont.get_children():
#		print_this(["each",each])
		# if rune corresponds to label that is lower than spell level,
		# make it active
		if each.get_index()<= active_spell.level:
#			print_this(["options_array[each.btn_nb-1]",options_array[each.btn_nb-1]])
#			each.label = options_array[each.btn_nb-1]
			# set to state 0, meaning visible
			each.state = 1
#	for i in board_labels.size():
#		if
		# for each bal, set the label text to options_array
#		board_labels.append(options_array[i])
#	pass

func initialize_parallax():
	#	Different Parallax
	for i in 5:
		var BG_name = "SplitScreen/Top/bg" + str(i)
		var BG_node = get_node(BG_name)
		BG_node.set("slow_down",float(0.2)*i)
#		BG_node.set("slow_down",float(0.2)*i)
	print_this(["parallax initialized"])

# takes and array ["spell name",level] and
# and uses it to update into the
# active_spell dictionnary spell:"spell_name", level:level
# ex: [fireball,8] => {spell:"firaball",level:8}
func set_active_spell(spell_name,level):
	active_spell.spell = str(spell_name)
	active_spell.level = int(level)
	# notifty selection to screen
	notify("S", "selected: " + active_spell.spell)
	print_this(["actve_spell",active_spell])

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
		right_answer_name_and_notes = pn.gen_mel_int(options_array[active_spell.level],"u")
	# Take out options beyond spell level
	for i in (options_array.size()-active_spell.level):
		options_array.pop_back()
	# set answer name
	var answer_name = right_answer_name_and_notes[0]
	# find the right answer position in the array
	var right_answer_position = options_array.find(answer_name)
	# check that the right answer was found in the array
	if right_answer_position == -1:
		print("ERROR! \n")
		print("couldnt find right_answer '", answer_name,
			"' in options array '", options_array,"'" )
	# take out the right answer
	options_array.remove(right_answer_position)
	# We eant EXACTLY 11 options, and we have 1 set already.
	# (because the board has 11 slices)
	# So, convert to 10
	options_array_to_10()
	# shuffle options_array
	options_array=shuffleList(options_array)
	# put right answer back in
	options_array.append(answer_name)
	# shuffle array again
	options_array=shuffleList(options_array)
	print_this(["answer_name",answer_name,"options_array",options_array])
	# DONE! options array is ready to be used by board

func setUpSpellCast():
	#WIP
	critical_timer = Timer.new()
	critical_timer.connect("timeout",self,"_note_duration")
	critical_timer.one_shot = true
	critical_timer.wait_time = critical_time
	add_child(critical_timer)
	critical_timer.start()
	critical_timer.add_to_group("timers")

# This function plays the sound you have to guess
func play_guess():
	if location != LOC_STATE.triads and location != LOC_STATE.int_h:
		var answer_notes = right_answer_name_and_notes[1]
		print_this(["about to play 'answer_notes': ",answer_notes ])
		pn.play_int(answer_notes[0],answer_notes[1])

#	this func adds or subtracts random elements
# to options_array to make it exactly 10 elements
# elements are chosen from Interval Names
# and are within spell_level range
func options_array_to_10():
	if location != LOC_STATE.triads:
		# if array smaller than 10, add elements
		if options_array.size() < 10:
			# for every element lacking
			for empty_place in (10-options_array.size()):
				randomize()
				# get an index below spell level
				# adding +1 to skip unison
				var i = randi()%(active_spell.level+1)
				# add interval_name with that index
				# adding +1 to skip unison
				print_this(["pn.Int_Names",pn.Int_Names])
				options_array.append(pn.Int_Names[int(i+1)])
		# if array smaller than 10, add elements
		if options_array.size() < 10:
			# for every element extra
			for empty_place in (options_array.size()-10):
				# take out last element
				options_array.pop_back()
	# if array bigger than 10, remove elements
	# add extra elements to reach size 11!!
	pass


func _on_score_counter_timeout():
	Score.score += 1
	ScoreLabel.set_text(str(Score.score) +"ft")

func _on_player_death():
	$SplitScreen/Top/score_counter.stop()
	$SplitScreen/Top/DebrisSpawner.stop_spawning()
	$SplitScreen/Top/bg.stop_scrolling()
	pass

# board choice activated
func rune_btn_activated(btn_nb):
	deselect_all_board()
	# WIP
	# subtract mana
	# calculated how much time it has passed
	# get correspondent choice from btn_nb
#	var player_guess = options_array[btn_nb]
	# check if the choice is correct
	# if choice is correct,
		#cast selected spell
		#reset board
	#if choice is incorrect
		# spell fizzles
		# reset board
	pass
	
func spell_name_activated(spell_name):
	# keep button pressed, maybe? or use toggle
	pass


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







###########################################
#	PAYER VARS SECTION

# when you set HP, change progress bar
func set_HP_cur(new_value):
	# change progress bar
	HPBar.value = new_value
	playervars.HP_cur = new_value
#	print("HP_cur",HP_cur)
#	print("players.HP_cur",playervars.HP_cur)

# when you set HP, change progress bar
func set_MP_cur(new_value):
	# change progress bar
	MPBar.value = new_value
	playervars.MP_cur = new_value
#	print("HP_cur",HP_cur)
#	print("players.HP_cur",playervars.HP_cur)
	# add condition: if HP goes to zero, death signal sent
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
