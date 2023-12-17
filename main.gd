extends Node2D

const SCENE_INTERACT_OPTIONS = preload("res://scenes/ui/interact_options.tscn")

func spawn_interact_popup(pos: Vector2, options: Array):
	var popup = SCENE_INTERACT_OPTIONS.instantiate()
	
	if $Popups.get_child_count() > 0:
		for child in $Popups.get_children():
			child.queue_free()
	
	popup.position = pos
	popup.show_options(options)
	
	$Popups.add_child(popup)
