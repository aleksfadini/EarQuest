extends RigidBody2D

var rock_numb = 0
export var max_rock_numb = 5
# added to scale debris
export var debris_scale = 1

func _ready():
	set_rock_numb(rock_numb)

func set_rock_numb(new_numb):
	rock_numb = new_numb
	$sprite.texture = load("res://src/scenes/game/debris/" + str(rock_numb) + ".png")
#	self.scale = rand_range(3,10)
	# scale down debris
	get_child(0).scale=Vector2(debris_scale,debris_scale)
	get_child(1).scale=Vector2(debris_scale,debris_scale)
	
func _on_VisibilityNotifier2D_screen_exited():
	#print("Destroying...")
	queue_free()
