extends CharacterBody2D

@onready var anim_tree: AnimationTree = $AnimationTree

const SPEED: float = 100.0

var input_vector: Vector2 = Vector2.ZERO

func _process(delta):
	update_anim_conditions()

func _physics_process(delta):
	if not States.is_state(States.STATE.PLAYING):
		return
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_vector = input_vector.normalized()
	
	if input_vector:
		velocity = input_vector * SPEED
	else:
		velocity = input_vector
		
	move_and_slide()

func _input(event):
	if not States.is_state(States.STATE.PLAYING):
		return
		
	if event.is_action_pressed("action"):
		for area in $Area2D.get_overlapping_areas():
			if area.has_method("interact"):
				area.interact()

func update_anim_conditions():
	if velocity == Vector2.ZERO or not States.is_state(States.STATE.PLAYING):
		anim_tree["parameters/conditions/is_idle"] = true
		anim_tree["parameters/conditions/is_moving"] = false
	else:
		anim_tree["parameters/conditions/is_idle"] = false
		anim_tree["parameters/conditions/is_moving"] = true
	
	if input_vector != Vector2.ZERO:
		anim_tree["parameters/Idle/blend_position"] = input_vector
		anim_tree["parameters/Run/blend_position"] = input_vector
