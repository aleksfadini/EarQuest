extends Area2D

signal death

enum STATES { walking,flying, flipping, falling, rising, reorienting, dead }
var state

#export var upper_bounds = 0.9

export (NodePath) var bg_sprite
export var flying_variation = 30
export var flying_divisor = 8
export var flying_horizontal_speed = 5.0
export var fall_speed = 0.2
export var rise_speed = 0.5

var falling_velocity = 0
var rising_velocity = 0
var flying_counter = 0

#WIP
var scrolling_speed_pps = global.scrolling_speed_pps
#onready var WizardAnimation = [] 

func _ready():
#	state = STATES.flying
	state = STATES.walking
#	$AnimatedSprite.set_animation("flying")
	$AnimatedSprite.set_animation("walking")
	$AnimatedSprite.get_sprite_frames().set_animation_speed("walking",scrolling_speed_pps)
	$AnimatedSprite.play("walking")
	goto_upper_bounds()
	set_process(true)

func _process(delta):
#	if(state == STATES.flying):
#		# Transition to flipping if press up
#		if(Input.is_action_pressed("game_up")):
#			$AnimatedSprite.play("flipping")
#			state = STATES.flipping
#		flying_counter += 1
#		relative_move(Vector2(0,sin(flying_counter/flying_divisor)*flying_variation))
#		if(Input.is_action_pressed("game_left")):
#			relative_move(Vector2(-flying_horizontal_speed,0))
#		if(Input.is_action_pressed("game_right")):
#			relative_move(Vector2(flying_horizontal_speed,0))
#		var sprite_width = $AnimatedSprite.frames.get_frame("flying", $AnimatedSprite.frame).get_width()
#		sprite_width *= $AnimatedSprite.scale.x
#		global_position.x = clamp(global_position.x, 0, OS.get_window_size().x-sprite_width)
#	elif(state == STATES.flipping):
#		# Transition to falling if done flipping
#		if($AnimatedSprite.frame >= $AnimatedSprite.frames.get_frame_count("flipping")-1):
#			$AnimatedSprite.play("falling")
#			falling_velocity = 0
#			state = STATES.falling
#	elif(state == STATES.falling):
#		# Transition if trying to reorient
#		if(Input.is_action_pressed("game_up")):
#			$AnimatedSprite.play("reorienting")
#			state = STATES.reorienting
#		# Emit death if the player goes off screen
#		if(global_position.y > OS.get_window_size().y):
#			emit_signal("death")
#			state = STATES.dead
#		falling_velocity += fall_speed
#		relative_move(Vector2(0,falling_velocity))
#		if(Input.is_action_pressed("game_left")):
#			relative_move(Vector2(-flying_horizontal_speed,0))
#		if(Input.is_action_pressed("game_right")):
#			relative_move(Vector2(flying_horizontal_speed,0))
#	elif(state == STATES.reorienting):
#		# Transition to going up
#		if($AnimatedSprite.frame >= $AnimatedSprite.frames.get_frame_count("reorienting")-1):
#			state = STATES.rising
#			rising_velocity = 0
#			$AnimatedSprite.play("flying")
#	elif(state == STATES.rising):
#		# Continue going up until it's at the peak
#		if(global_position.y <= OS.get_window_size().y*upper_bounds):
#			state=STATES.flying
#		rising_velocity += rise_speed
#		relative_move(Vector2(0,-rising_velocity))
#	elif(state == STATES.dead):
#		pass
#	elif(state == STATES.walking):
#		$AnimatedSprite.get_sprite_frames().set_animation_speed("walking",scrolling_speed)
##		$AnimatedSprite.get_sprite_frames().set_animation_speed("walking",2*scrolling_speed*float(6))
#		$AnimatedSprite.play("walking")
		pass

func goto_upper_bounds():
#	var target_pos = Vector2(OS.get_window_size().x/50, upper_bounds*OS.get_window_size().y/8)
	var target_pos = Vector2(OS.get_window_size().x/50, 122)
	relative_move(target_pos-global_position)

func relative_move(inVec):
	global_position += inVec

func _on_player_death():
	print("dead")


func _on_player_body_entered( body ):
	if(body.is_in_group("mobs")):
		#WIP for now 5, depends on mob
		player_hurt(5)
		pass
		# this should just lower HP, if HP is below 0, death
#		emit_signal("death")
#		state = STATES.dead

func player_hurt(amount_of_hp):
	flash_red()
	.get_parent().get_parent().get_parent().set_HP_cur(playervars.HP_cur-amount_of_hp)
	
func flash_red():
	var tween_out = Tween.new()
	tween_out.connect("tween_completed",self,"_on_TweenOut_tween_completed")
	add_child(tween_out)
	var transition_duration = 0.6
	var transition_type = 3
#	tween_out.interpolate_property(self, "self_modulate", self.get_property("self_modulate"), Color(1,0,0,0.5), transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.interpolate_property(self, "modulate", .get("modulate"), Color(1,0,0,1), transition_duration, transition_type, Tween.EASE_OUT_IN)
	tween_out.start()

func _on_TweenOut_tween_completed(object,key):
	self.modulate = Color(1,1,1,1)
#	self.hide()
	pass
