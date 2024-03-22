extends Node

const animSpeed = .15

func AnimateLabel(prompt, num):
	var thetween = create_tween()
	thetween.tween_property(prompt, "modulate", Color(1,1,1,num), animSpeed)

func AnimateEnlargening(prompt, getscale, multscale):
	var thetween = create_tween()
	thetween.tween_property(prompt, "scale", Vector3(multscale.x, getscale.y, multscale.z), animSpeed)

func AnimateNormalening(prompt, getscale):
	var thetween = create_tween()
	thetween.tween_property(prompt, "scale", getscale, animSpeed)
