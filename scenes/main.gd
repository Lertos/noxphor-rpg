extends Node2D

const SCENE_INTERACT_OPTIONS = preload("res://scenes/ui/interact_options.tscn")
const SCENE_FADER = preload("res://scenes/ui/fader.tscn")

@onready var node_popups = $Popups
@onready var node_level = $Level
@onready var node_fader = $Fader

var chat_window
var fader

func change_maps(scene_to_remove: Node, scene_to_add: String):
	#Fade out into black
	await fade_in()

	#Load the new scene
	var new_scene = load(scene_to_add)
	var loaded_scene = new_scene.instantiate()
	
	#When the current scene leaves the tree, add the new scene
	scene_to_remove.queue_free()
	await scene_to_remove.tree_exited
	
	node_level.add_child(loaded_scene)

	#When the new scene enters the tree, fade in
	if fader != null:
		await fader.fade_out()

func fade_in():
	fader = SCENE_FADER.instantiate()
	node_fader.add_child(fader)
	
	await fader.fade_in()

func spawn_interact_popup(pos: Vector2, entity_id: String, options: Array):
	var popup = SCENE_INTERACT_OPTIONS.instantiate()
	
	#May need to change this if you eventually want multiple popups
	if node_popups.get_child_count() > 0:
		for child in node_popups.get_children():
			child.queue_free()
	
	popup.name = entity_id
	popup.position = pos
	
	node_popups.add_child(popup)
	
	popup.show_options(options)

func handle_popup_event(entity_id: String, chosen_option: String):
	if chosen_option.to_lower() == "leave":
		States.change_state(States.STATE.PLAYING)
	elif chosen_option.to_lower() == "talk":
		States.change_state(States.STATE.IN_MENU, "chat")
		
		chat_window.send_message("Work in progress, you filthy animal")

	#Here simply to make sure popups don't trap people, but will also raise an error to let you know
	else:
		States.change_state(States.STATE.PLAYING)
	
	if node_popups.has_node(entity_id):
		node_popups.get_node(entity_id).queue_free()
