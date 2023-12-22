extends Node

enum TOOL {ENTITY_DESIGNER}

const tool_resources: Dictionary = {
	TOOL.ENTITY_DESIGNER: "res://z_tools/entity_designer.tscn"
}

const tool_scene_name: String = "current_tool"
const tools_allowed: bool = true

var tool_id_open: int = -1

func _unhandled_input(event):
	if not tools_allowed:
		return
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F12:
			open_tool(TOOL.ENTITY_DESIGNER)

func open_tool(tool_enum: TOOL):
	var resource_path: String = tool_resources[tool_enum]
	
	if resource_path == null:
		assert(false, "tools.gd/open_tool: resource_path is NULL")
		return
	
	var tool_scene = load(resource_path)

	if tool_scene == null:
		assert(false, "tools.gd/open_tool: tool_scene is NULL")
		return

	var temp_tool_id = tool_id_open

	#If there is a tool currently open we need to close it
	if tool_id_open != -1 and get_tree().get_root().has_node(tool_scene_name):
		close_current_tool()
		
	#If it's not the same tool key, then open the new tool as well
	if temp_tool_id != tool_enum:
		add_new_tool(tool_scene, tool_enum)

func close_current_tool():
	tool_id_open = -1
	
	#Set the state so other events/inputs aren't triggered
	States.change_state(States.STATE.PLAYING, "")
	
	#Change the screen size to the viewport as camera size changes
	toggle_player_camera(true)
	
	get_tree().get_root().get_node(tool_scene_name).queue_free()
	await get_tree().get_root().get_node(tool_scene_name).tree_exited

func add_new_tool(tool_scene, tool_enum: TOOL):
	var new_scene = tool_scene.instantiate()
	
	#Set the state so other events/inputs aren't triggered
	States.change_state(States.STATE.IN_MENU, "tool")
	
	#Change the screen size to the viewport as camera size changes
	toggle_player_camera(false)
	
	#Make sure to st the currently open tool
	tool_id_open = tool_enum
	
	get_tree().get_root().add_child(new_scene)
	
	new_scene.name = tool_scene_name

#Disable the camera so the viewport is used properly
func toggle_player_camera(set_to: bool):
	Nodes.camera().enabled = set_to
