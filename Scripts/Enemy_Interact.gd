extends Node

@onready var At = $"../../AnimationTree"
@onready var RestrainPrompt = $"../../Places/RestrainPrompt"
@onready var TRestrain = $"../../Timers/RestrainTimer"
@onready var ProgressRestrain = $"../../Places/RestrainPrompt/ProgressBar"

@onready var EEnemy = $"../.."
@onready var EAnim = $"../Enemy_Animation"
@onready var IAnim = owner.find_child("Interact_Animation")

var interactionDist = 2
var restrainWaitTime = 1

func _ready():
	RestrainPrompt.Invisible()
	ProgressRestrain.visible = false
	ProgressRestrain.value = 0

func _process(delta):
	
	if Input.is_action_pressed("Interact"):
		if EEnemy.currState == EEnemy.State.Surrender:
			ProgressRestrain.value = (TRestrain.wait_time - TRestrain.time_left) * 100
	
	if Input.is_action_just_released("Interact"):
		ProgressRestrain.visible = false
		TRestrain.stop()

func Interact():
	# if player is in range and enemy is currently surrendering
	if EEnemy.GetPlayerDistance() != null:
		if abs(EEnemy.GetPlayerDistance()) <= interactionDist:
			if At.get("parameters/Blend_FullBody/blend_position") == 0 && At.get("parameters/Blend_FullBody/0/playback").get_current_node() == "Surrender":
				
				TRestrain.wait_time = restrainWaitTime
				if TRestrain.is_stopped():
					TRestrain.start()
				else:
					TRestrain.stop()
					TRestrain.start()
				ProgressRestrain.visible = true

func _on_restrain_timer_timeout():
	if Input.is_action_pressed("Interact"):
		EEnemy.Restrained()
