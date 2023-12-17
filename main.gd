extends Node2D

const SCENE_INTERACT_OPTIONS = preload("res://scenes/ui/interact_options.tscn")

func spawn_interact_popup(pos: Vector2, options: Array):
	var popup = SCENE_INTERACT_OPTIONS.instantiate()
	
	popup.position = pos
	popup.show_options(options)
	
	add_child(popup)
