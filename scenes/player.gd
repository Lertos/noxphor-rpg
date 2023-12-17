extends CharacterBody2D

const SPEED: float = 100.0

var is_talking: bool = false
var colliding_areas = []

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_vector = input_vector.normalized()
	
	if input_vector:
		velocity = input_vector * SPEED
		
		#Very naive approach; should be replaced by a AnimTree once you have walk anims
		if velocity.x > 0:
			$Main.frame = 2
		elif velocity.x < 0:
			$Main.frame = 1
		elif velocity.y > 0:
			$Main.frame = 0
		elif velocity.y < 0:
			$Main.frame = 3
	else:
		velocity = input_vector
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("action"):
		for area in $Area2D.get_overlapping_areas():
			if area.has_method("interact"):
				area.interact()

func on_area_entered(area):
	colliding_areas.append(area)

func on_area_exited(area):
	colliding_areas.erase(area)
