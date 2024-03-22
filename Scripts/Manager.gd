extends Node

const px360 = Vector2(640, 360)
const px720 = Vector2(1280, 720)
const px1080 = Vector2(1920, 1080)

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	DisplayServer.window_set_size(px720)
	get_window().content_scale_size = px720
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func Pause():
	if get_tree().paused == false:
		get_tree().paused = true
	else:
		get_tree().paused = false

func ReloadScene():
	Pause()
	get_tree().reload_current_scene()
	Pause()
