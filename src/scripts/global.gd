extends Node
# redo this part
var scrolling_speed_pps = 6 # pixels per second
const ratio_walk_to_scroll = 8/float(60) # was 8/float(60)
var down_delta = float(scrolling_speed_pps)*ratio_walk_to_scroll# speed for bg scrolling:
var scrolling_speed = scrolling_speed_pps/ratio_walk_to_scroll*1.06 # pixels per min
var slow_down = 0
func _ready():
	# Eventually load all BG data on the side
	# loadBGdata()
	pass
	
func loadBGdata():
	var HILLSbgG =preload("res://src/img/EQHILLSbgG.png")
	var HILLSbgGF =preload("res://src/img/EQHILLSbgGF.png")
	var HILLSbgS1 =preload("res://src/img/EQHILLSbgS1.png")
	var HILLSbgS2 =preload("res://src/img/EQHILLSbgS2.png")
	var HILLSbgS3 =preload("res://src/img/EQHILLSbgS3.png")
	var HILLSbgS4 =preload("res://src/img/EQHILLSbgS4.png")
	pass