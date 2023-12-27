extends "res://Scripts/Characters/Enemy.gd"

@onready var enemy = get_node("/root/Level 1/Enemy")
@onready var bodyPartsMainE = $Skeleton3D/BodyParts

func _ready():
	enemy.bodyPartsMain = bodyPartsMainE
	
	enemy.maxAttacks = 2
	enemy.maxDefenses = 1
	
	enemy.set_attacks(attacks)
	enemy.set_defenses(defenses)
