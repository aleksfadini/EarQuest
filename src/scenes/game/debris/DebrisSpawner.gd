extends Node2D

export (PackedScene) var debris_node
export (PackedScene) var debris_line
export var spawn_time_range = Vector2(0.2,0.3)
export var angular_velocity_range = Vector2(-40,40)
export var linear_velocity_range = Vector2(50,100)
export var warning_line_width = 5

func _ready():
	randomize()
	$DebrisTimer.wait_time = rand_range(spawn_time_range.x, spawn_time_range.y)
	$DebrisTimer.start()

func _on_DebrisTimer_timeout():
	var current_debris = debris_node.instance()
	var current_debris_line = debris_line.instance()
	### This is the position: it has been changed to make rocks appear in the ground.
	## Original Position:
#	current_debris.global_position = Vector2(rand_range(0,OS.get_window_size().x), -50)
	## Rocks-in-the-ground Position:
	#### WIP!! Not working
#	current_debris.global_position = Vector2(rand_range(0,OS.get_window_size().x), rand_range(-50,-40))
	current_debris.global_position = Vector2(rand_range(0,OS.get_window_size().x), rand_range(-50,-40))
	current_debris.set_rock_numb(randi()%current_debris.max_rock_numb)
	current_debris.angular_velocity = rand_range(angular_velocity_range.x, angular_velocity_range.y)
	add_child(current_debris)
	var target_velocity
	if(current_debris.global_position.x > OS.get_window_size().x/2):
		target_velocity = rand_range(linear_velocity_range.x, linear_velocity_range.y)*-1
		
	else:
		target_velocity = rand_range(linear_velocity_range.x, linear_velocity_range.y)
	current_debris.set_linear_velocity(Vector2(target_velocity,0))
#	add_child(current_debris_line)
#	current_debris_line.start_following(current_debris)
#	current_debris_line.set_width(warning_line_width)
	$DebrisTimer.wait_time = rand_range(spawn_time_range.x, spawn_time_range.y)
	$DebrisTimer.start()

func stop_spawning():
	$DebrisTimer.stop()

func start_spawning():
	$DebrisTimer.start()