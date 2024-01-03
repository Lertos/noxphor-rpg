extends Node

enum TYPE {CHARACTER, QUESTS, FACTS, DIALOGUE}
enum REVEAL_SPEED {SLOW, MID, FAST}

const debug = true

var reveal_speed: float

var files = {
	TYPE.CHARACTER: {
		"file_name": "characters.dat",
		"is_master_data": true,
		"data": {}
	},
	TYPE.QUESTS: {
		"file_name": "quests.dat",
		"is_master_data": true,
		"data": {}
	},
	TYPE.FACTS: {
		"file_name": "facts.dat",
		"is_master_data": false,
		"data": {}
	},
	TYPE.DIALOGUE: {
		"file_name": "dialogue.dat",
		"is_master_data": false,
		"data": {
			#TODO: This is temporary
			"fred_turner": {
				"001": {
					"see_once": true,
					"has_seen": true,
					"next": "002",
					"text": [
						{
							"speaker": "you", 
							"text": "Well howdy there!"
						},
						{
							"speaker": "fred_turner", 
							"text": "Oh hey, nice to meet you."
						},
						{
							"speaker": "you", 
							"text": "Got any quests?"
						},
						{
							"speaker": "fred_turner", 
							"text": "Hell no."
						}
					]
				},
				"002": {
					"options": [
						{
							"text": "Threaten until he gives a quest",
							"next": "003",
							"commands": [
								"modify_disposition fred_turner -10"
							]
						},
						{
							"text": "Ask nicely, winking at him at the end",
							"next": "004",
							"commands": [
								"modify_disposition fred_turner 10"
							]
						},
						{
							"text": "Leave, you didn't want a stupid quest anyways",
						}
					]
				},
				"003": {
					"commands": [
						"start_quest chest_opener"
					],
					"text": [
						{
							"speaker": "fred_turner", 
							"text": "Wait! Stop! Fine.. I uhh, go open that chest and bring me what's inside."
						},
						{
							"speaker": "you", 
							"text": "That's better. I'll see you soon pipsqueek."
						}
					]
				},
				"004": {
					"commands": [
						"start_quest chest_opener"
					],
					"text": [
						{
							"speaker": "fred_turner", 
							"text": "I'm not sure I like what you just did. Just go open that chest and bring me what's inside."
						},
						{
							"speaker": "you", 
							"text": "See ya soon sweet cheeks!"
						},
						{
							"speaker": "fred_turner", 
							"text": "Hopefully not too soon..."
						}
					]
				}
			}
		}
	}
}

func _ready():
	if debug:
		run_tests()
	
	#Set the default text speed
	set_text_speed(REVEAL_SPEED.FAST)
	
	for index in TYPE.values():
		load_file(index)
		
func set_text_speed(speed: REVEAL_SPEED):
	var chosen_speed = 50.0
	
	match speed:
		REVEAL_SPEED.SLOW:
			chosen_speed = 30.0
		REVEAL_SPEED.MID:
			chosen_speed = 50.0
		REVEAL_SPEED.FAST:
			chosen_speed = 70.0
			
	reveal_speed = chosen_speed

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
