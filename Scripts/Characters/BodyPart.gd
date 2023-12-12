extends Area3D

@onready var meshMaterial = StandardMaterial3D.new()
@onready var mesh = $MeshInstance3D
@onready var camera = get_node("/root/Level 1/Camera3D")
@onready var player = get_node("/root/Level 1/Player")

var clicked = 0
	
func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if clicked == 0:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				clicked += 1
				choose_attack(mesh.scale == Vector3(20, 20, 20))
		else:
			clicked = 0
	

func _ready():
	self.connect("input_event", _input_event)
	
	pass

func choose_attack(active):
	if active:
		mesh.scale = Vector3(15, 15, 15)
		player.choose_attack(self.name, false)
	else:
		mesh.scale = Vector3(20, 20, 20)
		player.choose_attack(self.name, true)
