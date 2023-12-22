extends Node

var attacks = []
var defenses = []
var maxAttacks
var maxDefenses

var blendTime = .2

var bodyParts = []

var animPlayer

# Define blend time for animations
func set_animations_blend_time():
	var animations = animPlayer.get_animation_list()
	
	# For every animation connection blend time is set
	for i in range(len(animations)):
		var anim_from = animations[i]
		for j in range(i + 1, len(animations)):
			var anim_to = animations[j]
			if anim_from != "Chest_Defense_1" and anim_to != "Chest_Defense_1":
				animPlayer.set_blend_time(anim_from, anim_to, blendTime)


func set_body_parts(bodyPartsMain):
	# Add body parts to your variable
	for child in bodyPartsMain.get_children():
		if child is Area3D:
			bodyParts.append(child)

# Return a random number
func randNumber(mi, ma):
	var number = randi() % ma + mi
	
	return str(number)

func get_attacks():
	return attacks
	
func get_defenses():
	return defenses
	
func set_attacks(a):
	attacks = a
	
func set_defenses(d):
	defenses = d
	
func attack(a):
	animPlayer.play(a)
	
func defense(d):
	# Define defense wait time
	if d == "Chest_Defense_1":
		await get_tree().create_timer(.7).timeout
	elif d == "Head_Defense_1":
		await get_tree().create_timer(.6).timeout
	else:
		await get_tree().create_timer(.5).timeout

	animPlayer.play(d)

func impact(a):
	var parts = {
		"Head": "Head_Impact_1",
		"Chest": "Chest_Impact_1",
		"Leg": "Leg_Impact_1"
	}

	var i = parts.get(a.split("_")[0], "")


	await get_tree().create_timer(.7).timeout
	animPlayer.play(i)

# On every finished animation
func _on_animation_finished(anim):
	animPlayer.play("Battle_Idle_1")
	emit_signal("anim_finished", anim)