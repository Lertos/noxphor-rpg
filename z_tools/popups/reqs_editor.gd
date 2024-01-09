extends PopupPanel

@onready var f_fact = $H/Right/Fields/Fact/Fact
@onready var f_operator = $H/Right/Fields/Operator/Operator
@onready var f_value = $H/Right/Fields/Value/Value
@onready var list_reqs = $H/Reqs

var reqs = []
var selected_index = -1

func open(reqs: Array):
	self.reqs = reqs
	
	list_reqs.clear()
	selected_index = -1
	
	for index in range(0, reqs.size()):
		list_reqs.add_item(reqs[index]["fact"])
	
	popup_centered_ratio(0.8)

func on_reqs_item_selected(index):
	var req = list_reqs.get_item_text(index)
	
	if req == null or req == "":
		print("That req doesn't exist in the list")
		return
	
	var dict = reqs[index]
	
	f_fact.text = dict["fact"]
	f_value.text = dict["value"]
	
	for i in range(0, f_operator.item_count):
		var item_text = f_operator.get_item_text(i)
		
		if dict["operator"] == item_text:
			f_operator.select(i)
	
	selected_index = index

func on_add_pressed():
	if f_fact == "":
		print("The fact field cannot be empty")
		return
	if f_value == "":
		print("The value field cannot be empty")
		return
	
	var dict = {}
	
	dict["fact"] = f_fact.text
	dict["operator"] = f_operator.get_item_text(f_operator.get_selected_id())
	dict["value"] = f_value.text
	
	for index in range(0, reqs.size()):
		var compare_dict = reqs[index]
		
		if compare_dict["fact"] == dict["fact"] \
		and compare_dict["operator"] == dict["operator"] \
		and compare_dict["value"] == dict["value"]:
			print("There is already a req with those exact values")
			return
			
	reqs.append(dict)
	list_reqs.add_item(dict["fact"])
	
	selected_index = list_reqs.item_count - 1

func on_update_pressed():
	if selected_index >= reqs.size():
		print("The selected index no longer exists")
		return
		
	reqs[selected_index] = f_req.text
	
	list_reqs.set_item_text(selected_index, f_req.text)

func on_delete_pressed():
	if selected_index == -1 or selected_index >= reqs.size():
		print("The selected index no longer exists")
		return
		
	reqs.remove_at(selected_index)
	list_reqs.remove_item(selected_index)
	
	f_req.text = ""
	selected_index = -1

func on_popup_hide():
	get_parent().reqs = reqs
