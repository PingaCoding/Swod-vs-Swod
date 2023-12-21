extends "res://Scripts/Characters/Character.gd"

signal anim_finished

var attacks_areas = []
var defenses_areas = []

@onready var animPlayer = $AnimationPlayer
@onready var fightButton = $PlayerCanvas/Button
@onready var bodyPartsMain = $Player/Skeleton3D/BodyParts
@onready var fightManager = get_node("/root/Level 1/FightManager")

@onready var enemy = get_node("/root/Level 1/Enemy")

func _ready():
	# Add the finish animation method to AnimationTree and play idle animation
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("Battle_Idle_1")
	
	# Define body parts objects
	set_body_parts(bodyPartsMain)
	
	# Define max attacks and defenses
	maxAttacks = 2
	maxDefenses = 1
	
	pass

# Choose attack to round
func choose_attack_defense(type, option, add):
	var currentBodyParts
	var areas
	var max
	
	if(type == "attack"):
		currentBodyParts = enemy.bodyParts
		areas = attacks_areas
		max = maxAttacks
	else:
		currentBodyParts = bodyParts
		areas = defenses_areas
		max = maxDefenses
	
	# Adding attack/defense
	if add:
		# If there's less than max attacks/defenses add the current one
		if len(areas) < max:
			if option not in areas:
				areas.append(option)
				
		# Otherwise, deactivate this choice
		else:
			for bodyPart in currentBodyParts:
				if bodyPart.name == option:
					bodyPart.choose_attack_defense(true)

	# Removing attack
	if !add:
		# If there's at least 1 attack/defense remove the current one
		if len(areas) > 0:
			if option in areas:
				areas.erase(option)

func start_round():
	# All attacks in round attacks
	for attack in attacks_areas:
			# Queue attacks for animation
			match attack:
				"HeadArea":
					if !attacks.has("Head_Attack_1") and !attacks.has("Head_Attack_2"):
						attacks.append("Head_Attack_" + randNumber(1, 2))
				"ChestArea":
					if !attacks.has("Chest_Attack_1") and !attacks.has("Chest_Attack_2") and !attacks.has("Chest_Attack_3"):
						attacks.append("Chest_Attack_" + randNumber(1, 3))
				"LegArea":
					if !attacks.has("Leg_Attack_1") and !attacks.has("Leg_Attack_2"):
						attacks.append("Leg_Attack_" + randNumber(1, 2))
						
	# All defenses in round defenses
	for defense in defenses_areas:
			# Queue defenses for animation
			match defense:
				"HeadArea":
					if !defenses.has("Head_Defense_1"):
						defenses.append("Head_Defense_" + randNumber(1, 1))
				"ChestArea":
					if !defenses.has("Chest_Defense_1"):
						defenses.append("Chest_Defense_" + randNumber(1, 1))
				"LegArea":
					if !defenses.has("Leg_Defense_1"):
						defenses.append("Leg_Defense_" + randNumber(1, 1))
	
	# If there's playable attack_animations start round
	if len(attacks) > 0 and len(attacks) <= len(attacks_areas):
		fightManager.start_round()
		
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
	emit_signal("anim_finished", "Player")
