extends CharacterBody2D

@export var speed := 200.0
@export var bullet_scene : PackedScene

func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	velocity = input.normalized() * speed
	move_and_slide()
	
	
