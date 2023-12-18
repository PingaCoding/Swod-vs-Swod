extends Node3D

@onready var player = get_node("/root/Level 1/Player")
@onready var enemy = get_node("/root/Level 1/Enemy")

var playerAttacks = []
var playerDefenses = []
var enemyAttacks = []
var enemyDefenses = []

var attackCharacter = ""
var defenseCharacter = ""

signal attack_anim_finished()
signal defense_anim_finished()

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
	attack_defense(attackCharacter, defenseCharacter)

# Emit signals for finished animations
func anim_finished_signal(user):
	if user == attackCharacter:
		emit_signal("attack_anim_finished")
	else:
		emit_signal("defense_anim_finished")
	
# Manage attacks and defenses
func attack_defense(attack_character, defense_character):
	# Activate attack by attack
	print(characters[attack_character]["attacks"])
	for attack in characters[attack_character]["attacks"]:
		print(attack)
		characters[attack_character]["character"].attack(attack)
		#characters[defense_character]["character"].take_damage(characters[attack_character]["damage"])

		# Check if attack has a defense for it and if yes activate
		for defense in characters[defense_character]["defenses"]:
			if attack.split("_")[0] == defense.split("_")[0]:
				characters[defense_character]["character"].defense(defense)
				# Wait defense animation to end
				await defense_anim_finished
		
		# Wait attack animation to end
		await attack_anim_finished
		print("finished")
	
	# Return to idle animation
	characters[attack_character]["character"].animPlayer.play("Battle_Idle_1")
	characters[defense_character]["character"].animPlayer.play("Battle_Idle_1")
	

# End round
func end_round():
	print("End round")
