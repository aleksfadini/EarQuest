extends Node
###########################################################
##########################################################
#### VERSION 1.1  (added local dir)
#### feeds piano.gd and requires /samples with samples
####
#### Earlier versions:
#### 1.1  (added stop_all)
######################################################
var octave = ["A","Bb","B","C","Db","D","Eb","E","F","Gb","G","Ab"]
var abs_note_dict = {}
#var PlayNote
var NotesSamples = {}
var duration_timer
var fade_out_timer
var tween_out
var transition_duration = 0.05
var transition_type = 0 # TRANS_LIN
#### used to stop sound engine:
export var playing_allowed = true

func _ready():
	print("SCRIPT LOADING!!!!")
	#######################################################
	#Create a Dictionnary abs_notes_dict: (number:note)
	#And load samples in NotesSamples: (note:sample)
	##############################################################
	# get the directory of the script
	var pianosim_dir = self.get_script().get_path().get_base_dir()
	for i in range(88):
		# start on A0
		var oct = int((i+9)/12)
		# cycle note
		var note = fmod(i,12)
		# this creates a dictionnary notes in the format number+pitch, 
		# like {[0:0A],[1:7A], etc...}
		var abs_note_i = (str(oct)+octave[note])
		abs_note_dict[str(i)]= abs_note_i
		# Load samples
		NotesSamples[str(abs_note_i)]=load(pianosim_dir+"/samples/"+str(abs_note_i)+".ogg")
#		print( i,abs_note_dict[str(i)])
#	print( "abs_note", abs_note)
#	print( "abs_note", int(abs_note["C0"]))
#	print(NotesSamples)
#	PlayNote= AudioStreamPlayer.new()
	########################################3
	# Initialize tween_out
	tween_out = Tween.new()
	add_child(tween_out)
	tween_out.connect("tween_completed",self,"_on_TweenOut_tween_completed")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _play_abs_note(abs_note,duration):
#	.propagate_call("queue_free", [])
#	clear_nodes()
	if playing_allowed:
	#	var note_nb = _abs_note_to_nb()
		var PlayNote= AudioStreamPlayer.new()
	#	tween_out = Tween.new()
	#	add_child(tween_out)
	#	tween_out.connect("tween_completed",self,"_on_TweenOut_tween_completed")
	#	if NotesSamples.has(abs_note):
		PlayNote.set_stream(NotesSamples[abs_note])
	#	else:
	#		PlayNote.set_stream(NotesSamples.C3)
	#		PlayNote.set_pitch_scale(1.083)
	#		pass
		PlayNote.set_volume_db(-20)
		add_child(PlayNote)
		#    Also add to grouo "sounds", used to  delete sounds later on
		PlayNote.add_to_group("sounds")
		PlayNote.play(0)
	#	print("playing")
		duration_timer = Timer.new()
		duration_timer.connect("timeout",self,"_note_duration", [PlayNote])
		duration_timer.one_shot = true
		add_child(duration_timer)
		duration_timer.wait_time = duration
		duration_timer.start()
		duration_timer.add_to_group("timers")
#		PlayNote.queue_free()
		# This func generates the correct sound corresponding to the right note requested in letter and octave
	pass

func _note_duration(PlayNote):
	fade_out(PlayNote)
#	fade_out_timer = Timer.new()
#	fade_out_timer.connect("timeout",self,"_note_stop")
#	add_child(timer)
#	fade_out_timer.wait_time = 0.1
#	fade_out_timer.start()

