tool
extends Sprite

#export var original_down_delta = 10 # was 4
#var scrolling_speed = global.scrolling_speed
#var ratio_walk_to_scroll = 8/float(60)
#var orig_down_delta = global.down_delta
var down_delta = global.down_delta
export var slow_down = 0
func _ready():
	# slow down far bg
#	down_delta = 10*slow_down+global.down_delta
#	down_delta = float(original_down_delta)
#	set_region_rect(Rect2(Vector2(), OS.get_window_size()))
#	set_region_rect(Rect2(Vector2(), Vector2(300,250)))
	if(!Engine.editor_hint):
		set_process(true)
	else:
		set_process(false)
#	on_window_resize()
#	get_node("/root/").connect("size_changed", self, "on_window_resize")
func _physics_process(delta):
#	down_delta = float(scrolling_speed)*ratio_walk_to_scroll - slow_down
#	down_delta = float(original_down_delta)
	set_region_rect(Rect2(Vector2(region_rect.position.x+down_delta-slow_down,0),Vector2(300,220)))
#	set_region_rect(Rect2(Vector2(region_rect.position.x+down_delta,0),OS.get_window_size()))

#func on_window_resize():
#	if(Engine.editor_hint):
#		set_region_rect(Rect2(Vector2(), Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))))
#	else:
#		set_region_rect(Rect2(Vector2(), OS.get_window_size()))

func stop_scrolling():
	set_process(false)

func start_scrolling():
	set_process(true)