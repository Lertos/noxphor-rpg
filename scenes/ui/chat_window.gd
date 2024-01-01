extends Control

@onready var dialogue_label = $Background/Margin/V/Label
@onready var name_label = $Background/Name/Margin/Label

var initial_continue_pos
var continue_tween

func _ready():
	Nodes.Root.chat_window = self
	
	#Setup the tween for the continue button
	initial_continue_pos = $Background/Continue.position
	
	continue_tween = get_tree().create_tween().set_loops()
	continue_tween.tween_property($Background/Continue, "position", Vector2(0, 1.5), 0.5).as_relative()
	continue_tween.tween_property($Background/Continue, "position", Vector2(0, -1.5), 0.5).as_relative()
	continue_tween.stop()

func configure_initial_box(pos: Vector2, width: float, height: float):
	$Background.position = pos
	$Background.size.x = width
	$Background.size.y = height

#TODO: Change param to a Dialogue object and extrapolate the text and name (and if there's a next)
func send_message(text: String):
	var char_name = "DeeDeeDeeDeeDeeDeeDee"
	
	dialogue_label.text = text
	name_label.text = "[center]" + char_name + "[/center]"
	
	var name_length = Helper.text_width(name_label)
	
	if name_length > $Background/Name.size.x:
		$Background/Name.size.x = name_length - $Background/Name/Margin.get_theme_constant("theme_override_constants/margin_left")

	show_continue()
	
	self.visible = true

func show_continue():
	$Background/Continue.position = initial_continue_pos
	continue_tween.play()

func close_window():
	continue_tween.stop()
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
