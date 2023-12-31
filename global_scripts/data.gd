extends Node

enum TYPE {CHARACTER, QUESTS, FACTS, DIALOGUE}
enum REVEAL_SPEED {SLOW, MID, FAST}

const debug = true

var reveal_speed: float

var files = {
	TYPE.CHARACTER: {
		"file_name": "characters.dat",
		"is_master_data": true,
		"clear_on_debug": false,
		"data": {}
	},
	TYPE.QUESTS: {
		"file_name": "quests.dat",
		"is_master_data": true,
		"clear_on_debug": false,
		"data": {}
	},
	TYPE.FACTS: {
		"file_name": "facts.dat",
		"is_master_data": false,
		"clear_on_debug": true,
		"data": {}
	},
	TYPE.DIALOGUE: {
		"file_name": "dialogue.dat",
		"is_master_data": false,
		"clear_on_debug": false,
		"data": {
			#TODO: This is temporary
			"fred_turner": {
				"001": {
					"reqs": [
						{
							"fact_id": "quest_chest_opener",
							"operator": "=",
							"value": "-1"
						},
						{
							"fact_id": "met_fred_turner",
							"operator": "=",
							"value": "-1"
						}
					],
					"next": "003",
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
					],
					"commands": [
						"fact set met_fred_turner 1"
					]
				},
				"002": {
					"reqs": [
						{
							"fact_id": "quest_chest_opener",
							"operator": "=",
							"value": "-1"
						},
						{
							"fact_id": "met_fred_turner",
							"operator": "<>",
							"value": "-1"
						}
					],
					"next": "003",
					"text": [
						{
							"speaker": "fred_turner", 
							"text": "You again... I told you I don't have any quests."
						}
					]
				},
				"003": {
					"options": [
						{
							"text": "Threaten until he gives a quest",
							"next": "004"
						},
						{
							"text": "Ask nicely, winking at him at the end",
							"next": "005"
						},
						{
							"text": "Leave, you didn't want a stupid quest anyways",
						}
					]
				},
				"004": {
					"commands": [
						"fact set quest_chest_opener 1"
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
				"005": {
					"commands": [
						"fact set quest_chest_opener 1"
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
							"speaker": "", 
							"text": "He waits for you to walk away a little before resuming his work."
						},
						{
							"speaker": "fred_turner", 
							"text": "Hopefully not too soon..."
						}
					]
				},
				"006": {
					"reqs": [
						{
							"fact_id": "quest_chest_opener",
							"operator": "=",
							"value": "2"
						},
					],
					"commands": [
						"fact set quest_chest_opener 0"
					],
					"text": [
						{
							"speaker": "fred_turner", 
							"text": "Oh my goodness! You actually did it! You opened a chest! You are a hero! Now leave me alone."
						},
						{
							"speaker": "you", 
							"text": "I mean, us adventurers need to start somewhere."
						},
						{
							"speaker": "", 
							"text": "He clearly has seen many of your type and wants you to go away."
						}
					]
				},
				"007": {
					"reqs": [
						{
							"fact_id": "quest_chest_opener",
							"operator": "=",
							"value": "0"
						},
					],
					"text": [
						{
							"speaker": "fred_turner", 
							"text": "Please leave me be."
						}
					]
				},
				"008": {
					"reqs": [
						{
							"fact_id": "quest_chest_opener",
							"operator": "=",
							"value": "1"
						},
					],
					"text": [
						{
							"speaker": "fred_turner", 
							"text": "Go open the chest. I assume that shouldn't be too much trouble."
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
	
	#TODO: Eventually move this to some Settings singleton #Set the default text speed
	set_text_speed(REVEAL_SPEED.FAST)
	
	for index in TYPE.values():
		load_file(index)

#Simply just for running any tests I want
func run_tests():
	pass

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

func exists(type: TYPE, dict_key) -> bool:
	return files[type]["data"].has(dict_key)

func get_entire_dict(type: TYPE):
	return files[type]["data"]
	
func get_value(type: TYPE, dict_key):
	return files[type]["data"][dict_key]
	
func set_value(type: TYPE, dict_key, value):
	files[type]["data"][dict_key] = value
	
	save_file(type)
	
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
		
		if files[type]["clear_on_debug"]:
			files[type]["data"] = {}

func get_file_path(type: TYPE) -> String:
	if files[type]["is_master_data"]:
		return "res://" + files[type]["file_name"]
	else:
		return "user://" + files[type]["file_name"]
