extends Node3D

@onready var Joint = self
@onready var Player = get_parent().get_parent().find_child("Player")

@onready var Midpoint = $Midpoint
@onready var Lowpoint = $Lowpoint
@onready var promptArray = [
	$OpenPromptTransform,
	$PeekPromptTransform,
	$KickPromptTransform
]

@onready var IAnim = $Interact_Animation

var finger : Vector3

var defaultRotdeg
var allowInteraction = 0

# ANIMATIONS
func AnimateOpenDoor(num):
	var vectorOpen : Vector3
	var localspeed = 1
	
	# if peeking
	if num == 1:
		vectorOpen = Vector3(0, defaultRotdeg.y + 20, 0)
	
	else:
		vectorOpen = Vector3(0, defaultRotdeg.y + 90, 0)
		
		# if kicking
		if num == 2:
			localspeed = .25
	
	vectorOpen = clamp(vectorOpen, Vector3(0,-180,0), Vector3(0,180,0))
	var thetween = create_tween()
	if Joint.rotation_degrees.y == defaultRotdeg.y+90:
		thetween.tween_property(Joint, "rotation_degrees", defaultRotdeg, localspeed)
	else:
		thetween.tween_property(Joint, "rotation_degrees", vectorOpen, localspeed)

func AllVisible():
	promptArray[0].Visible()
	promptArray[1].Visible()
	promptArray[2].Visible()

func AllInvisible():
	promptArray[0].Invisible()
	promptArray[1].Invisible()
	promptArray[2].Invisible()


# CODES
func Interact():
	if allowInteraction == 1:
		if finger.y < Lowpoint.global_position.y:
			AnimateOpenDoor(2)
		elif finger.y < Midpoint.global_position.y:
			AnimateOpenDoor(1)
		else:
			AnimateOpenDoor(0)

func _ready():
	defaultRotdeg = Joint.rotation_degrees
	AllInvisible()

func _process(delta):
	if allowInteraction == 1:
		if finger.y < Lowpoint.global_position.y:
			promptArray[2].SizeLarge()
			promptArray[0].SizeNormal()
			promptArray[1].SizeNormal()
		elif finger.y < Midpoint.global_position.y:
			promptArray[1].SizeLarge()
			promptArray[0].SizeNormal()
			promptArray[2].SizeNormal()
		else:
			promptArray[0].SizeLarge()
			promptArray[1].SizeNormal()
			promptArray[2].SizeNormal()

func _on_area_3d_body_entered(body):
	allowInteraction = 1
	AllVisible()

func _on_area_3d_body_exited(body):
	allowInteraction = 0
	AllInvisible()
