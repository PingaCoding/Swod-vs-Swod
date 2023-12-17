extends Area3D

@onready var meshMaterial = StandardMaterial3D.new()
@onready var mesh = $MeshInstance3D
@onready var camera = get_node("/root/Level 1/Camera3D")
@onready var player = get_node("/root/Level 1/Player")

var clicked = 0

# Click event
func _input_event(camera, event, click_position, click_normal, shape_idx):
	# Mouse click
	if event is InputEventMouseButton:
		# Prevents double value (for some reason it double clicks)
		if clicked == 0:
			# Choose attack when clicking left button
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				clicked += 1
				choose_attack(mesh.scale == Vector3(1.2, 1.2, 1.2))
		else:
			clicked = 0

func _ready():
	# Connect click event
	self.connect("input_event", _input_event)
	
	pass

# Manage choosing an attack
func choose_attack(active):
	# Remove attack from the list and de-emphasize the icon
	if active:
		mesh.scale = Vector3(1, 1, 1)
		player.choose_attack(self.name, false)
	# Add attack to the list and emphasize the icon
	else:
		mesh.scale = Vector3(1.2, 1.2, 1.2)
		player.choose_attack(self.name, true)
