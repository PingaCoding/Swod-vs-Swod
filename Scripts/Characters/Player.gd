extends "res://Scripts/Characters/Character.gd"

signal anim_finished

var maxAttacks = 2
var attacks_areas = []

@onready var animPlayer = $AnimationPlayer
@onready var fightButton = $PlayerCanvas/Button
@onready var bodyPartsMain = $Player/Skeleton3D/BodyParts
@onready var fightManager = get_node("/root/Level 1/FightManager")

func _ready():
	# Add the finish animation method to AnimationTree and play idle animation
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("Battle_Idle_1")
	
	set_body_parts(bodyPartsMain)
	
	pass

# Choose attack to round
func choose_attack(attack, add):
	# Adding attack
	if add:
		# If there's less than 2 attacks add the current one
		if len(attacks_areas) < maxAttacks:
			if attack not in attacks_areas:
				attacks_areas.append(attack)
				
		# Otherwise, deactivate this choice
		else:
			for bodyPart in bodyParts:
				if bodyPart.name == attack:
					bodyPart.choose_attack(true)

	# Removing attack
	if !add:
		# If there's at least 1 attack remove the current one
		if len(attacks_areas) > 0:
			if attack in attacks_areas:
				attacks_areas.erase(attack)

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
