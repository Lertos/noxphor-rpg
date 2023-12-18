extends Node2D

const SCENE_INTERACT_OPTIONS = preload("res://scenes/ui/interact_options.tscn")

var chat_window

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

func handle_popup_event(entity_id: String, chosen_option: String):
	if chosen_option.to_lower() == "leave":
		States.change_state(States.STATE.PLAYING)
	elif chosen_option.to_lower() == "talk":
		States.change_state(States.STATE.IN_MENU, "chat")
		
		chat_window.send_message("Work in progress, you filthy animal")
	#Here simply to make sure popups don't trap people, but will also raise an error to let you know
	else:
		States.change_state(States.STATE.PLAYING)
	
	if $Popups.has_node(entity_id):
			$Popups.get_node(entity_id).queue_free()
