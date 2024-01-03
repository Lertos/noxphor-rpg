extends Node
class_name DialogueManager

@onready var chat_window

func _init():
	print("DialogueManager loaded")

func load_dialogue(character_id: String, dialogue_id := ""):
	#Check that a character with that ID actually exists
	if not Data.exists(Data.TYPE.CHARACTER, character_id):
		assert(false, "DialogueManager.gd: '" + character_id + "' does not exist in Data.characters")
		return
	
	#Check that the character actually has dialogue
	if not Data.exists(Data.TYPE.DIALOGUE, character_id):
		assert(false, "DialogueManager.gd: '" + character_id + "' does not exist in Data.dialogue")
		return
		
	#Check to see if we're loading specific dialogue or finding the best match
	var chosen_dialogue_dict = {}
	
	if dialogue_id == "":
		chosen_dialogue_dict = load_most_viable_dialogue(character_id)
	else:
		chosen_dialogue_dict = load_specific_dialogue(character_id, dialogue_id)
		
	if chosen_dialogue_dict == {}:
		assert(false, "DialogueManager.gd: chosen_dialogue_dict is empty")
		return
		
	create_dialogue(character_id, dialogue_id, chosen_dialogue_dict)

func load_specific_dialogue(character_id: String, dialogue_id: String) -> Dictionary:
	var char_dict = Data.get_dict(Data.TYPE.DIALOGUE, character_id)
	
	#Check that the character actually has that dialogue ID
	if not char_dict.has(dialogue_id):
		assert(false, "DialogueManager.gd: '" + character_id + "' does not have the dialogue ID: " + dialogue_id)
		return {}
		
	return char_dict[dialogue_id]
	
func load_most_viable_dialogue(character_id: String) -> Dictionary:
	#Loop through and check each of the dialogues, checking if it's already been seen or if reqs are met
	var char_dialogue = Data.get_dict(Data.TYPE.DIALOGUE, character_id)
	var viable_dialogue = []
	
	for dialogue in char_dialogue:
		var dict = char_dialogue[dialogue]
		
		#Check if this should be ignored based on being disabled
		if dict.has("disabled") and dict["disabled"] == true:
			continue
		
		#Check if this should be ignored based on seeing it once
		if dict.has("see_once") and dict["see_once"] == true:
			if dict.has("has_seen") and dict["has_seen"] == true:
				continue
		
		#Check if this should be ignored based on missing requirements
		if dict.has("reqs"):
			if not meets_requirements(dict["reqs"]):
				continue
				
		#If it makes it here, it's a valid dialogue, add it
		viable_dialogue.append(dialogue)
	
	if viable_dialogue.size() == 0:
		assert(false, "DialogueManager.gd: viable_dialogue size is 0")
		return {}
	
	return get_highest_reqs_dialogue(char_dialogue, viable_dialogue)

func get_highest_reqs_dialogue(char_dialogue: Dictionary, viable_dialogue: Array) -> Dictionary:
	var highest_reqs = 0
	var chosen_dialogue_id = viable_dialogue[0]
	
	for index in range(0, viable_dialogue.size()):
		var dialogue_id = viable_dialogue[index]
		var dict = char_dialogue[dialogue_id]
		
		if dict.has("reqs"):
			if dict["reqs"].size() > highest_reqs:
				highest_reqs = dict["reqs"].size()
				chosen_dialogue_id = dialogue_id

	return char_dialogue[chosen_dialogue_id]

#TODO: Logic to check each req
func meets_requirements(rect_dict: Dictionary) -> bool:
	return true

#Create the Dialogue object and send it to the ChatWindow
func create_dialogue(character_id: String, dialogue_id: String, dialogue_dict: Dictionary):
	if dialogue_id == "":
		dialogue_id = dialogue_dict.keys()[0]
		
	var dialogue = Dialogue.new(character_id, dialogue_id, dialogue_dict)
	
	chat_window.send_message(dialogue)

func finish_dialogue(dialogue: Dialogue):
	print("Dialogue finished")

	if not dialogue.commands.is_empty():
		execute_commands(dialogue.commands)
	
	#If there is a next_id, then load the next dialogue
	if not dialogue.next_id == "":
		load_dialogue(dialogue.character_id, dialogue.next_id)
	#If nothing left to do, then close the chat window
	else:
		chat_window.call_deferred("change_state")

func execute_commands(commands: Array):
	for command in commands:
		print(command)

func handle_dialogue_option(dialogue: Dialogue, index: int):
	if index >= dialogue.dialogue_options.size():
		assert(false, "DialogueManager.gd: handle_dialogue_option - index is out of bounds")
		return
		
	var chosen_option = dialogue.dialogue_options[index]
	
	if chosen_option.has("commands"):
		execute_commands(chosen_option["commands"])
	
	if chosen_option.has("next"):
		load_dialogue(dialogue.character_id, chosen_option["next"])
	else:
		finish_dialogue(dialogue)
