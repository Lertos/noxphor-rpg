extends Resource
class_name Character

@export var name: String
@export var id: String
@export_flags("Attack", "Talk", "Pickpocket", "Give" ,"Leave") var options = 0

func print_flags():
	print(str(options))
