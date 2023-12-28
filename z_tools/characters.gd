extends MarginContainer

@onready var f_name = $H/Left/Name/Name
@onready var f_id = $H/Left/ID/ID
@onready var f_examine = $H/Left/Examine/Examine
@onready var f_hidden = $H/Left/Hidden/Hidden
@onready var f_combat_lvl = $H/Left/CombatLevel/CombatLevel
@onready var f_options = $H/Left/Options/Options

@onready var search_bar = $H/Right/Filter/SearchBar
@onready var list_characters = $H/Right/Filter/CharacterList

func _ready():
	reset_character_list("")

func add():
	if not validate_shared():
		return
		
	#Make sure the ID doesn't already exist
	if Data.exists(Data.TYPE.CHARACTER, f_id.text):
		print("That character ID already exists. Perhaps you meant to 'Update' it?")
		return
	
	Data.save_key(Data.TYPE.CHARACTER, get_character_dict(), f_id.text)
	
	list_characters.add_item(f_id.text)
	list_characters.sort_items_by_text()
	print("Added New")

func update():
	if not validate_shared():
		return
		
	#Make sure the ID actually exists
	if not Data.exists(Data.TYPE.CHARACTER, f_id.text):
		print("That character ID doesn't exist. Perhaps you meant to 'Add' it?")
		return
		
	Data.save_key(Data.TYPE.CHARACTER, get_character_dict(), f_id.text)
	
	print("Updated Existing")

func delete():
	#Make sure the ID actually exists
	if not Data.exists(Data.TYPE.CHARACTER, f_id.text):
		print("That character ID doesn't exist, so it cannot be deleted")
		return
		
	Data.delete_key(Data.TYPE.CHARACTER, f_id.text)
	
	for index in range(0, list_characters.item_count):
		if list_characters.get_item_text(index) == f_id.text:
			list_characters.remove_item(index)
			break
	
	print("Deleted Existing")

func validate_shared() -> bool:
	var alert_message = ""
	
	#Make sure crucial fields are not blank
	if f_name.text == "":
		alert_message = "The 'Name' field cannot be blank"
	elif f_id.text == "":
		alert_message = "The 'ID' field cannot be blank"
	elif f_examine.text == "":
		alert_message = "The 'Examine' field cannot be blank"
	
	#Make sure that fields mapped to other entities actually exist
	#TODO: Finish once others are done and you have dict's to query
	
	if alert_message != "":
		print(alert_message)
		return false
		
	return true

func get_character_dict() -> Dictionary:
	var new_dict = {}
	
	new_dict["name"] = f_name.text
	new_dict["examine"] = f_examine.text
	new_dict["hidden"] = f_hidden.is_pressed()
	new_dict["combat_level"] = f_combat_lvl.get_selected_id()
	
	var options = []
	
	for index in f_options.get_selected_items():
		options.append(f_options.get_item_text(index))
	
	new_dict["options"] = options
	
	return new_dict

func reset_character_list(filter_text: String):
	list_characters.clear()
	
	if filter_text == "":
		for key in Data.get_entire_dict(Data.TYPE.CHARACTER).keys():
			list_characters.add_item(key)
	else:
		for key in Data.get_entire_dict(Data.TYPE.CHARACTER).keys():
			if filter_text in key:
				list_characters.add_item(key)
		
	list_characters.sort_items_by_text()

func on_search_bar_text_changed(new_text):
	reset_character_list(new_text)

func on_character_list_item_clicked(index, at_position, mouse_button_index):
	var char_id = list_characters.get_item_text(index)
	
	if char_id == null or char_id == "":
		print("That ID cannot be retrieved from the list")
		return
	
	if not Data.exists(Data.TYPE.CHARACTER, char_id):
		print("That character ID does not exist in the data dict")
		return

	var char_data = Data.get_dict(Data.TYPE.CHARACTER, char_id)
	
	f_id.text = char_id
	f_name.text = char_data["name"]
	f_examine.text = char_data["examine"]
	f_hidden.button_pressed = char_data["hidden"]
	f_combat_lvl.select(char_data["combat_level"])
	
	for i in range(0, f_options.item_count):
		f_options.deselect(i)
	
	for option in char_data["options"]:
		for i in range(0, f_options.item_count):
			if f_options.get_item_text(i) == option:
				f_options.select(i, false)
