extends PopupPanel

@onready var f_command = $H/Right/Fields/Command
@onready var list_commands = $H/CommandList

var commands = []
var selected_index = -1

func open(commands: Array):
	self.commands = commands
	
	list_commands.clear()
	selected_index = -1
	
	for index in range(0, commands.size()):
		list_commands.add_item(commands[index])
	
	popup_centered_ratio(0.8)

func on_command_item_selected(index):
	var command = list_commands.get_item_text(index)
	
	if command == null or command == "":
		print("That command doesn't exist in the list")
		return
		
	f_command.text = command
	selected_index = index

func on_add_pressed():
	var new_command = f_command.text
	
	if new_command == "":
		print("The command field cannot be empty")
		return
		
	for index in range(0, commands.size()):
		if new_command == commands[index]:
			print("There is already a command with that exact value")
			return
			
	commands.append(new_command)
	list_commands.add_item(new_command)

func on_update_pressed():
	if selected_index >= commands.size():
		print("The selected index no longer exists")
		return
		
	commands[selected_index] = f_command.text
	
	list_commands.set_item_text(selected_index, f_command.text)

func on_delete_pressed():
	if selected_index >= commands.size():
		print("The selected index no longer exists")
		return
		
	commands.remove_at(selected_index)
	list_commands.remove_item(selected_index)
	
	f_command.text = ""
	selected_index = -1

func on_popup_hide():
	get_parent().commands = commands
