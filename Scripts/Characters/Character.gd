extends Node

var attacks = []
var defenses = []

var bodyParts = []

func set_body_parts(bodyPartsMain):
	# Add body parts to your variable
	for child in bodyPartsMain.get_children():
		if child is Area3D:
			bodyParts.append(child)

func get_attacks():
	return attacks
	
func get_defenses():
	return defenses
	
func set_attacks(a):
	attacks = a
	
func set_defenses(d):
	defenses = d
