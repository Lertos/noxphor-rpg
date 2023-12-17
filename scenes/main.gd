extends Node2D

const SCENE_INTERACT_OPTIONS = preload("res://scenes/ui/interact_options.tscn")

func spawn_interact_popup(pos: Vector2, entity_id: String, options: Array):
	var popup = SCENE_INTERACT_OPTIONS.instantiate()
	
	#May need to change this if you eventually want multiple popups
	if $Popups.get_child_count() > 0:
		for child in $Popups.get_children():
			child.queue_free()
	
	popup.name = entity_id
	popup.position = pos
	popup.show_options(options)
	
	$Popups.add_child(popup)

func handle_event(entity_id: String, chosen_option: String):
	if chosen_option.to_lower() == "leave":
		if $Popups.has_node(entity_id):
			$Popups.get_node(entity_id).queue_free()
		
		States.current_state = States.STATE.PLAYING
		States.current_state_data = ""
