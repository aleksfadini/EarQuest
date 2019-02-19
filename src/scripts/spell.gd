extends Control

signal spell_activated

enum BTN_STATE { inactive, active }
export onready var state = BTN_STATE.inactive setget set_state,get_state  # use setget here!!

export var spell_name = "fireball"
# this will be the nature of interval/chord
#export onready var label = "M" setget set_label,get_label

onready var CastBtnNormal =preload("res://src/img/EQCASTButtonBIGUnPressed.png")
onready var CastBtnPressed =preload("res://src/img/EQCASTButtonBIGPressed.png")
onready var CastSymbol =preload("res://src/img/EQCASTSymbol.png")
onready var MeditationSymbol =preload("res://src/img/EQspellMeditation.png")
onready var HealSymbol =preload("res://src/img/EQspellHeal.png")
onready var FireballSymbol =preload("res://src/img/EQspellFireball.png")
onready var TimewarpSymbol =preload("res://src/img/EQspellTimewarp.png")

# Define Nodes
onready var SideBtns = self.get_parent()

#onready var SideBtns = $Overlay/HBox/MidVBox/SideCont/SideBtns

func _ready():
	# add to group "spells"
	self.add_to_group("spells")
	# change background texture according to spell name 
	# (only for general casting)
	if spell_name == "cast":
		$Btn.texture_normal=CastBtnNormal
		$Btn.texture_pressed=CastBtnPressed
		$Symbol.texture= CastSymbol
		$Symbol.rect_position= Vector2(0,0)
		# change the group from spell to cast
		self.remove_from_group("spells")
		self.add_to_group("cast")
	# change icon according to spell name
	if spell_name == "heal":
		$Symbol.texture= HealSymbol
	if spell_name == "fireball":
		$Symbol.texture= FireballSymbol
	if spell_name == "timewarp":
		$Symbol.texture= TimewarpSymbol
	if spell_name == "meditation":
		$Symbol.texture= MeditationSymbol

	set_state(BTN_STATE.inactive)

	
#	self.self_modulate.a = 0.7
#	set_state(state)
	# connect to a signal of button being changed
#	update_button()
#	pass

#func set_label(new_label):
#	label = new_label
#	# update the text in each pentacle slice
##	print("get_child(1):", self)
##	print("get_child(1):", get_child(1))
#	get_child(1).text = new_label
#	# split label in 2 lines?
#	# WIP
##	get_child(1).text = new_label
#
#func get_label():
#	pass

# hides labels when inactive
# potentially change the texture when disabled too,
# WIP
func set_state(new_state):

	state = new_state
	if new_state == BTN_STATE.inactive:
#		self.self_modulate.a = 0.7
#		get_child(1).self_modulate.a = 0.5
#		# change button texture
#		get_child(0).texture_normal = BtnDisabled
#		# inactive, hide label
#		get_child(1).hide()
#		# disable clicking
#		get_child(0).mouse_filter=2
		# change symbol alhpa
		get_child(1).self_modulate.a = 0.2
		get_child(0).pressed = false
		# click pass thrgouh when disabled
#		self.modulate.a = 0.7
#	if state == BTN_STATE.pressed:
#		self.self_modulate.a = 0.4
#		get_child(1).modulate.a = 0.4
##		get_parent().self_modulate.a = 0.9
	if new_state == BTN_STATE.active:
		# change symbol alhpa
		get_child(1).self_modulate.a = 0.8
		get_child(0).pressed = true
#		# change button texture
#		get_child(0).texture_normal = BtnEnabled
#		# active, show label
#		get_child(1).show()
#		# enable clicking
#		get_child(0).mouse_filter=1
##		self.self_modulate.a = 0.6
##		get_child(1).modulate.a = 0.5
#	pass
#
func get_state():
	pass

func _on_Btn_toggled(button_pressed):

	# if regular spell, deselect all others
	# (this part could be moved inside button pressed too)
	# if the spell is NOT cast
	if spell_name != "cast":
		# deselect all other spells
		deselect_all_spells()
	if button_pressed:
		emit_signal("spell_activated",spell_name)
		set_state(BTN_STATE.active)
	if button_pressed == false:
		set_state(BTN_STATE.inactive)
	pass # replace with function body
	
	
func deselect_all_spells():
	# get all nodes in board Container
	for each in SideBtns.get_children():
		# if node is a "spells" 
		if each.is_in_group("spells") and each != self:
			# depress it
			each.get_child(0).pressed = false
			# 0 would be BTN.inactive
			each.state=0
