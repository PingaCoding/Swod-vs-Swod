extends Node3D

@onready var animEnemy = $AnimationEnemy
@onready var animTree : AnimationTree = $AnimationTree

func _ready():
	# Connect the animation tree
	animTree.connect("animation_finished", Callable(self, "_on_animation_finished"))
	# Play default idle animation
	animEnemy.play("Battle_Idle_1")

