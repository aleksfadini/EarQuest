extends Node

var short_length = 0.5
var interval_duration = 0.4
var time_btw_int = 0
var note_to_play_later
var duration_timer

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _play_int(note1,note2,duration=interval_duration):
	# IDEA: CONNECT SIGNAL OF NOTE PLAYED FINISHED, Maybe neeed a new node.
	if duration == null:
		duration = interval_duration
	var notes_nb
	notes_nb = pianosim._abs_note_to_nb(note1)
	if pianosim.abs_note_dict.has(str(notes_nb)):
		print("playing",note1)
		pianosim._play_abs_note(note1,duration)
	duration_timer = Timer.new()
	duration_timer.connect("timeout",self,"_on_first_note_end", [note2,duration])
	add_child(duration_timer)
	duration_timer.wait_time = duration+time_btw_int
	duration_timer.start()
	
func _on_first_note_end(note,duration):
	var notes_nb
	notes_nb = pianosim._abs_note_to_nb(note)
	if pianosim.abs_note_dict.has(str(notes_nb)):
		print("playing",note)
		pianosim._play_abs_note(note,duration)
	duration_timer.queue_free()
	pass
	

func _play_dyad(note1,note2):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=[note1,note2]
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim._abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass
	

func _play_triad(note1,note2,note3):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=[note1,note2,note3]
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim._abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass

func _play_tetra(note1,note2,note3,note4):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=[note1,note2,note3,note4]
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim._abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass
	
func _play_voicing(notes_array):
	# Just change the notes array to make dyads and 4 notes chords
	var notes=notes_array
	var notes_nb=[]
	for i in range (notes.size()):
		notes_nb.append(pianosim._abs_note_to_nb(notes[i]))
#		print(notes_nb[i])
		if pianosim.abs_note_dict.has(str(notes_nb[i])):
			print("playing",notes[i])
			pianosim._play_abs_note(notes[i],short_length)
#	if pianosim.abs_note_dict.has(note2):
#		pianosim._play_abs_note(note2,0.5)
#		print("playing",note2)
#	if pianosim.abs_note_dict.has(note3):
#		pianosim._play_abs_note(note3,0.5)
#		print("playing",note3)
	pass


### These might be in another file at some point
func _play_mel_interval(interval,rng,dir):
	pass
	
func _play_harm_interval(interval,rng):
	pass

### This is playing the whole progression
### Input example: [["3C"."3E".""3G"],["4F","4A","4C"]].
func _play_prog(array_of_arrays,duration_secs=2):
	pass