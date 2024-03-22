extends RigidBody3D

# careful with this
@onready var Player = $"../../Player"

@onready var ForgetPlayerTimer = $Timers/ForgetPlayerTimer
@onready var DisablementTimer = $Timers/DisablementTimer
@onready var LookToPlayerTimer = $Timers/LookToPlayerTimer
@onready var AllAroundYouTimer = $Timers/AllAroundYouTimer
@onready var DecideSurrenderTimer = $Timers/DecideSurrenderTimer
@onready var FireRate = $Timers/FireRate

@onready var At = $AnimationTree
@onready var Eyes = $Eyes
@onready var Trajectory = $Trajectory
@onready var NaviAgent = $NavigationAgent3D
@onready var RestrainPrompt = $Places/RestrainPrompt

@onready var RShot = $Scripts/Rigid_Shot
@onready var EAnim = $Scripts/Enemy_Animation
@onready var EInteract = $Scripts/Enemy_Interact
@onready var SPV = $Scripts/Script_PlayVoice

enum State {
	Patrol,
	Combat,
	Surrender,
	Done
}

var health = 100
var mental = 100
var mental_accel = .0025
var mental_accel_slow = .0001
var mental_to_stand = 20
var mental_to_miss = 70
var mental_chip = 15
@export var mental_friendDied = 70

var finger : Vector3

var allowLook = false
var surrendChanceMin = 0
var surrendChanceMax = 100
@export var surrenderThreshold = 50
var slowReact = .65

var hitChanceSad = -20
@export var hitChanceMin = 70
@export var hitChanceMax = 105
var dmgMin = 20
var dmgMax = 60

var shootSemiDist = 10
var shootAutoDist = 5
var fireRateSemi = .5
var fireRateAuto = .1

var currState = State.Patrol
var restrained = false
var done = false


# MISC
func _on_mag_searcher_body_entered(body):
	if body is RigidBody3D:
		Die()


# PLAYER
func _on_eyes_body_entered(body):
	if body.name == "Player":
		allowLook = true

func _on_eyes_body_exited(body):
	if body.name == "Player":
		allowLook = false
		if ForgetPlayerTimer.is_stopped():
			ForgetPlayerTimer.start()

func _on_forget_player_timer_timeout():
	currState = State.Patrol

func Interact():
	EInteract.Interact()

func GetPlayerDistance():
	if Player:
		return (Player.global_position - global_position).length()

func TurnToPlayer():
	if Player != null:
		var val = transform.looking_at(Player.global_transform.origin, Vector3.UP, true)
		transform.basis = lerp(transform.basis, val.basis, .5)
		rotation_degrees = Vector3(0,rotation_degrees.y,0)


# CALLS
func Alert():
	mental -= mental_chip
	clampf(mental, 0, 100)
	
	if allowLook == false:
		if LookToPlayerTimer.is_stopped():
			LookToPlayerTimer.wait_time = slowReact
			LookToPlayerTimer.start()
	
	if mental >= mental_to_stand:
		EAnim.AnimArms(.1)
	
func _on_look_to_player_timer_timeout():
	allowLook = true

func _on_decide_surrender_timer_timeout():
	var surrendChance = randf_range(surrendChanceMin, surrendChanceMax)
	if surrendChance >= surrenderThreshold:
		mental = 0
		currState = State.Surrender
	else:
		currState = State.Combat

func Shoot(firerate):
	var victim = Trajectory.get_collider()
	if victim != null && victim.name == "Player":
		if At.get("parameters/OS_FullBody/active") == false:
			if FireRate.is_stopped():
				FireRate.wait_time = firerate
				FireRate.start()
				
				var hitChance = randf_range(hitChanceMin, hitChanceMax)
				var dmg = randf_range(dmgMin, dmgMax)
				
				if firerate == fireRateAuto:
					var hitmin = hitChanceMin + hitChanceSad
					if mental < mental_to_miss:
						hitmin += hitChanceSad
					
					hitChance = randf_range(hitmin, hitChanceMax)
				
				if hitChance >= 100:
					Player.Hurt(dmg)
				
				SPV.PlaySound("Shoot")
				EAnim.AnimArms(0)



# ENDINGS
func Restrained():
	EAnim.AnimFullBody(0, 2)
	
	restrained = true
	Eyes.monitoring = false
	
	DisableCollision()

func Die():
	EAnim.AnimFullBody(.1)
	
	apply_impulse(transform.basis.z * 2, $Places/DeathPush.position)
	apply_impulse(transform.basis.y * 50, $Places/DeathPush.position)
	
	DisableCollision()

func DisableCollision():
	currState = State.Done
	mental = 0
	health = 0
	
	RestrainPrompt.Invisible()
	EInteract.ProgressRestrain.visible = false
	
	# disable and alter collision
	if DisablementTimer.is_stopped():
		DisablementTimer.start()
	
func _on_disablement_timer_timeout():
	call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	#set_collision_mask_value(2, false)
	set_collision_layer_value(4, false)
	set_collision_layer_value(3, true)



func _input(event):
	
	if event.is_action_pressed("Shoot"):
		if AllAroundYouTimer.is_stopped():
			AllAroundYouTimer.start()

func _on_all_around_you_timer_timeout():
	for i in Eyes.get_overlapping_bodies():
		if i.is_in_group("Enemy") && i != self:
			if i.health <= 0:
				mental -= mental_friendDied
				SPV.PlayVoice("TeamKilled")



func _physics_process(delta):
	if currState != State.Done && process_mode != PROCESS_MODE_DISABLED:
		
		# GENERAL CODE
		if health <= 0:
			Die()
		
		
		# STATE PATROL
		if currState == State.Patrol:
			# transition
			if allowLook == true:
				
				if DecideSurrenderTimer.is_stopped():
					DecideSurrenderTimer.start()
		
		
		# STATE COMBAT
		if currState == State.Combat:
			# transition
			if mental < mental_to_stand:
				currState = State.Surrender
			
			if allowLook == true:
				
				# shoot if close
				if GetPlayerDistance() <= shootAutoDist:
					Shoot(fireRateAuto)
				elif GetPlayerDistance() <= shootSemiDist:
					Shoot(fireRateSemi)
		
		
		# STATE SURRENDER
		if currState == State.Surrender:
			RestrainPrompt.Visible()
			
			allowLook = false
			EAnim.AnimFullBody(0)
			
			if restrained == false:
				mental = lerpf(mental, mental_to_stand+5, mental_accel)
				
				# transition
				if mental >= mental_to_stand:
					EAnim.AnimFullBody(0, 1)
					currState = State.Combat
			
		else:
			mental = lerpf(mental, 100, mental_accel_slow)
			
			if At.get("parameters/OS_FullBody/active") == true:
				EAnim.AnimFullBody(10)
			RestrainPrompt.Invisible()
			
			if allowLook == true:
				TurnToPlayer()
