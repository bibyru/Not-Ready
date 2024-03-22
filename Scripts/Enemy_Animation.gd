extends Node

@onready var At = $"../../AnimationTree"

func _ready():
	At.active = true
	At.set("parameters/OS_FullBody/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func AnimArms(num):
	# 0 = shoot
	# 1 = scared
	
	At.set("parameters/Blend_Arms/blend_position", num)
	At.set("parameters/OS_Arms/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func AnimFullBody(num, mode = 0):
	# 0 = surrend, reverse surrend, restrained
	# 1 = die
	
	At.set("parameters/Blend_FullBody/blend_position", num)
	
	if num == 0:
		if mode == 1:
			At.get("parameters/Blend_FullBody/0/playback").travel("GetUp")
		elif mode == 2:
			At.get("parameters/Blend_FullBody/0/playback").travel("Restrained")
		
		if At.get("parameters/OS_FullBody/active") == false:
			At.set("parameters/OS_FullBody/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
	elif num == .1:
		if At.get("parameters/OS_FullBody/active") == true && At.get("parameters/Blend_FullBody/blend_position") == 0:
			At.get("parameters/Blend_FullBody/0/playback").travel("End")
		At.set("parameters/OS_FullBody/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
	else:
		At.set("parameters/OS_FullBody/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
