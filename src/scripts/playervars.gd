extends Node

# HP management
var HP_max = 100
var HP_cur = HP_max
# MP management
var MP_max = 100
var MP_cur = MP_max

var selectedSpells= [] 
var playerSpellbook = {}

func _ready():
	# Initialize HP,MP
	#HP_cur = HP_max
	#MP_cur = MP_max
	# This will have to be parsed from a JSON file
	# the savegame file
	selectedSpells= ["fireball","heal","timewarp","meditation"]
	playerSpellbook= {
		"fireball": {
			"level": 8
			},
		"heal": {
			"level": 2
			},
		"timewarp": {
			"level": 6
			},
		"meditation": {
			"level": 5
			}
		}
#
#func set_HP_cur(new_value):
#	# change progress bar
#	HPBar.value = new_value
#	HP_cur = new_value
#	print("HP_cur",HP_cur)
#	print("players.HP_cur",playervars.HP_cur)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
#
#func set_HP_cur(HP_new_value):
#	var HP_value = HP_new_value 
#	return HP_value
#	# add condition: if HP goes to zero, death signal sent