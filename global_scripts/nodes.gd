extends Node

#The entire idea of this singleton is to reference commonly used nodes
#from a single method call / variable where you know the paths will
#always be the same, or if it changes, you only need to change it here

@onready var root_node = get_tree().get_root().get_node("root")
@onready var event_manager = root_node.get_node("EventManager")

func camera():
	var node = root_node.get_node("Level").get_child(0)

	if node.has_node("Player"):
		node = node.get_node("Player")
		
		if node.has_node("Camera"):
			node = node.get_node("Camera")
	
	if node == null:
		assert(false, "nodes.gd/camera - Cannot find camera node")
	
	return node
