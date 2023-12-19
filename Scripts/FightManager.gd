extends Node3D

@onready var player = get_node("/root/Level 1/Player")
@onready var enemy = get_node("/root/Level 1/Enemy")

var current_round = 1

var playerAttacks = []
var playerDefenses = []
var enemyAttacks = []
var enemyDefenses = []

signal attack_anim_finished()
signal defense_anim_finished()

var attackCharacter = ""
var defenseCharacter = ""

# Characters attributes
@onready var characters = {
	"Player": {
		"attacks": playerAttacks,
		"defenses": playerDefenses,
		"character": player,
		"damage": 15
	}, 
	"Enemy": {
		"attacks": enemyAttacks,
		"defenses": enemyDefenses,
		"character": enemy,
		"damage": 15
	}
}

# Start round
func start_round():
	print("Player Attacks: ", player.get_attacks())
	print("Player Defenses: ", player.get_defenses())
	print("Enemy Attacks: ", enemy.get_attacks())
	print("Enemy Defenses: ", enemy.get_defenses())
	print("A New Round Started")
	print("Current round: ", current_round)
	
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
	attack_defense(current_round)

# Emit signals for finished animations
func anim_finished_signal(user):
	if user == attackCharacter:
		emit_signal("attack_anim_finished")
	else:
		emit_signal("defense_anim_finished")
	
# Manage attacks and defenses
func attack_defense(current_round):
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
		
		print(characters[attackCharacter])
		# Activate attack by attack
		for attack in characters[attackCharacter]["attacks"]:
			characters[attackCharacter]["character"].attack(attack)
			#characters[defenseCharacter]["character"].take_damage(characters[attackCharacter]["damage"])

			# Check if attack has a defense for it and if yes activate
			for defense in characters[defenseCharacter]["defenses"]:
				if attack.split("_")[0] == defense.split("_")[0]:
					characters[defenseCharacter]["character"].defense(defense)
					# Wait defense animation to end
					await defense_anim_finished
			
			# Wait attack animation to end
			await attack_anim_finished
		
		# Start next round
		attack_defense(current_round + 1)

# End round
func end_round():
	# Reset current round
	current_round = 1
	
	# Enable the not battle UI
	player.bodyPartsMain.visible = true
	for bodyPart in player.bodyParts:
		bodyPart.choose_attack(true)
	player.fightButton.visible = true
	enemy.bodyPartsMain.visible = true
	
	# Reset fight attributtes
	player.set_attacks([])
	player.set_defenses([])
	enemy.set_attacks([])
	enemy.set_defenses([])
	characters["Player"]["attacks"] = []
	characters["Player"]["attacks"] = []
	characters["Enemy"]["attacks"] = []
	characters["Enemy"]["attacks"] = []
