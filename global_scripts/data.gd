extends Node

enum TYPE {CHARACTER, DIALOGUE, QUESTS}

const debug = true

var files = {
	TYPE.CHARACTER: {
		"file_name": "characters.dat",
		"data": {},
		"is_master_data": true
	},
	TYPE.DIALOGUE: {
		"file_name": "dialogue.dat",
		"data": {},
		"is_master_data": true
	},
	TYPE.QUESTS: {
		"file_name": "quests.dat",
		"data": {},
		"is_master_data": true
	}
}

func _ready():
	if debug:
		run_tests()
	
	for index in TYPE.values():
		load_file(index)

#Simply just for running any tests I want
func run_tests():
	"""
	Nodes.event_manager.handle("talk::dude::1")
	Nodes.event_manager.handle("talk::1")
	Nodes.event_manager.handle("player::1")
	Nodes.event_manager.handle("not_valid::1")
	Nodes.event_manager.handle("player::give")
	Nodes.event_manager.handle("player::give::sword::1")
	"""

func exists(type: TYPE, dict_key) -> bool:
	return files[type]["data"].has(dict_key)

func get_entire_dict(type: TYPE):
	return files[type]["data"]
	
func get_dict(type: TYPE, dict_key):
	return files[type]["data"][dict_key]
	
func save_key(type: TYPE, dict_to_save: Dictionary, dict_key):
	files[type]["data"][dict_key] = dict_to_save
	
	if debug:
		print(files[type]["data"][dict_key])
		print("LOG: key added")
	
	save_file(type)

func delete_key(type: TYPE, dict_key):
	files[type]["data"].erase(dict_key)

	if debug:
		print("LOG: key deleted")
		print(files[type]["data"])

	save_file(type)
	
func save_file(type: TYPE):
	var file_path = get_file_path(type)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	var json_str = JSON.stringify(files[type]["data"])
	
	file.store_line(json_str)
	
	if debug:
		print("LOG: file saved at: " + file_path)

func load_file(type: TYPE):
	var file_path = get_file_path(type)
	
	#Check to make sure the file exists
	if not FileAccess.file_exists(file_path):
		print("ERROR: " + files[type]["file_name"] + " does not exist")
		return
	
	#Load the file into memory
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file or file == null:
		print("ERROR: " + files[type]["file_name"] + " cannot be loaded")
		return
	
	#Load the data into the respective dict
	var data = JSON.parse_string(file.get_line())
	
	if data:
		files[type]["data"] = data
	
	if debug:
		print(files[type]["file_name"] + " loaded")

func get_file_path(type: TYPE) -> String:
	if files[type]["is_master_data"]:
		return "res://" + files[type]["file_name"]
	else:
		return "user://" + files[type]["file_name"]
