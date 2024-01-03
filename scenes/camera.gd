extends Camera2D

const BOTTOM_MARGIN: float = 5.0
const DESIRED_WIDTH: float = 0.7 #0.2 = 20%
const DESIRED_HEIGHT: float = 0.3 #0.2 = 20%

func _ready() -> void:
	#Make sure the camera is accessible from the Nodes singleton
	Nodes.camera = self
	
	#This is magic found from this lovely individual, fixed up to match Godot 4 docs
	#https://www.reddit.com/r/godot/comments/rzmfh3/comment/hrwd6mz/?utm_source=share&utm_medium=web2x&context=3
	var camera_rect = get_canvas_transform().affine_inverse().basis_xform(get_viewport_rect().size)
	
	#Note the chat window is anchored top-left and is currently at 0,0
	var width = camera_rect.x * DESIRED_WIDTH
	var height = camera_rect.y * DESIRED_HEIGHT
	
	var x_pos = -width / 2
	var y_pos = height / 2 - BOTTOM_MARGIN
	
	get_parent().get_node("ChatWindow").configure_initial_box(Vector2(x_pos, y_pos), width, height)
