extends RigidBody2D

var rock_numb = 0
export var max_rock_numb = 5
export var mob_scale = 1

func _ready():
	#set textures
	set_rock_numb(rock_numb)
	# scale down mobs
	get_child(0).scale=Vector2(mob_scale,mob_scale)
	get_child(1).scale=Vector2(mob_scale,mob_scale)

func set_rock_numb(new_numb):
	rock_numb = new_numb
	$sprite.texture = load("res://src/scenes/game/debris/" + str(rock_numb) + ".png")

func _on_VisibilityNotifier2D_screen_exited():
	#print("Destroying...")
	queue_free()
