extends Node
class_name CommandManager

# This manager parses and executes commands based on given parts
#
# 1. The "execute" function finds the correct function to call and passes the ID to it
# 2. That function then captures the rest of the data from the command string and executes code for that command

const SEPARATOR = " "

#NOTE: This list will always be incomplete, and such, it can be added to anytime if needed
const commands = {
	"fact": {
		"increment": "increment_fact",
		"set": "set_fact"
	},
	"factt": "fact_test"
}

#A command string, such as "fact set <fact_id> <value>" is broken down and sent to the proper function
func execute(event_id: String):
	var event_parts = event_id.split(SEPARATOR)

	if not commands.has(event_parts[0]):
		print("command_manager.gd - A bad event call was made (no existing parent key): " + event_id)
		return
		
	var current_value = commands[event_parts[0]]

	#Filter through each separator until you find a function call
	for index in range(1, event_parts.size()):
		#Check that the value is a proper type 
		if not (current_value is Dictionary or current_value is String):
			print("command_manager.gd - A bad event call was made (a child key has the wrong type): " + event_id)
			return

		#If the current value is a dictionary, get the new value
		if current_value is Dictionary:
			if not current_value.has(event_parts[index]):
				print("command_manager.gd - A bad event call was made (no existing child key): " + event_id)
				return

			current_value = current_value[event_parts[index]]
			
			#If it is now a String, then we must pass the rest of the array
			if current_value is String:
				call_method(current_value, event_parts.slice(min(index + 1, event_parts.size()), event_parts.size()))
				return

		#Check if the value for the key is a string, if so it is the function name
		elif current_value is String:
			call_method(current_value, event_parts.slice(index, event_parts.size()))
			return
			
	call_method(current_value)

func call_method(func_name: String, remaining_parts := []):
	print("==Call Method")
	print(func_name)
	print(remaining_parts)
