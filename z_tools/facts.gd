extends Node

@onready var f_id = $H/Fields/ID/ID
@onready var f_value = $H/Fields/Value/Value

@onready var search_bar = $H/Filter/SearchBar
@onready var list_facts = $H/Filter/FactList

const DATA_TYPE = Data.TYPE.FACTS

func _ready():
	reset_fact_list("")

func save_fact():
	if not validate():
		return

	var already_exists = Data.exists(DATA_TYPE, f_id.text)

	Data.set_value(DATA_TYPE, f_id.text, float(f_value.text))
	
	if not already_exists:
		list_facts.add_item(f_id.text)
		list_facts.sort_items_by_text()

func delete():
	#Make sure the ID actually exists
	if not Data.exists(DATA_TYPE, f_id.text):
		print("That fact ID doesn't exist, so it cannot be deleted")
		return
		
	Data.delete_key(DATA_TYPE, f_id.text)
	
	for index in range(0, list_facts.item_count):
		if list_facts.get_item_text(index) == f_id.text:
			list_facts.remove_item(index)
			break

func validate() -> bool:
	var alert_message = ""
	
	#Make sure crucial fields are not blank
	if f_id.text == "":
		alert_message = "The 'ID' field cannot be blank"
	elif f_value.text == "":
		alert_message = "The 'Value' field cannot be blank"
	elif not f_value.text.is_valid_float():
		alert_message = "The 'Value' field must contain a number"
	
	if alert_message != "":
		print(alert_message)
		return false
		
	return true

func reset_fact_list(filter_text: String):
	list_facts.clear()
	
	if filter_text == "":
		for key in Data.get_entire_dict(DATA_TYPE).keys():
			list_facts.add_item(key)
	else:
		for key in Data.get_entire_dict(DATA_TYPE).keys():
			if filter_text in key:
				list_facts.add_item(key)
		
	list_facts.sort_items_by_text()

func on_search_bar_text_changed(new_text):
	reset_fact_list(new_text)

func on_fact_list_item_clicked(index, at_position, mouse_button_index):
	var id = list_facts.get_item_text(index)
	
	if id == null or id == "":
		print("That ID cannot be retrieved from the list")
		return
	
	if not Data.exists(DATA_TYPE, id):
		print("That ID does not exist in the data dict")
		return

	var data = Data.get_value(DATA_TYPE, id)
	
	f_id.text = id
	f_value.text = str(data)
