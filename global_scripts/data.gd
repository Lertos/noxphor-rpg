extends Node

enum FILE_TYPE {CHARACTER, DIALOGUE, QUESTS}

const debug = true

var files = {
	FILE_TYPE.CHARACTER: {
		"file_name": "characters.dat",
		"data": {},
		"is_master_data": true
	},
	FILE_TYPE.DIALOGUE: {
		"file_name": "dialogue.dat",
		"data": {},
		"is_master_data": true
	},
	FILE_TYPE.QUESTS: {
		"file_name": "quests.dat",
		"data": {},
		"is_master_data": true
	}
}

func _ready():
	#Load all files
	for index in FILE_TYPE.values():
		load_file(files[index])

func exists(type: FILE_TYPE, dict_key) -> bool:
	return files[type]["data"].has(dict_key)

func get_entire_dict(type: FILE_TYPE):
	return files[type]["data"]
	
func get_dict(type: FILE_TYPE, dict_key):
	return files[type]["data"][dict_key]
	
func save_key(type: FILE_TYPE, dict_to_save: Dictionary, dict_key):
	files[type]["data"][dict_key] = dict_to_save
	
	if debug:
		print(files[type]["data"][dict_key])
	
	print("Key added")
	save_file(type)

func delete_key(type: FILE_TYPE, dict_key):
	files[type]["data"].erase(dict_key)

	if debug:
		print(files[type]["data"])

	print("Key deleted")
	save_file(type)
	
func save_file(type: FILE_TYPE):
	print("File saved")
	pass

func load_file(file_dict: Dictionary):
	print(file_dict["file_name"] + " loaded")
	pass
