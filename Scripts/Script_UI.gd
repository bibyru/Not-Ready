extends Node

@onready var Player = $"../.."
@onready var LSafety = $UI/Control/LabelSafety
@onready var LAmmo = $UI/Control/LabelAmmo
@onready var LabelTimer = $UI/LabelTimer

func _ready():
	LSafety.modulate = Color(1,1,1, 0 )
	LAmmo.modulate = Color(1,1,1, 0 )

func AnimateLabelFadeOut():
	if LAmmo.modulate == Color(1,1,1, 1 ):
		var thetween = create_tween()
		thetween.tween_property(LAmmo, "modulate", Color(1,1,1, 0 ), 0.2)
	
	if LSafety.modulate == Color(1,1,1, 1 ):
		var thetween = create_tween()
		thetween.tween_property(LSafety, "modulate", Color(1,1,1, 0 ), 0.2)
	
	StartTimer()

func StartTimer():
	if LabelTimer.is_stopped():
		LabelTimer.start()
	else:
		LabelTimer.stop()
		LabelTimer.start()

func _on_label_timer_timeout():
	AnimateLabelFadeOut()

func ShowSafety(num, flickAnim = true):
	var texts = ["Safety On","Semi","Auto"]
	LSafety.text = texts[num]
	LSafety.modulate = Color(1,1,1, 1 )
	
	StartTimer()
	
	if flickAnim == true:
		Player.OneShotAnimationPick(.4)

func ShowAmmo(num):
	LAmmo.text = "Ammo: %d" %[num]
	LAmmo.modulate = Color(1,1,1, 1 )
	
	StartTimer()
