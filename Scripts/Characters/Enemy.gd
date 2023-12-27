extends "res://Scripts/Characters/Character.gd"

signal anim_finished

@onready var lifeBar = get_node("/root/Level 1/Canvas/EnemyLifeContainer/LifeBar")

var bodyPartsMain

func _ready():
	# Define anim player
	animPlayer = $AnimationPlayer
	
	# Add the finish animation method to AnimationTree and play idle animation
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("Battle_Idle_1")
	
	# Define body parts objects
	set_body_parts(bodyPartsMain)
	
	# Define animations blend time
	set_animations_blend_time()
	
	pass

# Automatically choose attacks and defenses to round
func choose_attacks_defenses():
	# Define the animations
	#var animations = ["Head_Attack_1", "Head_Attack_2", "Chest_Attack_1", "Chest_Attack_2", "Chest_Attack_3", "Leg_Attack_1", "Leg_Attack_2", "Head_Defense_1", "Chest_Defense_1", "Leg_Defense_1"]
	var animations = ["Head_Attack_2", "Chest_Attack_1", "Leg_Attack_1", "Head_Defense_1", "Chest_Defense_1", "Leg_Defense_1"]
	
	# Filter the animations
	var attacks_animations = animations.filter(func(animation): return animation.split("_")[1] == "Attack")
	var defenses_animations = animations.filter(func(animation): return animation.split("_")[1] == "Defense")
		
	# Append attributes to the arrays
	attacks = select_random_attacks_defenses(attacks_animations, "attacks")
	defenses  = select_random_attacks_defenses(defenses_animations, "defenses")

# Randomly selects attacks and defenses
func select_random_attacks_defenses(array, type):
	var selected = []
	var items = 0
	var max
	if type == "attacks":
		max = maxAttacks
	else:
		max = maxDefenses
	
	# For every array item get it index
	for i in range(array.size()):
		var index = randi() % array.size()
		#If an item has already been chosen and the maximum limit has not been reached
		if selected:
			if items < max:
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


