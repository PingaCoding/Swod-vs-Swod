extends Button

@onready var player = get_node("/root/Level 1/Player")

func _button_pressed():
	player.start_round()
	
	pass

func _ready():
	self.connect("pressed", _button_pressed)

	pass
