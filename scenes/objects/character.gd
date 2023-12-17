extends Node2D

@export var resource: Character

func interact():
	print(resource.name)
	
	for option in resource.interact_options:
		print(Enums.CHARACTER_INTERACT_OPTIONS.keys()[option])
