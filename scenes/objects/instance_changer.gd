extends Area2D

@export_file var scene_to_load: String

#TODO: In the scene that is being changed to, you need to have some spawn points and 
#then load the player into those spawn points based on the previous scene

func on_body_entered(body):
	if body.name == "Player":
		if scene_to_load != null:
			Nodes.Root.change_maps(self.get_parent(), scene_to_load)
