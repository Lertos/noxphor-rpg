extends PopupPanel

@onready var f_req = $H/Right/Fields/Req/Req
@onready var list_reqs = $H/Reqs

var reqs = []
var selected_index = -1

func open(reqs: Array):
	self.reqs = reqs
	
	list_reqs.clear()
	selected_index = -1
	
	for index in range(0, reqs.size()):
		list_reqs.add_item(reqs[index])
	
	popup_centered_ratio(0.8)

func on_reqs_item_selected(index):
	var req = list_reqs.get_item_text(index)
	
	if req == null or req == "":
		print("That req doesn't exist in the list")
		return
		
	f_req.text = req
	selected_index = index

func on_add_pressed():
	var new_req = f_req.text
	
	if new_req == "":
		print("The req field cannot be empty")
		return
		
	for index in range(0, reqs.size()):
		if new_req == reqs[index]:
			print("There is already a req with that exact value")
			return
			
	reqs.append(new_req)
	list_reqs.add_item(new_req)
	
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
