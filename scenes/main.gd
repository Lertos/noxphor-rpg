extends Node2D

const SCENE_INTERACT_OPTIONS = preload("res://scenes/ui/interact_options.tscn")

var chat_window

func change_maps(scene_to_remove: Node, scene_to_add: String):
	#Fade out into black
	print("Fade out")
	
	#Load the new scene
	var new_scene = load(scene_to_add)
	var loaded_scene = new_scene.instantiate()
	
	#When the current scene leaves the tree, add the new scene
	scene_to_remove.queue_free()
	await scene_to_remove.tree_exited
	
	self.add_child(loaded_scene, 0)
	
	#When the new scene enters the tree, fade in
	print("Fade in")

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
