extends Node
###########################################################
##########################################################
## VERSION 1.16
## Corrected a bug about random gen mel not within the interval
####
##
#### VERSION 1.15
## Added verbose option
####
##
## VERSION 1.10
## Added exclusion of unison in melodic interval generation
## (gen_mel_int)
## Also, Added interval as big as the range (it was excluded)
####
##
##
######
## VERSION 1.01
#### requires pianosim.gd and /audio with samples
######################################################

# Meta-Tools vars
var verbose_on = true
#################################

const short_length = 0.5
var interval_duration = 0.4
var time_btw_int = 0
var note_to_play_later
var duration_timer
var prog_timer
var playing_finished_timer
var timers = []
#var timer
#######################################################
#Create an Array Of Interval Names int_names: (number:interval)
##############################################################
const Int_Names = ["unison","m2","M2","m3","M3","P4","TT","P5",
	"m6","M6","m7","M7","P8","m9","M9","m10","M10","P11","#11",
	"P12","m13","M13"]
var Triad_Names_Nb = {}
var Tetra_Names_Nb = {}
var medium_register = ["3C","4C"]
signal playing_finished
#### used to stop sound engine:
#var playing_allowed = true

func _ready():
	###############################################################
	#Create a Dictionnary Of Triad Names int_names: (name:relative pitches)
	##############################################################
	Triad_Names_Nb["M"]=[0,4,7]
	Triad_Names_Nb["m"]=[0,3,7]
	Triad_Names_Nb["d"]=[0,3,6]
	Triad_Names_Nb["A"]=[0,4,8]
	Triad_Names_Nb["M64"]=[0,5,9]
	Triad_Names_Nb["m6"]=[0,4,9]
	Triad_Names_Nb["M6"]=[0,3,8]
	Triad_Names_Nb["m64"]=[0,5,8]
	Triad_Names_Nb["d6"]=[0,3,9]
	# Add tetra as well
	Triad_Names_Nb["MM7"]=[0,4,7,11]
	Triad_Names_Nb["Mm7"]=[0,4,7,10]
	Triad_Names_Nb["mM7"]=[0,3,7,11]
	Triad_Names_Nb["mm7"]=[0,3,7,10]
	##############################################################
	###############################################################
	#Create a Dictionnary Of Tetrachord Names int_names: (name:relative pitches)
	##############################################################
	Tetra_Names_Nb["MM7"]=[0,4,7,11]
	Tetra_Names_Nb["Mm7"]=[0,4,7,10]
	Tetra_Names_Nb["mM7"]=[0,3,7,11]
	Tetra_Names_Nb["mm7"]=[0,3,7,10]
	##############################################################

func play_int(note1,note2,duration=interval_duration):
	# IDEA: CONNECT SIGNAL OF NOTE PLAYED FINISHED, Maybe neeed a new node.
	if duration == null:
		duration = interval_duration
	var notes_nb
	notes_nb = pianosim.abs_note_to_nb(note1)
	if pianosim.abs_note_dict.has(str(notes_nb)):
#		print("playing",note1)
		pianosim._play_abs_note(note1,duration)
	duration_timer = Timer.new()
	duration_timer.connect("timeout",self,"_on_first_note_end", [note2,duration])
	add_child(duration_timer)
	duration_timer.wait_time = duration+time_btw_int
	duration_timer.start()

# This function waits for a little while after the first not ended,
# then plays the note "note" after a "duration"
func _on_first_note_end(note,duration):
	var notes_nb
	notes_nb = pianosim.abs_note_to_nb(note)
	if pianosim.abs_note_dict.has(str(notes_nb)):
#		print("playing",note)
		pianosim._play_abs_note(note,duration)
	duration_timer.queue_free()
	pass

func play_dyad(note1,note2):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=[note1,note2]
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim.abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
#			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass


