extends Node

# To use this manager, call the "handle" function, giving a full event ID.
#
# 1. The "handle" function then finds the correct function to call and passes the ID to it
# 2. That function then captures the rest of the data from the event string
# 3. This manager then calls another manager to handle the event further

const SEPARATOR = "::"

#NOTE: This list will always be incomplete, and such, it can be added to anytime if needed
var event_ids = {
	#Each key contains the func to call, or a dict to sub queries, which contain deeper func's to call
	"player": {
		"give": "give_item"
	},
	"talk": "handle_talk"
}

#An event ID, such as "player::give::<item_id>" is broken down and sent to the proper function
func handle(event_id: String):
	#If there are no separators, then it is a bad event call
	var event_parts = event_id.split(SEPARATOR)
	
	if event_parts.size() == 0:
		print("event_manager.gd - A bad event call was made (no separators): " + event_id)
		return
	
	#If the first ID doesn't exist, then return
	if not event_ids.has(event_parts[0]):
		print("event_manager.gd - A bad event call was made (no existing parent key): " + event_id)
		return
		
	var current_value = event_ids[event_parts[0]]
	
	#Filter through each separator until you find a function call
	for index in range(1, event_parts.size()):
		#Check that the value is a proper type 
		if not (current_value is Dictionary or current_value is String):
			print("event_manager.gd - A bad event call was made (a child key has the wrong type): " + event_id)
			return
			
		#If the current value is a dictionary, get the new value
		if current_value is Dictionary:
			if not current_value.has(event_parts[index]):
				print("event_manager.gd - A bad event call was made (no existing child key): " + event_id)
				return
				
			current_value = current_value[event_parts[index]]
			
			#If it is now a String, then we must pass the rest of the array
			if current_value is String:
				call_method(current_value, event_parts.slice(min(index + 1, event_parts.size()), event_parts.size()))
				break
			
		elif current_value is String:
			call_method(current_value, event_parts.slice(index, event_parts.size()))
			break

func call_method(func_name: String, remaining_parts: Array):
	print("==Call Method")
	print(func_name)
	print(remaining_parts)
	print()