func fade_out(stream_player):
#	print("stream_player",stream_player)
    # tween music volume down to 0
	tween_out.interpolate_property(stream_player, 
	"volume_db", stream_player.get_volume_db(), 
	-80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
    # when the tween ends, the music will be stopped

func _on_TweenOut_tween_completed(object, key):
    # stop the music -- otherwise it continues to run at silent volume
	object.stop()
#	print("object",object)
#	if object.is_playing() == false:
#		object.queue_free()
#	clear_nodes()
#	You should free the timers somehow
#	duration_timer.queue_free()
	# this might bug out

#func _note_stop():
#	NotesSamples[abs_note].set_volume_db-=1
#	PlayNote.stop()
	
# this takes a note in letter and number form and converts it to a number
# ex: 3C ==> 43 (maybe it's not the right number, just guessing
func abs_note_to_nb(abs_note):
	var result
	for i in range (abs_note_dict.size()):
		var key = str(i)
		if abs_note_dict[key] == abs_note:
			result = int(i)
#			print("found",abs_note,result)
	# returns the number of a note in letter and octave
#	var result = int(abs_note[str(note)])
	return result
	
func abs_nb_to_note(number):
	# returns the note in letter and octave from a number
	var result= str(abs_note_dict[str(number)])
	return result

# Takes a root note and an array of number and returns an array of notes
# ex: ("C3",[0,3]) => ["C3","Eb3"]	
func abs_root_and_array_nb_to_abs_notes(root_note,array_of_numbers):
	print("root_note",root_note)
	var root_nb = abs_note_to_nb(root_note) # this is not working!
	print(root_nb)
	var nb_array = []
	var abs_note_array = []
	for each in array_of_numbers.size():
#		print("array_of_numbers[",each,"]",array_of_numbers[each])
		nb_array.append(root_nb+array_of_numbers[each])
		abs_note_array.append(abs_nb_to_note(nb_array[each]))
#		print("ABS",abs_note_array)
	return abs_note_array
	
# This function gets a letter as an input, and if it has a Sharp it converts it to a flat
# Ex: A => A
# Ex: G# => Ab
# Ex: E# = F
func convert_sharps_to_flat(note_initial):
	var note_converted
	note_converted = note_initial
	var convertible_notes = ["A#","B#","C#","D#","E#","F#","G#"]
	var converted_notes = ["Bb","C","Db","Eb","F","Gb","Ab"]
	for i in convertible_notes.size():
		if note_initial == convertible_notes[i]:
			note_converted = converted_notes[i]
	return note_converted
	
# takes a classical triad written in nomenclature - ex F#m6/4
# and returns the root in flats and nature - ex ["Gb","6/4"]	
# Ex: E#6 => ["F","6"], Ex: Cd => ["C","d"]
func separate_root_from_nomenclature(triadname):
	var triad_root
	var triad_nature
	var triad_letters = []
	var success = false
	for i in triadname:
		triad_letters.append(i)
	var first_char = triad_letters[0]
	var second_char = triad_letters[1]
	triad_root = first_char
	triad_nature = triadname.substr(1,triadname.length())
	if second_char == "#":
		#If there is a sharp, convert to the notation with flats
		triad_root = convert_sharps_to_flat(str(first_char+"#"))
		triad_nature = triadname.substr(2,triadname.length())
	if second_char == "b":
		triad_nature = triadname.substr(2,triadname.length())
		triad_root = triad_root + "b"
	# (cycle through possible roots)
	for i in octave.size():
		if triad_root == octave[i]:
			return [triad_root,triad_nature]
			success = true
	if !success:
		print("error with root recognition")
	
# This function just picks a root within the octave
# Ex: => "Ab"
func gen_rand_root():
	randomize()
	var random_pick = randi() % 12
	var rand_root = str(octave[random_pick])
	return rand_root
	
# This function just adds a random octave to a note
# ex =>"6C"
func gen_rand_abs_root():
	randomize()
	var random_pick = randi() % 88
	var rand_root = abs_nb_to_note(random_pick)
	return rand_root

#	This function generates a random note
#   inside of an array of notes
#   ex: [C4,C5] => Gb4
func rand_note_within_interval(notes_array):
	# Convert both notes into numbers
	var nb_low_note = abs_note_to_nb(notes_array[0])
	var nb_high_note = abs_note_to_nb(notes_array[1])
	var register_size = nb_high_note - nb_low_note
	# pick a random  number in between
	randomize()
	var random_pick = randi() % register_size
	# return the number as a note, after adding the lowest note
	var rand_node = abs_nb_to_note(nb_low_note+random_pick)
	return rand_node
	
#	This function stop all sounds
func stop_all():
	#	Look for each children, first count them
	for each_child_nb in self.get_child_count():
		#	then pick each indexed children
		var each_child = get_child(each_child_nb)
#		print("each child", each_child)
		#	if a child is a sound stream, call fade out on them
		if each_child.is_in_group("sounds"):
			#    call fade out
#			print("is it? ", each_child)
			fade_out(each_child)
#	clear_nodes()
#	print("fade out and stop signal sent to all")
		#WIP done, but check if this works!
	pass
	
func mute_all():
	playing_allowed = false
	print("muted")

func unmute_all():
	playing_allowed = true
	print("unmuted")
	
func clear_old_nodes():
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
		# clear sounds
		if each_child.is_in_group("sounds"):
#			if (!each_child.is_playing()):
			each_child.queue_free()
#			print("each_child", each_child)
