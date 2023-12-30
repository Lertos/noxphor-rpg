extends Node

#This singleton is used to reference common nodes using a single variable/method.
#The paths will always be the same, or if it changes, you only need to change it here.

@onready var Root = get_tree().get_root().get_node("root")
@onready var Event = EventManager.new()

func camera():
	var node = Root.get_node("Level").get_child(0)

	if node.has_node("Player"):
		node = node.get_node("Player")
		
		if node.has_node("Camera"):
			node = node.get_node("Camera")
	
	if node == null:
		assert(false, "nodes.gd/camera - Cannot find camera node")
	
	return node
