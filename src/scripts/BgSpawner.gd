extends Node2D

export (PackedScene) var debris_node
#export (PackedScene) var debris_line
#export var mob_level = 1
var debris_scale
func _ready():
	randomize()
	debris_scale = (randi()%10)/float(10)
#	$BgTimer.wait_time = rand_range(spawn_time_range.x, spawn_time_range.y)
	$BgTimer.wait_time = 1
	$BgTimer.start()


# WIP insert a function that when the timer is out produces either
# a mob or a trasure chest
func _on_BgTimer_timeout():
	var current_debris = debris_node.instance()
#	var current_debris_line = debris_line.instance()
#	current_debris.global_position = Vector2(0, 0)
	current_debris.set_rock_numb(randi()%current_debris.max_rock_numb)
#	current_debris.angular_velocity = rand_range(angular_velocity_range.x, angular_velocity_range.y)
	#	scale down mobs
	current_debris.debris_scale = debris_scale
	add_child(current_debris)
	var target_velocity = -global.scrolling_speed
#	if(current_debris.global_position.x > OS.get_window_size().x/2):
#		target_velocity = rand_range(linear_velocity_range.x, linear_velocity_range.y)*-1

#	else:
#		target_velocity = rand_range(linear_velocity_range.x, linear_velocity_range.y)
	current_debris.set_linear_velocity(Vector2(target_velocity,0))
#	add_child(current_debris_line)
#	current_debris_line.start_following(current_debris)
#	current_debris_line.set_width(warning_line_width)
#	$BgTimer.wait_time = rand_range(spawn_time_range.x, spawn_time_range.y)
#	$BgTimer.start()

func stop_spawning():
	$BgTimer.stop()

func start_spawning():
	$BgTimer.start()