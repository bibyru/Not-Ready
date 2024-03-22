extends RigidBody3D

var speed = 70
var yOffset = 20
var rotdegOffset = 1.5

@onready var RShot = $Rigid_Shot

func _ready():
	set_as_top_level(true)
	
	rotation_degrees.y += rotdegOffset
	apply_impulse(-transform.basis.z * speed, transform.basis.z)
	apply_impulse(transform.basis.y * yOffset, transform.basis.y)
