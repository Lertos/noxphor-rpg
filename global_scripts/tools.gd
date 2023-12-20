extends Node

enum TOOL {ENTITY_DESIGNER}

const tool_resources: Dictionary = {
	TOOL.ENTITY_DESIGNER: "res://z_tools/entity_designer.tscn"
}

const tool_scene_name: String = "current_tool"
const tools_allowed: bool = true

var is_any_tool_open: bool = false

func _unhandled_input(event):
	if not tools_allowed:
		return
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F12:
			open_tool(TOOL.ENTITY_DESIGNER)

func open_tool(tool_enum: TOOL):
	var resource_path: String = tool_resources[tool_enum]
	
	if resource_path == null:
		return
	
	var tool_scene = load(resource_path)

	if tool_scene == null:
		return

	#We are ready to open the new tool, so need to check if there is a current tool open
	if is_any_tool_open and get_tree().get_root().has_node(tool_scene_name):
		get_tree().get_root().get_node(tool_scene_name).queue_free()
		await get_tree().get_root().get_node(tool_scene_name).tree_exited
	
	add_new_tool(tool_scene)

func add_new_tool(tool_scene):
	var new_scene = tool_scene.instantiate()
	
	#Set the state so other events/inputs aren't triggered
	States.change_state(States.STATE.IN_MENU, "tool")
	
	#Change the screen size to the viewport as camera size changes
	toggle_player_camera(false)
	
	#Make sure to state that a tool is open
	is_any_tool_open = true
	
	get_tree().get_root().add_child(new_scene)
	
	new_scene.name = tool_scene_name

#Disable the camera so the viewport is used properly
func toggle_player_camera(set_to: bool):
	var node = get_tree().get_root().get_node("root")
	
	if node.has_node("Player"):
		node = node.get_node("Player")
		
		if node.has_node("Camera"):
			node = node.get_node("Camera")
			
			node.enabled = set_to
