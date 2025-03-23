extends CharacterBody2D

@export var speed := 100.0
@export var amplitude := 40.0
@export var frequency := 2.0
@export var move_direction := Vector2.LEFT
@export var wave_offset := 0.0
@export var movement_type: String = "linear"

# Spiral/Arc params
@export var radius_speed: float = 30.0      # for spiral
@export var angle_speed: float = 2.0        # radians per second
@export var start_angle: float = 0.0
@export var initial_radius: float = 100.0

var time := 0.0
var center_point := Vector2.ZERO  # used for spiral/arc

func _ready() -> void:
	center_point = position

func _physics_process(delta: float) -> void:
	time += delta
	
	match movement_type:
		"linear":
			velocity = move_direction * speed
			move_and_slide()

		"sine":
			var base_movement := move_direction * speed
			var wave_y := sin(time * frequency + wave_offset) * amplitude
			velocity = base_movement
			position.y += wave_y * delta
			move_and_slide()

		"spiral", "arc":
			var radius := initial_radius + (radius_speed * time if movement_type == "spiral" else 0.0)
			var angle := start_angle + angle_speed * time
			position = center_point + Vector2(cos(angle), sin(angle)) * radius
	
	if position.x < -100:
		queue_free()
	
