extends Node2D

@export var resource: Character

func interact():
	var options = []
	
	for option in resource.interact_options:
		options.append(Enums.CHARACTER_INTERACT_OPTIONS.keys()[option])

	Nodes.Root.spawn_interact_popup(self.position, resource.id, options)
