extends Node

enum FILE_TYPE {CHARACTER, DIALOGUE, QUESTS}

const debug = true

var file_names = {
	FILE_TYPE.CHARACTER: "characters.txt",
	FILE_TYPE.DIALOGUE: "dialogue.txt",
	FILE_TYPE.QUESTS: "quests.txt"
}

var characters = {}
var dialogue = {}
var quests = {}

func _ready():
	#TODO: Load all files
	pass

func add_key(type: FILE_TYPE, dict: Dictionary, dict_key):
	match type:
		FILE_TYPE.CHARACTER:
			save_key(characters, file_names[type], dict, dict_key)
		FILE_TYPE.DIALOGUE:
			save_key(dialogue, file_names[type], dict, dict_key)
		FILE_TYPE.QUESTS:
			save_key(quests, file_names[type], dict, dict_key)

func remove_key(type: FILE_TYPE, dict_key):
	match type:
		FILE_TYPE.CHARACTER:
			delete_key(characters, file_names[type], dict_key)
		FILE_TYPE.DIALOGUE:
			delete_key(dialogue, file_names[type], dict_key)
		FILE_TYPE.QUESTS:
			delete_key(quests, file_names[type], dict_key)

func save_key(parent_dict: Dictionary, file_name: String, dict_to_save: Dictionary, dict_key):
	parent_dict[dict_key] = dict_to_save
	
	if debug:
		print(parent_dict)
	
	print("Key added")
	save_file(parent_dict, file_name)

func delete_key(parent_dict: Dictionary, file_name: String, dict_key):
	parent_dict.erase(dict_key)

	if debug:
		print(parent_dict)

	print("Key deleted")
	save_file(parent_dict, file_name)
	
func save_file(parent_dict: Dictionary, file_name: String):
	print("File saved")
	pass
