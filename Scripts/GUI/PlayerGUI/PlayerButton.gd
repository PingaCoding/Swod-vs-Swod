extends Button

@onready var player = get_node("/root/Level 1/Player")

# Pressed button
func _button_pressed():
	# Start round
	player.start_round()
	
	pass

func _ready():
	# Add button pressed function to current button
	self.connect("pressed", _button_pressed)

	pass
