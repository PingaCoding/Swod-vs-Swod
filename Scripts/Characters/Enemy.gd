extends "res://Scripts/Characters/Character.gd"

signal anim_finished

var maxAttacksDefenses = 2

@onready var animPlayer = $AnimationPlayer
@onready var fightManager = get_node("/root/Level 1/FightManager")
var bodyPartsMain

func _ready():
	# Add the finish animation method to AnimationTree and play idle animation
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("Battle_Idle_1")
	set_body_parts(bodyPartsMain)
	choose_attacks_defenses()
	
	pass

# Automatically choose attacks and defenses to round
func choose_attacks_defenses():
	# Define the animations
	var animations = ["Head_Attack_1", "Head_Attack_2", "Chest_Attack_1", "Chest_Attack_2", "Chest_Attack_3", "Leg_Attack_1", "Leg_Attack_2", "Head_Defense_1", "Chest_Defense_1", "Leg_Defense_1"]
	
	# Filter the animations
	var attacks_animations = animations.filter(func(animation): return animation.split("_")[1] == "Attack")
	var defenses_animations = animations.filter(func(animation): return animation.split("_")[1] == "Defense")
		
	# Append attributes to the arrays
	attacks = select_random_attacks_defenses(attacks_animations)
	defenses  = select_random_attacks_defenses(defenses_animations)

# Randomly selects attacks and defenses
func select_random_attacks_defenses(array):
	var selected = []
	var items = 0
	
	# For every array item get it index
	for i in range(array.size()):
		var index = randi() % array.size()
		#If an item has already been chosen and the maximum limit has not been reached
		if selected:
			if items < maxAttacksDefenses:
				#Check if body area has already been chosen, if not append item to array.
				if array[index].split("_")[0] not in selected[0].split("_")[0]:
					selected.append(array[index])
					array.remove_at(index)
					items+=1
		# Otherwise append item to array
		else:
			selected.append(array[index])
			array.remove_at(index)
			items+=1
	return selected
		
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
	animPlayer.play("Battle_Idle_1")
	emit_signal("anim_finished", "Enemy")

