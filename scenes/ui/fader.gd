extends Node2D

func fade_in():
	States.change_state(States.STATE.CUTSCENE, "fade")
	
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished

func fade_out():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	
	States.change_state(States.STATE.PLAYING)
	
	queue_free()
