extends Node3D

signal anim_finished

var maxAttacks = 2
# Temporary
var attacks = ["Head_Attack_2", "Leg_Attack_1"]
var defenses = ["Head_Defense_1", "Leg_Defense_1"]

@onready var animPlayer = $AnimationPlayer
@onready var animPlayerList = $AnimationPlayer.get_animation_list()

@onready var fightManager = get_node("/root/Level 1/FightManager")

func _ready():
	# Add the finish animation method to AnimationTree and play idle animation
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("Battle_Idle_1")
	
	# Define animations transitions blend time
	for i in range(animPlayerList.size()):
		for j in range(animPlayerList.size()):
			if i != j:
				animPlayer.set_blend_time(animPlayerList[i], animPlayerList[j], 0.2)
	
	pass

# Choose attacks to round
func choose_attacks():
	print("")
		
# Return a random number
func randNumber(min, max):
	var number = randi() % max + min
	
	return str(number)

func attack(attack):
	animPlayer.play(attack)
	
func defense(defense):
	animPlayer.play(defense)
	
# On every finished animation
func _on_animation_finished(anim):
	emit_signal("anim_finished", "Enemy")

func get_attacks():
	return attacks
	
func get_defenses():
	return defenses

