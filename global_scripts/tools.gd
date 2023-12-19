extends Node

const tools_allowed: bool = true

func _unhandled_input(event):
	if not tools_allowed:
		return
		
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F12:
			pass
