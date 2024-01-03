extends Control

@onready var dialogue_label = $Background/Margin/V/Label
@onready var name_label = $Background/Name/Margin/Label

var initial_name_label_size
var initial_continue_pos
var continue_tween

func _ready():
	Nodes.Dialogue.chat_window = self
	
	#Setup the tween for the continue button
	initial_continue_pos = $Background/Continue.position
	initial_name_label_size = $Background/Name.size
	
	continue_tween = get_tree().create_tween().set_loops()
	continue_tween.tween_property($Background/Continue, "position", Vector2(0, 1), 0.5).as_relative()
	continue_tween.tween_property($Background/Continue, "position", Vector2(0, -1), 0.5).as_relative()
	continue_tween.stop()

func configure_initial_box(pos: Vector2, width: float, height: float):
	$Background.position = pos
	$Background.size.x = width
	$Background.size.y = height

#TODO: Change param to a Dialogue object and extrapolate the text and name (and if there's a next)
func send_message(text: String):
	#TODO: Get the name from the Dialogue object
	set_dialogue_name("Dee")
	set_dialogue_text(text)
	
	self.visible = true

func set_dialogue_text(text: String):
	dialogue_label.text = text
	dialogue_label.visible_ratio = 0
	
	var time = dialogue_label.text.length() / Data.reveal_speed

	var reveal_tween = create_tween()
	reveal_tween.tween_property(dialogue_label, "visible_ratio", 1, time)
	reveal_tween.tween_callback(self.show_continue)

func set_dialogue_name(char_name: String):
	$Background/Name.size = initial_name_label_size
	name_label.text = char_name
	
	#Need to check if the name is bigger than the default width
	var name_length = Helper.label_width(name_label)
	
	if name_length > $Background/Name.size.x:
		$Background/Name.size.x = name_length + $Background/Name/Margin.get_theme_constant("margin_left") * 2
	
	#Add the "center" BBCode back in the center the name
	name_label.text = "[center]" + char_name + "[/center]"

func show_continue():
	$Background/Continue.position = initial_continue_pos
	$Background/Continue.visible = true
	continue_tween.play()

func close_window():
	$Background/Continue.visible = false
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
