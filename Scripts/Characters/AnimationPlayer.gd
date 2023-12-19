extends AnimationPlayer

var animPlayerList = self.get_animation_list()

func _ready():
	# Define animations transitions blend time
	for i in range(animPlayerList.size()):
		for j in range(animPlayerList.size()):
			if i != j:
				self.set_blend_time(animPlayerList[i], animPlayerList[j], 0.2)
