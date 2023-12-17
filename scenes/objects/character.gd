extends Node2D

@export var resource: Character

func interact():
	var options = []
	
	print(resource.name)
	
	for option in resource.interact_options:
		options.append(Enums.CHARACTER_INTERACT_OPTIONS.keys()[option])

	get_tree().get_root().get_node("root").spawn_interact_popup(self.position, options)
