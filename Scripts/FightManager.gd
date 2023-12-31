extends Node3D

@onready var player = get_node("/root/Level 1/Player")
@onready var enemy = get_node("/root/Level 1/Enemy")

var current_round = 1

var played_animations = 0
signal round_animations

var playerAttacks = []
var playerDefenses = []
var enemyAttacks = []
var enemyDefenses = []

var attackCharacter = ""
var defenseCharacter = ""

# Characters attributes
@onready var characters = {
	"Player": {
		"attacks": playerAttacks,
		"defenses": playerDefenses,
		"character": player,
		"damage": 15,
		"lifeBar": player.lifeBar
	}, 
	"Enemy": {
		"attacks": enemyAttacks,
		"defenses": enemyDefenses,
		"character": enemy,
		"damage": 15,
		"lifeBar": enemy.lifeBar
	}
}

# Start round
func start_round():
	characters["Player"]["lifeBar"] = player.lifeBar
	characters["Enemy"]["lifeBar"] = enemy.lifeBar
	# Define enemy attacks and defenses
	enemy.choose_attacks_defenses()
	
	# Disable the not battle UI
	player.bodyPartsMain.visible = false
	player.fightButton.visible = false
	enemy.bodyPartsMain.visible = false

	# Randonly choose who will attack and defend
	attackCharacter = "Player" if randf() < 0.5 else "Enemy"
	defenseCharacter = "Enemy" if attackCharacter == "Player" else "Player"
	# Temporary
	attackCharacter =  "Player"
	defenseCharacter = "Enemy"
	
	# Get characters attacks and defenses list
	characters["Player"]["attacks"] = player.get_attacks()
	characters["Player"]["defenses"] = player.get_defenses()
	characters["Enemy"]["attacks"] = enemy.get_attacks()
	characters["Enemy"]["defenses"] = enemy.get_defenses()
	
	# Connect with animation finished signal
	player.anim_finished.connect(anim_finished_signal)
	enemy.anim_finished.connect(anim_finished_signal)
	
	# Start attacks and defenses
	attack_defense()

# Emit signals for finished animations
func anim_finished_signal(anim):
	if anim.split("_")[1] != "Idle":
		played_animations+=1

	if played_animations == 2:
		emit_signal("round_animations")
	
# Manage attacks and defenses
func attack_defense():
	# End rounds
	if current_round > 2:
		end_round()
		
	# Round code
	else:
		# Change sides in second round
		if current_round == 2:
			var temp = attackCharacter
			attackCharacter =  defenseCharacter
			defenseCharacter = temp
		
		# Activate attack by attack
		for attack in characters[attackCharacter]["attacks"]:
			# Character attack
			character_attack(attack)
			var noDefense = 0

			# Check if attack has a defense for it and if yes activate
			for defense in characters[defenseCharacter]["defenses"]: 
				if attack.split("_")[0] == defense.split("_")[0]:
					# Character defense
					character_defense(defense)
				else:
					noDefense+=1

			if noDefense == len(characters[defenseCharacter]["defenses"]):
				# Character impact
				character_impact(attack)

			await round_animations
			played_animations = 0

		# Start next round
		current_round += 1
		attack_defense()

# Manage character attacks
func character_attack(attack):
	# Play the attack
	characters[attackCharacter]["character"].attack(attack)

# Manage character defenses
func character_defense(defense):
	# Play the defense
	characters[defenseCharacter]["character"].defense(defense)

# Manage character impacts
func character_impact(attack):
	# Play the impact
	characters[defenseCharacter]["character"].impact(attack)

	# Wait all animations to end
	await round_animations

	# Manages damage suffered
	characters[defenseCharacter]["character"].life -= characters[attackCharacter]["damage"]
	characters[defenseCharacter]["character"].lifeUI(characters[defenseCharacter]["lifeBar"])

# End round
func end_round():
	# Reset current round
	current_round = 1
	
	# Enable the not battle UI
	player.bodyPartsMain.visible = true
	for bodyPart in player.bodyParts:
		bodyPart.choose_attack_defense(true)
	player.fightButton.visible = true
	enemy.bodyPartsMain.visible = true
	for bodyPart in enemy.bodyParts:
		bodyPart.choose_attack_defense(true)
	
	# Reset fight attributtes
	player.set_attacks([])
	player.set_defenses([])
	enemy.choose_attacks_defenses()
	characters["Player"]["attacks"] = []
	characters["Player"]["attacks"] = []
	characters["Enemy"]["attacks"] = []
	characters["Enemy"]["attacks"] = []

	if player.life <= 0 or enemy.life <= 0:
		print("cabou tudo")
