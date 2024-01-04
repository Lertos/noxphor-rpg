extends Node
class_name Dialogue

var character_id: String
var dialogue_id: String
var dialogue_text: Array
var dialogue_options: Array
var next_id: String
var commands: Array

func _init(character_id: String, dialogue_id: String, dialogue_dict: Dictionary):
	self.character_id = character_id
	self.dialogue_id = dialogue_id
	
	if dialogue_dict.has("text"):
		self.dialogue_text = dialogue_dict["text"]
		
	if dialogue_dict.has("options"):
		self.dialogue_options = dialogue_dict["options"]
		
	if dialogue_dict.has("next"):
		self.next_id = dialogue_dict["next"]
		
	if dialogue_dict.has("commands"):
		self.commands = dialogue_dict["commands"]

	#_to_string()

func _to_string():
	print()
	print("==DIALOGUE==")
	print("character_id: " + self.character_id)
	print("dialogue_id: " + self.dialogue_id)
	print("dialogue_text: ")
	print(self.dialogue_text)
	print("dialogue_options: ")
	print(self.dialogue_options)
	print("next_id: " + self.next_id)
	print("commands: ")
	print(self.commands)
	print()
