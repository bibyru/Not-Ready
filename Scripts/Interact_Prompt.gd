extends Node3D

@onready var Child = get_child(0)
@onready var IAnim = owner.find_child("Interact_Animation")

var getscale = scale
var multscale = scale * 1.5

func Visible():
	IAnim.AnimateLabel(Child, 1)

func Invisible():
	IAnim.AnimateLabel(Child, 0)

func SizeNormal():
	IAnim.AnimateNormalening(Child, getscale)

func SizeLarge():
	IAnim.AnimateEnlargening(Child, getscale, multscale)
