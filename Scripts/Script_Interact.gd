extends Node

@onready var Eyes = $"../../Head/Camera3D/Eyes"

func _process(delta):
	var victim = Eyes.get_collider()
	
	if victim: # only detects with collision in layer 5 Interactable
		
		if victim.get_script().get_path() == "res://Scripts/Interact_Door.gd":
			victim.finger = Eyes.get_collision_point()
		if Input.is_action_just_pressed("Interact"):
			victim.Interact()