func play_triad(note1,note2,note3):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=[note1,note2,note3]
	var notes_nb=[]
	for i in range (notes.size()):
		#convert notes to numbers
		notes_nb.append(pianosim.abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		#checks for errors
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
#			print("playing",notes[i])
			# Then plays the actual note
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass
	
# Takes a triad as an array of notes, 
# chooses a random different voicing of the triad each time
# The first node in the array of notes is treated as the root
# ex ["3C","3E","3G"] => ["C3","4C","E4","G5"]
# (expanded to tetrachords
func gen_rand_triad_voicing(triad_array):
	print("this is triad array", triad_array)
	#  convert each note to a number
	var root_nb = pianosim.abs_note_to_nb(triad_array[0])
	print("root_nb",root_nb)
	var third_nb = pianosim.abs_note_to_nb(triad_array[1])
	var fifth_nb = pianosim.abs_note_to_nb(triad_array[2])
	# add the case of fourth voice for tetrachords
	var seventh_nb
	if triad_array.size() >= 4:
		seventh_nb = pianosim.abs_note_to_nb(triad_array[3])
	#  create inversions as numbers
	# there could be more cases: where is ["C3","E4","G5"]?
	var root_v_nb = [root_nb,root_nb-12,third_nb,fifth_nb]
	var third_v_nb = [root_nb,root_nb+12,third_nb,fifth_nb]
	var fifth_v_nb = [root_nb,root_nb+12,third_nb+12,fifth_nb]
#	var oct_v_nb = [root_nb-12,root_nb,third_nb,fifth_nb]
#	var drop1_voiced_nb = [root_nb,root_nb+24,third_nb+12,fifth_nb+24]
	var drop2_v_nb = [root_nb,root_nb+12,third_nb,fifth_nb+12]
	# Add case of tetrachords:
	if triad_array.size() >= 4:
		root_v_nb.append(seventh_nb)
		third_v_nb.append(seventh_nb)
		fifth_v_nb.append(seventh_nb)
		drop2_v_nb.append(seventh_nb)
	# Put all voicings into one array
	var possible_voicings = [root_v_nb,third_v_nb,fifth_v_nb,drop2_v_nb]
	# Choose an element from an array randomly
	randomize()
	var rand_voicing_nb = possible_voicings[randi() % possible_voicings.size()]
	# convert it from an arry of notes_nb to an array of notes
	var rand_voicing = []
	for i in 4:
		rand_voicing.append(pianosim.abs_nb_to_note(rand_voicing_nb[i]))
	if triad_array.size() >= 4:
		rand_voicing.append(pianosim.abs_nb_to_note(seventh_nb))

	# return the value
	print("rand_voicing",rand_voicing)
	return rand_voicing

func play_tetra_n(note1,note2,note3,note4):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=[note1,note2,note3,note4]
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim.abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
#			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)

func play_voicing_n(notes_array,duration = short_length):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=notes_array
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim.abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
#			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],duration)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass


# function generates an array of two notes based on interval.
# interval is like m2, register should be the register in octave
# register is expressed in halfsteps 
#ex.1 m2, [4C,5C] => [4E,4F]
func gen_rand_int(interval,register = medium_register):
	var abs_low_note = pianosim.abs_note_to_nb(register[0])
	var abs_high_note = pianosim.abs_note_to_nb(register[1])
	var register_size = abs_high_note - abs_low_note
	randomize()
	var random_pick = randi() % register_size
	var starting_note = abs_low_note + random_pick
	# calculate interval adding starting node to interval in numbrers
	var nb_interval = [starting_note,starting_note+int_hs_from_int_name(interval)]
	# Convert nb interval into notes interval
#	print("nb_interval",nb_interval)
	var interval_array = [pianosim.abs_nb_to_note(nb_interval[0]),pianosim.abs_nb_to_note(nb_interval[1])]
#	if d2 == 0:
	return interval_array 
################### ERO ARRIVATO QUI SOPRA
	# WIP

# function generates a note based on interval.
# register is expressed in halfsteps 
#ex.1  [4C,5C] => 4Bb
func gen_rand_note(register = medium_register):
	# 	Simply using gen_rand_int
	var rand_int = gen_rand_int("m2",register)
	# take the first note of the interval
	var requested_note = rand_int[0]
	return requested_note
	
# returns the halfstepss - a number - from the interval name
# ex: m2 => 1, ex2: M3 => 5
func int_hs_from_int_name(interval_name):
	var interval_halfsteps
	for int_number in Int_Names.size():
		if interval_name == Int_Names[int_number]:
			interval_halfsteps = int_number
#			print("interval_halfsteps",interval_halfsteps)
			return interval_halfsteps
	print("couldn't find interval_name in Int_names")

#	This funcion generates a random melodic interval
#	Within a starting register "register" (ex [4C,5C])
# 	Within a maximum interval rng (ex: "P8")
#   According to a direction (r,u,d - random, up or down)
# 	The function also returns the interval NOTES as an array such as this one:
#	ex: {no argument} => [m2,[4D,4Eb]]
func gen_mel_int(rng = "P8",dir="r",register = medium_register, include_unison = false):
	# Initialize direction
	if dir == "r":
		#Pick random interval between up and down
		randomize()
		var d2 = randi() % 2
		if d2 == 0:
			dir = "u"
		else:
			dir = "d"
	# Determine upper note in nb form
	var int_upper_bound = int_hs_from_int_name(rng)
	# pick a random number between 1 and int_upper_bound
	var rand_pick = 1 + ( randi() % (int_upper_bound-1) )
	# Recalculate random number to include unison
	if include_unison:
		rand_pick = randi() % (int_upper_bound + 1)
	# Generates a random interval within rng
	var interval_name = Int_Names[rand_pick]
	# determine the notes to be played
	var int_notes = gen_rand_int(interval_name,register)
	#	If the interval is descending, change things up
	if dir == "d":
		int_notes = calc_d_interval(int_notes[0],interval_name)
	#	Put together the two datas into the final array
	var mel_interval = [interval_name,int_notes]
	# print_this(["mel_interval", mel_interval])
	return mel_interval
	
#	This funcion generates a harmonic interval
#	Within a starting register "register" (ex [4C,5C])
# 	Within a maximum interval rng (ex: "P8")
# 	The function also returns the interval NOTES as an array such as this one:
#	ex: {no argument} => [m2,[4D,4Eb]]
func gen_play_harm_int(rng = "P8",register = medium_register):
	# same as upward melodic interval!!
	var harm_interval = gen_mel_int(rng,"u",register)
	# return interval in form of 2 letters
	return harm_interval
	#WIP: is it working?

### This function takes an input of root+nomenclature
### Such as CM, or D#m64
### and generates the corresponding triad array
### so CM ==> ["C","E","G"]
### or D#m64 ==> ["A#","D#","E"]
func gen_triad_from_nomenclature(triadname):
	# Initialize numbers and octave
	var nature_nb = []
	var octave_nb = 3
	# Initialize error_check_flag
	var not_found = true
	# Separate root and nature (with approiate function)
	var root_nature_array = pianosim.separate_root_from_nomenclature(triadname)
	# take the root name 
	var triad_root = root_nature_array[0]
	# take the nature of the chord ( with appropriate function)
	var triad_nature = root_nature_array[1]
	# take the appropriate structure in nb that correspond to a chord nature
	for nature_name in Triad_Names_Nb.keys():
#		print("nature_name",nature_name)
		if triad_nature == nature_name:
			# create an array of those nbs
#			print("Triad_Names_Nb",Triad_Names_Nb)
			nature_nb = Triad_Names_Nb[nature_name]
			not_found = false
	# check if there was an error
	if not_found:
		print("Error, triad nature not found in Triad_Names_Nb")
	# convert the array of nbs into an array of notes
#	print("nature_nb", nature_nb)
	var triad_from_nomenclature = pianosim.abs_root_and_array_nb_to_abs_notes(str(octave_nb)+triad_root,nature_nb)
	# return the array
#	print("tfn: ",triad_from_nomenclature)
	return triad_from_nomenclature

### This function takes an input of abs_root+nomenclature
### Such as 4CM, or 3D#m64
### and generates the corresponding triad array
### so 4CM ==> ["4C","4E","4G"]
### or 3D#m64 ==> ["3A#","3D#","3F#"]
func gen_triad_from_abs_nomenclature(triadname):
	# Initialize numbers and octave
	var nature_nb = []
	var octave_nb = str(triadname)[0]
	# Initialize error_check_flag
	var not_found = true
	# Separate root and nature (with approiate function)
	# Exclude root abs number with right()
	var root_nature_array = pianosim.separate_root_from_nomenclature(str(triadname).right(1))
	# take the root name 
	var triad_root = root_nature_array[0]
	# take the nature of the chord ( with appropriate function)
	var triad_nature = root_nature_array[1]
	# take the appropriate structure in nb that correspond to a chord nature
	for nature_name in Triad_Names_Nb.keys():
#		print("nature_name",nature_name)
		if triad_nature == nature_name:
			# create an array of those nbs
#			print("Triad_Names_Nb",Triad_Names_Nb)
			nature_nb = Triad_Names_Nb[nature_name]
			not_found = false
	# check if there was an error
	if not_found:
		print("Error, triad nature not found in Triad_Names_Nb")
	# convert the array of nbs into an array of notes
#	print("nature_nb", nature_nb)
	var triad_from_abs_nomenclature = pianosim.abs_root_and_array_nb_to_abs_notes(str(octave_nb)+triad_root,nature_nb)
	# return the array
#	print("tfn: ",triad_from_nomenclature)
	return triad_from_abs_nomenclature

#	this func gets an array of nomenclatures of natures of triads
#	and generates random triads with root in a in a given register
#	ex: [["M,m,d"],[2C,4C]] => ["3G","bM"] 
func gen_rand_triad_from_nature_array_and_reg(natures_array,register = medium_register):
	randomize()
	var rand_nature_nb = randi() % natures_array.size()
	var rand_nature_name = natures_array[rand_nature_nb] 
	var root_note = gen_rand_note(register)
	var requested_triad = [str(root_note),str(rand_nature_name)] 
	return requested_triad

### This is playing the whole progression in an array as notes
### Input example: [["3C"."3E".""3G"],["4F","4A","4C"]].
### Each chord lasts "duration" secs and is played after "time_between" secs
func play_prog(array_of_arrays, time_between = short_length, duration = short_length):
	# clear pianosim
	pianosim.clear_old_nodes()
	# clear old timers
	clear_old_timers()
	var timer
	var wait_time = 0
#	var timers = []
	for chordposition in array_of_arrays.size():
		# set the timer to increasing time, based on chord
			# time = chordposition*(short_length+time_between)
		wait_time = chordposition*(duration+time_between)+0.1
		# create a timer, 
		timers.append(Timer.new())
		timer = timers[chordposition]
		# when timer goes off, play chord that timer
		timer.connect("timeout",self,"play_voicing_n",[array_of_arrays[chordposition],duration])
#		print("timers", timers, "timer",timer)
		timer.set_wait_time(wait_time)
		timer.set_one_shot(true)
		add_child(timer)
#		print("playing timer: ", chordposition)
		timer.start()
		timer.add_to_group("timers")
	# add a timer to send a signal that progression playing is over
	playing_finished_timer = Timer.new()
	var whole_prog_duration = array_of_arrays.size()*(duration+time_between)+0.1
	playing_finished_timer.connect("timeout",self,"playing_is_over")
	playing_finished_timer.set_wait_time(whole_prog_duration)
	playing_finished_timer.set_one_shot(true)
	add_child(playing_finished_timer)
	playing_finished_timer.start()
	playing_finished_timer.add_to_group("timers")
	
func playing_is_over():
	emit_signal("playing_finished")
	playing_finished_timer.queue_free()
	stop_all()
#	for each_timer in timers:
#		each_timer.queue_free()
# 	This functions returns an array of a descending interval
#   from an interval name and a starting note
#    ex: m2,4F => [4F,4E]	
func calc_d_interval(starting_note,interval_name):
	var start_note_nb = pianosim.abs_note_to_nb(starting_note)
	var interval_nb = int_hs_from_int_name(interval_name)
	#	Subtract the interval from start note and convert to note name
	var end_note = pianosim.abs_nb_to_note(start_note_nb-interval_nb)
	#   put it together in array form
	var final_array = [starting_note,end_note]
	return final_array
	
#	this function takes a pitch series and an abs_note
#	and generates an array of abs_notes
#	ex: ["4C","MM7"] => ["4C","4E","4G"] 
func gen_tetra_from_root(abs_note,tetra_name):
	var note_zero = pianosim.abs_note_to_nb(abs_note)
	var tetra_abs_nb = []
	var tetra_abs_name = []
	for each_note in Tetra_Names_Nb[tetra_name].size():
		tetra_abs_nb.append((Tetra_Names_Nb[tetra_name][each_note]+note_zero))
		tetra_abs_name = pianosim.abs_nb_to_note(tetra_abs_nb[each_note])
	return tetra_abs_name
	#WIP  verify that it actually works!
	
#	stops all sounds from playing,
#   just a replica of pianosim.stop_all()
func stop_all():
	pianosim.stop_all()
	pianosim.clear_old_nodes()
	clear_old_timers()
	emit_signal("playing_finished")
		
#	replica from pianosim
func mute_all():
	pianosim.mute_all()

#	replica from pianosim
func unmute_all():
	pianosim.unmute_all()
	
#func clear_up():
#	for each_child_nb in self.get_child_count():
##		print("self",self)
#		#	then pick each indexed children
#		var each_child = get_child(each_child_nb)
#		#	if a child is a sound stream, call fade out on them
##		if each_child.is_in_group("sounds") or each_child.is_in_group("timers"):
##		if each_child.is_in_group("timers"):
##			if (!each_child.is_playing()):
#		each_child.queue_free()
#
func clear_old_timers():
#	pass
	for each_child_nb in self.get_child_count():
#		print("self",self)
		#	then pick each indexed children
		var each_child = get_child(each_child_nb)
		#	if a child is a sound stream, call fade out on them
#		if each_child.is_in_group("sounds") or each_child.is_in_group("timers"):
		if each_child.is_in_group("timers"):
#			if (!each_child.is_playing()):
			each_child.queue_free()
#			print("each_child", each_child)
	timers.clear()

#	What if I deleted the whole script pn.gd? actually both.
# With a function called "reset sounds"
#func reset_sounds():
#	pass
	# delete pianosim
#	pianosim.total_reset()
#	get_node("/root/pn").reload_current_scene()
	# delete pn
	# load pianosim
	# load pn
		#WIP
		
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