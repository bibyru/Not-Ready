extends CharacterBody3D

@export var speed = 20
@export var accel = 20
@export var friction = 30

@export var mousesens = 0.002

@onready var At = $AnimationTree
@onready var Cam = $Head/Camera3D
@onready var Hand = $Head/Camera3D/Hand
@onready var AlertArea = $AlertArea

@onready var AlertAreaTimer = $Timers/AlertAreaTimer
@onready var ReloadTimer = $Timers/MagReloadCheckTimer

@onready var SGun = $Scripts/Script_Gun
@onready var SUI = $Scripts/Script_UI
@onready var SFl = $Scripts/Script_Freelean
@onready var SPlayVoice = $Scripts/Script_PlayVoice

const grav = 100

var health = 100
var readyPosition = 0
var preferredReadyPosition = 1

const handPositionDefault = [Vector3(0.175,-0.153,-0.465) , Vector3(0,-0.5,0)]
const handPositionsArray = [
	[Vector3(0,0,0) , Vector3(0,0,0)], 							# NORMAL
	[Vector3(-.175,.035,.05) , Vector3(0,0.5,0)], 				# AIMING
	[Vector3(-.175,-.153,.05) , Vector3(0,0.5,0)], 				# LOWER
	[Vector3(-.3,0,0) , Vector3(0,0,0)], 						# HIGH READY
]

func OneShotAnimationPick(num):
	# 0 = reload normal
	# 1 = reload check
	# 2 = reload empty
	# 3 = reload new mag
	# 4 = safety
	# 5 = shoot
	At.set("parameters/Reload/blend_position", num)
	At.set("parameters/ReloadOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func HandPositioning(thevector):
	var thetween = create_tween()
	thetween.tween_property(Hand, "position", handPositionDefault[0] +thevector[0], .15).set_trans(Tween.TRANS_LINEAR)
	thetween.tween_property(Hand, "rotation_degrees", handPositionDefault[1] +thevector[1], .15).set_trans(Tween.TRANS_LINEAR)


func AlertEnemy():
	AlertArea.monitoring = true
	if AlertAreaTimer.is_stopped():
		AlertAreaTimer.start()

func _on_alert_area_timer_timeout():
	AlertArea.monitoring = false

func Hurt(dmg):
	health -= dmg
	if health <= 0:
		Manager.ReloadScene()


func _input(event):
	
	# CAMERA
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mousesens)
		Cam.rotate_x(-event.relative.y * mousesens)
		Cam.rotation_degrees.x = clampf(Cam.rotation_degrees.x, -85, 90)
	
	# INPUTS
	if event.is_action_pressed("Esc"):
		Manager.ReloadScene()
	
	if event.is_action_pressed("Interact"):
		pass
	
	if event.is_action_pressed("Yell"):
		if At.get("parameters/ReloadOneShot/active") == false:
			OneShotAnimationPick(.6)
			SPlayVoice.PlayVoice("Yell")
			AlertEnemy()
	
	if event.is_action_pressed("Ready"):
		if At.get("parameters/ReloadOneShot/active") == false:
			if readyPosition == 0:
				readyPosition = preferredReadyPosition
			else:
				readyPosition = 0
	
	if event.is_action_pressed("Attachment"):
		SGun.Flashing()
	
	if event.is_action_pressed("Reload"):
		readyPosition = 0
		
		if At.get("parameters/ReloadOneShot/active") == false:
			SGun.Reload()
	
	if event.is_action_pressed("Shoot"):
		AlertEnemy()
		if At.get("parameters/Reload/blend_position") == .2:
			SGun.JustPressedShoot()
		elif At.get("parameters/ReloadOneShot/active") == false:
			SGun.JustPressedShoot()
	
	if event.is_action_pressed("Safety"):
		SGun.SafetyChange()


func _ready():
	At.active = true
	
	AlertArea.get_child(0).shape.size = Vector3(30,2,30)
	AlertArea.monitoring = false
	
	Cam.fov = 70

func _physics_process(delta):
	
	# BASIC ANIMATIONS
	# movement or not
	var value : float
	value = clampf( velocity.length() ,1,2)
	if Input.is_action_pressed("Aim"):
		value = value -.8
	At.set("parameters/Movement/blend_position", value)
	
	# ready or aiming
	var readyBlend = At.get("parameters/Pose/blend_position")
	At.set("parameters/Pose/blend_position", lerp(readyBlend, float(readyPosition), 0.1))
	
	if Input.is_action_pressed("Aim"):
		readyPosition = 0
		
		if At.get("parameters/ReloadOneShot/active") == true:
			if At.get("parameters/Reload/blend_position") == .4:
				HandPositioning(handPositionsArray[2])
			else:
				pass
		else:
			HandPositioning(handPositionsArray[1])
	else:
		if preferredReadyPosition == 1 && readyPosition == 1:
			HandPositioning(handPositionsArray[3])
		else:
			HandPositioning(handPositionsArray[0])
	
	
	# MOVEMENT
	var localSpeed = speed
	if readyPosition != 0:
		localSpeed = speed +1
	if Input.is_action_pressed("Run"):
		localSpeed = speed -1.5
	
	var input = Input.get_vector("Left", "Right", "Forward", "Backward")
	var dir = transform.basis * Vector3(input.x, 0, input.y)
	if dir != Vector3.ZERO:
		velocity = lerp(velocity, dir * localSpeed, accel * delta)
	else:
		velocity = lerp(velocity, Vector3.ZERO, friction * delta)
	
	if !is_on_floor():
		velocity.y -= grav * delta
	
	if Input.is_action_pressed("Freelean"):
		SFl.Freelean()
		velocity = Vector3.ZERO
	else:
		SFl.HeadBack()
		move_and_slide()
