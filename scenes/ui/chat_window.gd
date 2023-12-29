extends Control

func _ready():
	get_tree().get_root().get_node("root").chat_window = self

func configure_initial_box(pos: Vector2, width: float, height: float):
	$Background.position = pos
	$Background.size.x = width
	$Background.size.y = height

func send_message(text: String):
	$Background/Margin/V/Label.text = text

	self.visible = true

func close_window():
	self.visible = false
	
func _input(event):
	if not States.is_state(States.STATE.IN_MENU) or not States.is_data("chat"):
		return
		
	#TODO: Change to continue the conversation, exit it, etc
	if event.is_action_pressed("action"):
		call_deferred("change_state")
		
	get_viewport().set_input_as_handled()

func change_state():
	States.change_state(States.STATE.PLAYING)
	
	close_window()
