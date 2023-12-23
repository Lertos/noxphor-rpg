extends Resource
class_name Character

@export var name: String
@export var id: String :
	get:
		return id
	set(value):
		if not Enums.character_ids.has(value):
			assert(false, "The character_id: '" + value + "' does not exist in the list of IDs")
		id = value
@export var level: int = 1 :
	get:
		return level
	set(value):
		level = clamp(value, 1, 1000)

@export var interact_options: Array[Enums.CHARACTER_INTERACT_OPTIONS] :
	get:
		return interact_options
	set(value):
		for i in range(0, len(value)):
			for k in range(i + 1, len(value)):
				if value[i] == value[k]:
					assert(false, name + " character resource has duplicate interact options")
		interact_options = value

func print_flags():
	print(str(interact_options))
