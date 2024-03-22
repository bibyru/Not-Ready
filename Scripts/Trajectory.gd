extends RayCast3D

var defpos
var defrotdeg

func _ready():
	defpos = position
	defrotdeg = rotation_degrees

func _physics_process(delta):
	position = Vector3(defpos.x, defpos.y +1.5, defpos.z)
	rotation_degrees.x = defrotdeg.x -3
