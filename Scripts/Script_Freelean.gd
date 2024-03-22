extends Node

@onready var Cam = $"../../Head"

var speed = .05
const headPositionDefault = Vector3(0, 0.722, -0.19)
const headPositionsArray = [
	Vector3(0,0,0),				 		# 0 Default
	Vector3(-0.671 , .7   , -.19), 		# 1 Left
	Vector3(0      , 1    , -.19), 		# 2 Up
	Vector3(0      , .025 , -.19), 		# 3 Down
]

func HeadBack():
	var thetween = create_tween()
	thetween.tween_property(Cam, "position", headPositionDefault, .15)

func Freelean():
	var hori = Input.get_axis("Left", "Right")
	var vert = Input.get_axis("Backward", "Forward")
	
	if hori == -1:		# LEFT
		Cam.position.x = move_toward(Cam.position.x, headPositionsArray[1].x, speed)
	elif hori == 1:		# RIGHT
		Cam.position.x = move_toward(Cam.position.x, headPositionsArray[1].x *-1, speed)
	
	if vert == 1: 		# UP
		Cam.position.y = move_toward(Cam.position.y, headPositionsArray[2].y, speed)
	elif vert == -1: 	# DOWN
		Cam.position.y = move_toward(Cam.position.y, headPositionsArray[3].y, speed)
