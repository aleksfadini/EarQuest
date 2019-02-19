tool
extends Sprite

#export var original_down_delta = 10 # was 4
#var scrolling_speed = global.scrolling_speed
#var ratio_walk_to_scroll = 8/float(60)
#var orig_down_delta = global.down_delta

onready var bgG =preload("res://src/img/EQHILLSbgG.png")
onready var bgGF =preload("res://src/img/EQHILLSbgGF.png")
onready var bgS1 =preload("res://src/img/EQHILLSbgS1.png")
onready var bgS2 =preload("res://src/img/EQHILLSbgS2.png")
onready var bgS3 =preload("res://src/img/EQHILLSbgS3.png")
onready var bgS4 =preload("res://src/img/EQHILLSbgS4.png")
var down_delta = global.down_delta
export var slow_down = 0
func _ready():
	var node_name = self.get_name()
	if node_name == "bg1":
		self.texture=bgG
	if node_name == "bg5":
		self.texture=bgS4
	if node_name == "bg4":
		self.texture=bgS3
	if node_name == "bg3":
		self.texture=bgS2
	if node_name == "bg2":
		self.texture=bgS1
	if node_name == "bg0":
		self.texture=bgGF
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