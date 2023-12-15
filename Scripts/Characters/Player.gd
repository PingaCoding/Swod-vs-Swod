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
	animTree.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	for child in bodyPartsMain.get_children():
		if child is Area3D:
			bodyParts.append(child)
	
	pass

func choose_attack(attack, add):
	if add:
		if len(attacks) < 2:
			if attack not in attacks:
				attacks.append(attack)
		else:
			for bodyPart in bodyParts:
				if bodyPart.name == attack:
					bodyPart.choose_attack(true)

	if !add:
		if len(attacks) > 0:
			if attack in attacks:
				attacks.erase(attack)

func start_round():
	for attack in attacks:
			match attack:
				"HeadArea":
					if !animations.has("Head_Attack_1"):
						animations.append("Head_Attack_1")
				"ChestArea":
					if !animations.has("Chest_Attack_1"):
						animations.append("Chest_Attack_1")
						
				"LegArea":
					if !animations.has("Leg_Attack_1"):
						animations.append("Leg_Attack_1")

	if len(animations) > 0 and len(animations) <= len(attacks):
		bodyPartsMain.visible = false
		fightButton.visible = false
				
		load_attack(animations[0])	

func load_attack(attack):
	animTree["parameters/conditions/Idle_2"] = false
	animTree["parameters/conditions/" + animations[0]] = true

func _on_animation_finished(anim):
	var index = animations.find(anim)
	
	animTree["parameters/conditions/" + animations[index]] = false

	if index + 1 < animations.size():
		animTree["parameters/conditions/" + animations[index + 1]] = true
	else:
		end_round()
		animTree["parameters/conditions/Idle_2"] = true

func end_round():
	animations = []
	for bodyPart in bodyParts:
		bodyPart.choose_attack(true)
	bodyPartsMain.visible = true
	fightButton.visible = true
