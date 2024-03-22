#Additions:
	#(AnimationPlayer) Call HoldMag
	#(AnimationPlayer) Call Reload

extends Node3D
					# HAND		# CAMERA		# HEAD		#PLAYER
@onready var SGun = get_parent().get_parent().get_parent().get_parent().find_child("Script_Gun")

func HoldingMagFromGun():
	if SGun:
		SGun.HoldingMag()

func CheckAmmo():
	if SGun:
		SGun.CheckAmmo()

func ReloadDone():
	if SGun:
		SGun.FillAmmo()
