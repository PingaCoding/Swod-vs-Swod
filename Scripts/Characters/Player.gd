extends CharacterBody3D

@export_subgroup("Attack")
var attacks = []
@export var maxAttacks = 2

var animations = []

@onready var animPlayer = $AnimationPlayer
@onready var bodyPartsMain = get_node("BodyParts")
var bodyParts = []
@onready var fightButton = $PlayerCanvas/Button

func _ready():
	animPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))
	animPlayer.play("StandingIdle")
	
	for child in bodyPartsMain.get_children():
		if child is Area3D:
			bodyParts.append(child)
	
	pass
	
func choose_attack(attack, add):
	if add:
		if len(attacks) < 2:
			if attack not in attacks:
				attacks.append(attack)
				
	if !add:
		if len(attacks) > 0:
			if attack in attacks:
				attacks.erase(attack)
				
func start_round():
	for attack in attacks:
			match attack:
				"HeadArea":
					if !animations.has("StandingMeleeAttackBackhand"):
						animations.append("StandingMeleeAttackBackhand")
				"ChestArea":
					if !animations.has("StandingMeleeAttackHorizontal"):
						animations.append("StandingMeleeAttackHorizontal")

	if len(animations) > 0 and len(animations) <= len(attacks):
		bodyPartsMain.visible = false
		fightButton.visible = false
				
		load_attack(animations[0])
	
func load_attack(attack):
	animPlayer.play(animations[0])
	
	
func _on_animation_finished(anim):
	var index = animations.find(anim)

	if index + 1 < animations.size():
		animPlayer.play(animations[index + 1])
	else:
		end_round()
		animPlayer.play("StandingIdle")

func end_round():
	animations = []
	for bodyPart in bodyParts:
		bodyPart.choose_attack(true)
	bodyPartsMain.visible = true
	fightButton.visible = true
