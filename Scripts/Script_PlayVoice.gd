extends Node

@onready var voices = owner.find_child("Voices")
@onready var sounds = owner.find_child("Sounds")

func PlayVoice(string):
	#var getname = string + str(int(randf_range(0, voices.get_child_count())))
	var getname = string + str(int(randf_range(0, 1)))
	voices.find_child(getname).play()

func PlaySound(string):
	sounds.find_child(string).play()
