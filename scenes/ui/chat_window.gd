extends Control

@onready var name_label = $Background/Name/Margin/Label
@onready var options_node = $Background/Margin/Options
@onready var dialogue_label = $Background/Margin/Text

var current_dialogue
var current_dialogue_index
var current_chosen_option_index
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

func send_message(dialogue: Dialogue):
	#Reset all data
	current_dialogue = dialogue
	current_dialogue_index = 0
	current_chosen_option_index = 0
	
	options_node.visible = false
	dialogue_label.visible = false
	$Background/Name.visible = false
	$Background/Continue.visible = false
	
	if options_node.get_child_count() > 1:
		for child in options_node.get_children():
			if child.name != "Template":
				options_node.remove_child(child)
	
	#Choose the right path based on what exists in the Dialogue object
	if not dialogue.dialogue_options.is_empty():
		options_node.visible = true
		show_options_dialogue()
	elif not dialogue.dialogue_text.is_empty():
		dialogue_label.visible = true
		show_normal_dialogue()
		
	self.visible = true

func show_normal_dialogue():
	var text_arr = current_dialogue.dialogue_text
	var dialogue_dict
	
	#If there is still dialogue left to show
	if current_dialogue_index < text_arr.size():
		$Background/Continue.visible = false
		
		dialogue_dict = text_arr[current_dialogue_index]
		
		if dialogue_dict.has("speaker"):
			var speaker_id = dialogue_dict["speaker"]

			#The narrator / flavor text
			if speaker_id == "":
				$Background/Name.visible = false
			elif speaker_id == "you":
				$Background/Name.visible = true
				set_dialogue_name("You")
			else:
				$Background/Name.visible = true
				set_dialogue_name(Data.get_dict(Data.TYPE.CHARACTER, current_dialogue.character_id)["name"])

		set_dialogue_text(dialogue_dict["text"])
		
	#If the dialogue is over, check for commands and the next dialogue to goto
	else:
		Nodes.Dialogue.finish_dialogue(current_dialogue)

func show_options_dialogue():
	#Hide the name plate
	$Background/Name.visible = false
	
	#Load the options
	for index in range(0, current_dialogue.dialogue_options.size()):
		var new_label = options_node.get_child(0).duplicate()
		
		new_label.name = str(index)
		new_label.text = str(index + 1) + ". " + current_dialogue.dialogue_options[index]["text"]
		new_label.visible = true
		
		options_node.add_child(new_label)
		
		#Set the intial chosen option
		switch_option(0)

func switch_option(index: int):
	#Reset the other labels
	for label in options_node.get_children():
		label.text = label.text.replace("[color=green]", "").replace("[/color]", "")
	
	var label = options_node.get_node(str(index))
	
	if label != null:
		label.text = "[color=green]" + label.text + "[/color]"
		current_chosen_option_index = index

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
		
	#Handle the continue 
	if event.is_action_pressed("action"):
		#If the continue button as pressed, continue the dialogue
		if $Background/Continue.visible:
			current_dialogue_index += 1
			show_normal_dialogue()
		#If an option was chosen
		elif options_node.visible:
			Nodes.Dialogue.handle_dialogue_option(current_dialogue, current_chosen_option_index)
	elif options_node.visible:
		if event.is_action_pressed("down"):
			if current_chosen_option_index == current_dialogue.dialogue_options.size() - 1:
				switch_option(0)
			else:
				switch_option(current_chosen_option_index + 1)
		elif event.is_action_pressed("up"):
			if current_chosen_option_index == 0:
				switch_option(current_dialogue.dialogue_options.size() - 1)
			else:
				switch_option(current_chosen_option_index - 1)
	
	#Consume the event so it won't go to other input events
	get_viewport().set_input_as_handled()

func change_state():
	States.change_state(States.STATE.PLAYING)
	
	close_window()
