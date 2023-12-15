extends Node3D

@onready var animEnemy = $AnimationEnemy

func _ready():
	animEnemy.play("Battle_Idle_1")
