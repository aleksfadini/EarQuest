extends Control

signal spell_activated

enum BTN_STATE { inactive, active }
export onready var state = BTN_STATE.inactive setget set_state,get_state  # use setget here!!

export var spell_name = "fireball"
# this will be the nature of interval/chord
export onready var label = "M" setget set_label,get_label

onready var BtnDisabled =preload("res://src/img/EQ-rune/frame1.png")
onready var BtnEnabled =preload("res://src/img/EQ-rune/frame2.png")

func _ready():
	# add to group runes
	self.add_to_group("spell")
#	state = BTN_STATE.inactive
#	self.self_modulate.a = 0.7

#	set_state(state)
	# connect to a signal of button being changed
#	update_button()
#	pass

func set_label(new_label):
	label = new_label
	# update the text in each pentacle slice
#	print("get_child(1):", self)
#	print("get_child(1):", get_child(1))
	get_child(1).text = new_label
	# split label in 2 lines?
	# WIP
#	get_child(1).text = new_label

func get_label():
	pass

# hides labels when inactive
# potentially change the texture when disabled too,
# WIP
func set_state(new_state):
	
	state = new_state
	if new_state == BTN_STATE.inactive:
#		self.self_modulate.a = 0.7
#		get_child(1).self_modulate.a = 0.5
		# change button texture
		get_child(0).texture_normal = BtnDisabled
		# inactive, hide label
		get_child(1).hide()
		# disable clicking
		get_child(0).mouse_filter=2
		# click pass thrgouh when disabled
#		self.modulate.a = 0.7
#	if state == BTN_STATE.pressed:
#		self.self_modulate.a = 0.4
#		get_child(1).modulate.a = 0.4
##		get_parent().self_modulate.a = 0.9
	if new_state == BTN_STATE.active:
		# change button texture
		get_child(0).texture_normal = BtnEnabled
		# active, show label
		get_child(1).show()
		# enable clicking
		get_child(0).mouse_filter=1
#		self.self_modulate.a = 0.6
#		get_child(1).modulate.a = 0.5
	pass

func get_state():
	pass

# this function takes the press button from the BTN child and passes
# to the signal "activated"
func _on_Btn_pressed():
	emit_signal("spell_activated",spell_name)
	pass # replace with function body
