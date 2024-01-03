extends Node
class_name DialogueManager

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
		
	create_dialogue(chosen_dialogue_dict)

func load_specific_dialogue(character_id: String, dialogue_id: String) -> Dictionary:
	return {}
	
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
	
	return get_highest_reqs_dialogue(viable_dialogue)

func get_highest_reqs_dialogue(viable_dialogue: Array) -> Dictionary:
	var highest_reqs = 0
	var highest_index = -1
	
	for index in range(0, viable_dialogue.size()):
		var dict = viable_dialogue[index]
		
		if dict.has("reqs"):
			if dict["reqs"].size() > highest_reqs:
				highest_reqs = dict["reqs"].size()
				highest_index = index
	
	if highest_index == -1:
		return viable_dialogue[0]
	
	return viable_dialogue[highest_index]

#TODO: Logic to check each req
func meets_requirements(rect_dict: Dictionary) -> bool:
	return true

#Create the Dialogue object and send it to the ChatWindow
func create_dialogue(dialogue_dict: Dictionary):
	pass
