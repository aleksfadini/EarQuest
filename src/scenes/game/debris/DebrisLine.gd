extends ColorRect

var target_debris

func _ready():
	hide()
	rect_global_position = Vector2()

func start_following(input_debris):
	show()
	input_debris.connect("tree_exited", self, "_on_debris_exit")
	target_debris = input_debris
	set_process(true)

func set_width(new_width):
	margin_right = new_width
	margin_left = 0

func _on_debris_exit():
	queue_free()

func _process(delta):
	rect_global_position.x = target_debris.global_position.x
	if(color.a >= 0):
		color.a -= 1*delta
	else:
		queue_free()
	margin_bottom = OS.get_window_size().y