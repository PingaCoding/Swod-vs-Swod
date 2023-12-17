extends Node3D

@export_subgroup("Attack")
var attacks = []
@export var maxAttacks = 2

var animations = []

@onready var animPlayer = $AnimationPlayer
@onready var animTree : AnimationTree = $AnimationTree 
@onready var bodyPartsMain = $Player/Skeleton3D/BodyParts
@onready var fightButton = $PlayerCanvas/Button
var bodyParts = []

func _ready():
	# Add the finish animation method to AnimationTree and play idle animation
	animTree.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animTree["parameters/conditions/Battle_Idle_1"] = true
	
	# Add body parts to your variable
	for child in bodyPartsMain.get_children():
		if child is Area3D:
			bodyParts.append(child)
	
	pass

# Choose attack to round
func choose_attack(attack, add):
	# Adding attack
	if add:
		# If there's less than 2 attacks add the current one
		if len(attacks) < 2:
			if attack not in attacks:
				attacks.append(attack)
				
		# Otherwise, deactivate this choice
		else:
			for bodyPart in bodyParts:
				if bodyPart.name == attack:
					bodyPart.choose_attack(true)

	# Removing attack
	if !add:
		# If there's at least 1 attack remove the current one
		if len(attacks) > 0:
			if attack in attacks:
				attacks.erase(attack)

func start_round():
	# All attacks in round attacks
	for attack in attacks:
			# Queue attacks for animation
			match attack:
				"HeadArea":
					if !animations.has("Head_Attack_1") and !animations.has("Head_Attack_2"):
						animations.append("Head_Attack_" + randNumber(1, 2))
				"ChestArea":
					if !animations.has("Chest_Attack_1") and !animations.has("Chest_Attack_2") and !animations.has("Chest_Attack_3"):
						animations.append("Chest_Attack_" + randNumber(1, 3))
				"LegArea":
					if !animations.has("Leg_Attack_1") and !animations.has("Leg_Attack_2"):
						animations.append("Leg_Attack_" + randNumber(1, 2))

	# If there's playable animations hide extra itens and start the attacks
	if len(animations) > 0 and len(animations) <= len(attacks):
		bodyPartsMain.visible = false
		fightButton.visible = false
				
		load_attacks()
		
# Return a random number
func randNumber(min, max):
	var number = randi() % max + min
	
	return str(number)

# Start player attacks
func load_attacks():
	# Deactivate idle state
	animTree["parameters/conditions/Battle_Idle_1"] = false
	# Run first attack
	animTree["parameters/conditions/" + animations[0]] = true

# On every finished animation
func _on_animation_finished(anim):
	# Get the animation index
	var index = animations.find(anim)
	
	# Deactivate current animation
	animTree["parameters/conditions/" + animations[index]] = false

	# If there's remaining animations play it
	if index + 1 < animations.size():
		animTree["parameters/conditions/" + animations[index + 1]] = true
	
	# Otherwise end round
	else:
		animTree["parameters/conditions/Battle_Idle_1"] = true
		end_round()

# Temporary
# End round
func end_round():
	# Reset animations, body parts and fight button
	animations = []
	for bodyPart in bodyParts:
		bodyPart.choose_attack(true)
	bodyPartsMain.visible = true
	fightButton.visible = true
