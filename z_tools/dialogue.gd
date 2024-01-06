extends Node

@onready var f_char_id = $H/Fields/CharID/CharID
@onready var f_dialogue_id = $H/Fields/DialogueID/DialogueID
@onready var f_next_id = $H/Fields/Next/Next
@onready var f_type = $H/Fields/Type/Type
@onready var f_commands = $H/Fields/Commands/Commands
@onready var f_reqs = $H/Fields/Reqs/Reqs
@onready var f_dialogue = $H/Fields/Dialogue/Dialogue
@onready var f_options = $H/Fields/Options/Options

@onready var char_search_bar = $H/Searches/CharSearch/Filter/SearchBar
@onready var list_characters = $H/Searches/CharSearch/Filter/CharacterList
@onready var dialogue_search_bar = $H/Searches/DialogueSearch/Filter/SearchBar
@onready var list_dialogue = $H/Searches/DialogueSearch/Filter/DialogueList

const CHAR_DATA_TYPE = Data.TYPE.CHARACTER
const DIALOGUE_DATA_TYPE = Data.TYPE.DIALOGUE

enum DIALOGUE_TYPE {NORMAL, OPTIONS}

#Holds each command as a single String since every command can be a little different
var commands = []
#Holds each req as a dict: { "fact": "", "operator": "", "value": "" }
var reqs = []
#Holds each dialogue as a dict: { "speaker": "", "text": "" }
var dialogue = []
#Holds each option as a dict: { "text": "", "next": "", "commands" : [] }
var options = []

func _ready():
	reset_character_list("")
	reset_dialogue_list("")

func save_dialogue():
	if not validate():
		return

	var already_exists = false
	
	if Data.get_entire_dict(DIALOGUE_DATA_TYPE).has(f_char_id.text):
		already_exists = Data.get_entire_dict(DIALOGUE_DATA_TYPE)[f_char_id.text].has(f_dialogue_id.text)

	Data.get_entire_dict(DIALOGUE_DATA_TYPE)[f_char_id.text][f_dialogue_id.text] = get_dialogue_dict()
	
	if not already_exists:
		list_dialogue.add_item(f_dialogue_id.text)
		list_dialogue.sort_items_by_text()

func delete():
	#Make sure the ID actually exists
	if not Data.get_entire_dict(DIALOGUE_DATA_TYPE).has(f_char_id.text):
		print("That character ID doesn't have any dialogue yet")
		return
	elif not Data.get_entire_dict(DIALOGUE_DATA_TYPE)[f_char_id.text].has(f_dialogue_id.text):
		print("That dialogue ID doesn't exist for that character, so it cannot be deleted")
		return
		
	Data.get_entire_dict(DIALOGUE_DATA_TYPE)[f_char_id.text].erase(f_dialogue_id.text)
	
	for index in range(0, list_dialogue.item_count):
		if list_dialogue.get_item_text(index) == f_dialogue_id.text:
			list_dialogue.remove_item(index)
			break

func validate() -> bool:
	var alert_message = ""
	
	#Make sure crucial fields are not blank
	if f_char_id.text == "":
		alert_message = "The 'Character ID' field cannot be blank"
	elif f_dialogue_id.text == "":
		alert_message = "The 'Dialogue ID' field cannot be blank"
	#TODO: Need to check that dialogue or options aren't blank based on the type

	if alert_message != "":
		print(alert_message)
		return false
		
	return true

func get_dialogue_dict() -> Dictionary:
	var new_dict = {}
	
	"""
	new_dict["name"] = f_name.text
	new_dict["examine"] = f_examine.text
	new_dict["hidden"] = f_hidden.is_pressed()
	new_dict["combat_level"] = f_combat_lvl.get_selected_id()
	
	var options = []
	
	for index in f_options.get_selected_items():
		options.append(f_options.get_item_text(index))
	
	new_dict["options"] = options
	"""
	return new_dict

func reset_character_list(filter_text: String):
	list_characters.clear()

	if filter_text == "":
		for key in Data.get_entire_dict(CHAR_DATA_TYPE).keys():
			list_characters.add_item(key)
	else:
		for key in Data.get_entire_dict(CHAR_DATA_TYPE).keys():
			if filter_text in key:
				list_characters.add_item(key)
		
	list_characters.sort_items_by_text()
	
