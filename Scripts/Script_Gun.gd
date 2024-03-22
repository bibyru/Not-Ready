extends Node

var bulletHole = preload("res://Prefabs/BulletHole.tscn")
var magRifle = preload("res://Prefabs/MK16_Magazine.tscn")

const maxammo = 30
var ammo = maxammo

var safetyPosition = 1
var holdingMag = false

@onready var timerFireRate = get_parent().get_parent().find_child("FireRate")
@onready var magBulletMesh = get_parent().get_parent().find_child("Mesh_Body_Mag_Bullets")

@onready var Player = $"../.."
@onready var Cam = $"../../Head"
@onready var Hand = $"../../Head/Camera3D/Hand"

@onready var ReloadTimer = $"../../Timers/MagReloadCheckTimer"
@onready var SafetyTimer = $"../../Timers/SafetyCheckTimer"
@onready var MagThrowTimer = $"../../Timers/MagThrowPowerTimer"
@onready var RecoilTimer = $"../../Timers/RecoilNormalerTimer"
@onready var Flashlight = $"../../Head/Camera3D/Hand/MK16/Armature/Skeleton3D/BoneAttachment3D/Flashlight"
@onready var Trajectory = $"../../Head/Camera3D/Hand/MK16/Armature/Skeleton3D/BoneAttachment3D/Trajectory"

@onready var SUI = $"../Script_UI"
@onready var SPV = $"../Script_PlayVoice"

# MISC
func Flashing():
	if Flashlight.light_energy != 0:
		Flashlight.light_energy = 0
	else:
		Flashlight.light_energy = 2

func SafetyChange():
	if SafetyTimer.is_stopped():
		SafetyTimer.start()

func _on_safety_check_timer_timeout():
	if !Input.is_action_pressed("Safety"):
		SPV.PlaySound("Safety")
		if safetyPosition+1 == 3:
			safetyPosition = 0
		else:
			safetyPosition += 1
		SUI.ShowSafety(safetyPosition)
	else:
		SUI.ShowSafety(safetyPosition, false)


# SHOOTING
func JustPressedShoot():
	if holdingMag == true:
		ThrowMagazine()
	else:
		if ammo > 0:
			# 0=safe, 1=semi, 2=auto
			if safetyPosition != 0:
				Shoot()
			else:
				SUI.ShowSafety(safetyPosition, false)

func Shoot():
	if timerFireRate.is_stopped():
		# Mechanics
		timerFireRate.start()
		
		ammo -= 1
		Player.OneShotAnimationPick(.5)
		SPV.PlaySound("Shoot")
		# Until i figure out how to recoil,
		# rest in piece
		#Hand.rotation_degrees.x += recoil
		#
		#if RecoilTimer.is_stopped():
			#RecoilTimer.start()
		#else:
			#RecoilTimer.stop()
			#RecoilTimer.start()
		
		# Decal
		var child = bulletHole.instantiate()
		var victim = Trajectory.get_collider()
		
		if victim != null:
			var colpoint = Trajectory.get_collision_point()
			victim.add_child(child)
			child.global_position = colpoint
			if Trajectory.get_collision_normal().z != 0:
				child.rotation_degrees.x = 90
			elif Trajectory.get_collision_normal().x != 0:
				child.rotation_degrees.z = 90
			
			# Consequences
			if victim is RigidBody3D:
				victim.find_child("Rigid_Shot").Shot(colpoint)
				if victim.is_in_group("Enemy"):
					SPV.PlaySound("Shoot_Hit")

func _on_recoil_normaler_timer_timeout():
	Hand.rotation_degrees.x = lerp(Hand.rotation_degrees.x, 0.0, 1)

func _on_fire_rate_timeout():
	if safetyPosition == 2 && Input.is_action_pressed("Shoot"):
		if ammo > 0:
			Shoot()


# MAGS
func HoldingMag():
	holdingMag = true

func CheckAmmo():
	SUI.ShowAmmo(ammo)

func Reload():
	if ReloadTimer.is_stopped():
		ReloadTimer.start()
		if ammo > 0:
			magBulletMesh.visible = true
		else:
			magBulletMesh.visible = false

func FillAmmo():
	if Hand.get_child(0).name == "MK16":
		ammo = maxammo

func ThrowMagazine():
	if MagThrowTimer.is_stopped():
		MagThrowTimer.start()

func _on_mag_throw_power_timer_timeout():
	var magChild = magRifle.instantiate()
	
	var pos = Player.find_child("MagPosition").global_position
	magChild.look_at_from_position(pos, Trajectory.get_collision_point(), Vector3.UP)
	
	if Input.is_action_pressed("Shoot"):
		magChild.speed += 20
	
	add_child(magChild)
	
	holdingMag = false
	Player.OneShotAnimationPick(.3)

func _on_mag_reload_check_timer_timeout():
	if !Input.is_action_pressed("Aim"):
		if Input.is_action_pressed("Reload"):
			Player.OneShotAnimationPick(.1)
		else:
			if ammo > 0:
				Player.OneShotAnimationPick(0)
			else:
				Player.OneShotAnimationPick(.2)
