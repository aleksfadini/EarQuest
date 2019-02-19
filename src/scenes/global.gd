extends Node
# redo this part
var scrolling_speed_pps = 6 # pixels per second
const ratio_walk_to_scroll = 8/float(60) # was 8/float(60)
var down_delta = float(scrolling_speed_pps)*ratio_walk_to_scroll# speed for bg scrolling:
var scrolling_speed = scrolling_speed_pps/ratio_walk_to_scroll*1.06 # pixels per min
var slow_down = 0
func _ready():
	# down delta
#	down_delta = float(scrolling_speed)*ratio_walk_to_scroll - slow_down
	pass