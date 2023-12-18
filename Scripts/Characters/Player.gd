extends Node3D

signal anim_finished

var maxAttacks = 2
var attacks = []
var attack_animations = []
var defenses = []
var defense_animations

@onready var animPlayer = $AnimationPlayer
@onready var animPlayerList = $AnimationPlayer.get_animation_list()
@onready var bodyPartsMain = $Player/Skeleton3D/BodyParts
@onready var fightButton = $PlayerCanvas/Button

@onready var fightManager = get_node("/root/Level 1/FightManager")

var bodyParts = []

func _ready():
	# Add the finish animation method to AnimationTree and play idle animation
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("Battle_Idle_1")
	
	# Define animations transitions blend time
	for i in range(animPlayerList.size()):
		for j in range(animPlayerList.size()):
			if i != j:
				animPlayer.set_blend_time(animPlayerList[i], animPlayerList[j], 0.2)
	
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
		if len(attacks) < maxAttacks:
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
					if !attack_animations.has("Head_Attack_1") and !attack_animations.has("Head_Attack_2"):
						attack_animations.append("Head_Attack_" + randNumber(1, 2))
				"ChestArea":
					if !attack_animations.has("Chest_Attack_1") and !attack_animations.has("Chest_Attack_2") and !attack_animations.has("Chest_Attack_3"):
						attack_animations.append("Chest_Attack_" + randNumber(1, 3))
				"LegArea":
					if !attack_animations.has("Leg_Attack_1") and !attack_animations.has("Leg_Attack_2"):
						attack_animations.append("Leg_Attack_" + randNumber(1, 2))

	# If there's playable attack_animations hide extra itens and start the attacks
	if len(attack_animations) > 0 and len(attack_animations) <= len(attacks):
		bodyPartsMain.visible = false
		fightButton.visible = false
		
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
	emit_signal("anim_finished", "Player")

func get_attacks():
	return attack_animations
	
func get_defenses():
	return defense_animations

