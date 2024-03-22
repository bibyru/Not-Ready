extends OmniLight3D

func _ready():
	
	if light_energy == 0:
		print("OFF")
		$MeshInstance3D.mesh.material.emission_enabled = false
	else:
		print("ON")
