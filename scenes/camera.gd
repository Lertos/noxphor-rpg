extends Camera2D

const BOTTOM_MARGIN: float = 10.0
const DESIRED_WIDTH: float = 0.7 #0.2 = 20%
const DESIRED_HEIGHT: float = 0.3 #0.2 = 20%

func _ready() -> void:
	#Need to get the camera's rect from the camera position and the viewport size
	var half_size = get_viewport_rect().size * 0.5
	var camera_rect = Rect2(position - half_size, position + half_size)
	
	#Note the chat window is anchored top-left and is currently at 0,0
	var width = camera_rect.size.x * DESIRED_WIDTH
	var height = camera_rect.size.y * DESIRED_HEIGHT
	
	var x_pos = (camera_rect.size.x - width) / 2
	var y_pos = camera_rect.size.y - height - BOTTOM_MARGIN
	
	get_parent().get_node("ChatWindow").configure_initial_box(Vector2(x_pos, y_pos), width, height)
