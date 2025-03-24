extends CharacterBody2D

@export var speed := 200.0
@export var bullet_scene : PackedScene
@export var shoot_cooldown := 0.2

@onready var bullet_spawn := $BulletSpawn

var can_shoot := true

func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	velocity = input.normalized() * speed
	move_and_slide()

	if Input.is_action_pressed("fire") && can_shoot:
		fire_bullet()

func fire_bullet() -> void:
	can_shoot = false

	var bullet = bullet_scene.instantiate()
	bullet.position = bullet_spawn.global_position
	get_tree().current_scene.add_child(bullet)
	
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
	