func reset_dialogue_list(filter_text: String):
	list_dialogue.clear()

	#If the character doesn't have dialogue yet, just return
	if not Data.get_entire_dict(DIALOGUE_DATA_TYPE).has(f_char_id.text):
		return
	
	if filter_text == "":
		for key in Data.get_entire_dict(DIALOGUE_DATA_TYPE)[f_char_id.text].keys():
			list_dialogue.add_item(key)
	else:
		for key in Data.get_entire_dict(DIALOGUE_DATA_TYPE)[f_char_id.text].keys():
			if filter_text in key:
				list_dialogue.add_item(key)
		
	list_dialogue.sort_items_by_text()

func on_char_search_bar_text_changed(new_text):
	reset_character_list(new_text)
	
func on_dialogue_search_bar_text_changed(new_text):
	reset_dialogue_list(new_text)

func on_character_list_item_clicked(index, at_position, mouse_button_index):
	var char_id = list_characters.get_item_text(index)
	
	if char_id == null or char_id == "":
		print("That ID cannot be retrieved from the list")
		return
	
	if not Data.exists(CHAR_DATA_TYPE, char_id):
		print("That character ID does not exist in the data dict")
		return
	
	f_char_id.text = char_id
	dialogue_search_bar.editable = true
	
	reset_dialogue_list("")

func on_dialogue_list_item_clicked(index, at_position, mouse_button_index):
	var char_id = f_char_id.text
	
	if char_id == null or char_id == "":
		print("The character ID is blank so the Dialogue cannot be loaded")
		return
	
	if not Data.exists(CHAR_DATA_TYPE, char_id):
		print("That character ID does not exist in the data dict")
		return
	
	var dialogue_id = list_dialogue.get_item_text(index)
	
	if not Data.get_entire_dict(DIALOGUE_DATA_TYPE)[char_id].has(dialogue_id):
		print("That dialogue ID does not exist in the data dict")
		return
	
	f_dialogue_id.text = dialogue_id
	
	load_dialogue_fields(Data.get_entire_dict(DIALOGUE_DATA_TYPE)[char_id][dialogue_id])

func set_textfield_text(field: TextEdit, text: String):
	field.text += text + "\n"
	field.tooltip_text += text + "\n\n"

func reset_textfield(field: TextEdit):
	field.text = ""
	field.tooltip_text = ""

func load_dialogue_fields(dict: Dictionary):
	#First choose the type based on whether the dict has the "options" key
	f_type.select(DIALOGUE_TYPE.OPTIONS if dict.has("options") else DIALOGUE_TYPE.NORMAL)
	f_next_id.text = dict["next"] if dict.has("next") else ""
	
	#Reset each of the textboxes as they are appended to
	reset_textfield(f_commands)
	reset_textfield(f_reqs)
	reset_textfield(f_dialogue)
	reset_textfield(f_options)
	
	#Load each command in the text and hint variables so they can preview and hover for details
	if dict.has("commands"):
		commands = dict["commands"]
		
		#Then load all of the text so the person can see a preview
		for index in range(0, commands.size()):
			set_textfield_text(f_commands, commands[index])
	
	#Load each req in the text and hint variables so they can preview and hover for details
	if dict.has("reqs"):
		reqs = dict["reqs"]
		
		#Then load all of the text so the person can see a preview
		for index in range(0, reqs.size()):
			var req_line = reqs[index]["fact_id"] + " " + reqs[index]["operator"] + " " + reqs[index]["value"]
			
			set_textfield_text(f_reqs, req_line)
	
	#Load either the text or options. We don't load the text as it's always too much to see; let them hover
	if dict.has("options"):
		options = dict["options"]
		
		#Then load all of the text so the person can see a preview
		for index in range(0, options.size()):
			var option_line = options[index]["text"] + (" -> " + options[index]["next"] if options[index].has("next") else "")
			
			f_options.tooltip_text += option_line + "\n\n"
	else:
		dialogue = dict["text"]
		
		#Then load all of the text so the person can see a preview
		for index in range(0, dialogue.size()):
			var speaker
			
			match dialogue[index]["speaker"]:
				"": speaker = "Narrator: "
				"you": speaker = "YOU: "
				_: speaker = dialogue[index]["speaker"] + ": "
				
			var dialogue_line = speaker + dialogue[index]["text"]
			
			f_dialogue.tooltip_text += dialogue_line + "\n\n"

func on_type_changed(index):
	if index == DIALOGUE_TYPE.NORMAL:
		f_options.get_parent().visible = false
		f_dialogue.get_parent().visible = true
	else:
		f_options.get_parent().visible = true
		f_dialogue.get_parent().visible = false
