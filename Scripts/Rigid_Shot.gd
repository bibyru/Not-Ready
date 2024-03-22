extends Node

func Shot(colpoint = Vector3.ZERO):
	
	if colpoint != Vector3.ZERO:
		if owner.is_in_group("Enemy"):
			if colpoint.y >= owner.find_child("Neckpoint").global_position.y:
				owner.apply_impulse(owner.transform.basis.z * 50)
				owner.Die()
			else:
				owner.health -= randf_range(20, 40)
