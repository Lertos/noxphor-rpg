extends NinePatchRect

var options = []

func show_options(given_options: Array):
	#Make sure we set the state
	States.current_state = States.STATE.IN_MENU
	States.current_state_data = "interact_options"
	
	for option in given_options:
		var new_label = RichTextLabel.new()
		
		new_label.text = option
		new_label.fit_content = true
		
		#An atrocious workaround... The fact RTL's can't just auto-adjust width is ridiculous
		new_label.custom_minimum_size.x = new_label.get_theme_font("font").get_string_size(new_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, new_label.get_theme_font_size("font_size")).x
		
		$MarginContainer/VBoxContainer.add_child(new_label)

	call_deferred("update_sizing")

func update_sizing():
	#Resize the ninepatch to fit the options
	self.size.x = $MarginContainer.size.x
	self.size.y = $MarginContainer.size.y
	
	#Always put it in the middle, vertically, of the source's position
	self.position.y -= self.size.y / 2
	
	#Always put it a bit to the right
	self.position.x += 7
