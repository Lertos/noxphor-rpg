extends NinePatchRect

const PREFIX_COLOR = "[color=yellow]"
const SUFFIX_COLOR = "[/color]"

var options = []
var current_option

func show_options(given_options: Array):
	#Make sure we set the state
	States.change_state(States.STATE.IN_MENU, "interact_options")
	
	options = given_options
	
	for option in options:
		var new_label = RichTextLabel.new()
		
		new_label.text = option
		new_label.fit_content = true
		new_label.bbcode_enabled = true
		
		#An atrocious workaround... The fact RTL's can't just auto-adjust width is ridiculous
		new_label.custom_minimum_size.x = new_label.get_theme_font("font").get_string_size(new_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, new_label.get_theme_font_size("font_size")).x
		
		$MarginContainer/VBoxContainer.add_child(new_label)

	if $MarginContainer/VBoxContainer.get_child_count() > 0:
		change_selected_option(0)

	call_deferred("update_sizing")

func update_sizing():
	#Resize the ninepatch to fit the options
	self.size.x = $MarginContainer.size.x
	self.size.y = $MarginContainer.size.y
	
	#Always put it in the middle, vertically, of the source's position
	self.position.y -= self.size.y / 2
	
	#Always put it a bit to the right
	self.position.x += 7

func change_selected_option(new_index: int):
	var label
	
	if current_option != null:
		label = $MarginContainer/VBoxContainer.get_child(current_option)
		label.text = label.text.replace(PREFIX_COLOR, "").replace(SUFFIX_COLOR, "")
	
	current_option = new_index
	
	label = $MarginContainer/VBoxContainer.get_child(new_index)
	label.text = PREFIX_COLOR + label.text + SUFFIX_COLOR

func _input(event):
	if States.is_state(States.STATE.IN_MENU) and States.is_data("interact_options"):
		if event.is_action_pressed("down"):
			if current_option == len(options) - 1:
				change_selected_option(0)
			else:
				change_selected_option(current_option + 1)
		elif event.is_action_pressed("up"):
			if current_option == 0:
				change_selected_option(len(options) - 1)
			else:
				change_selected_option(current_option - 1)
		elif event.is_action_pressed("action"):
			get_tree().get_root().get_node("root").handle_popup_event(self.name, options[current_option])
