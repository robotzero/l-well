extends Node2D

@export var enemy_scene: PackedScene
@onready var enemy_container := $Enemies
@export var camera := Camera2D

var wave_timer := 0.0
var level_length := 60.0
var time_passed := 0.0
var current_wave_index := 0

var wave_schedule := [
	{
		"time": 2.0,
		"type": "horizontal",
		"count": 5,
		"start_pos": Vector2(600, 0)
	},
	{
		"time": 6.0,
		"type": "snake",
		"count": 6,
		"start_pos": Vector2(600, 0),
		"spacing": 40
	},
	{
		"time": 10.0,
		"type": "vertical",
		"count": 4,
		"start_pos": Vector2(600, 0),
		"spacing": 60
	},
	{
		"time": 12.0,
		"type": "spiral",
		"pos": Vector2(600, 400),
		"clockwise": true
	},
	#{
		#"time": 16.0,
		#"type": "arc",
		#"pos": Vector2(600, 400),
		#"clockwise": true
	#}
]

func _process(delta: float) -> void:
	time_passed += delta
	wave_timer += delta
	
	if current_wave_index < wave_schedule.size():
		var wave = wave_schedule[current_wave_index]
		#var wave = wave_schedule[3]
		if wave_timer >= wave["time"]:
			spawn_wave_from_data(wave)
			current_wave_index += 1
		
	if current_wave_index >= wave_schedule.size():
		wave_timer = 0.0
		current_wave_index = 0
	
	if time_passed >= level_length:
		game_over()
		
func game_over() -> void:
	get_tree().quit()
	
func spawn_wave_from_data(wave: Dictionary) -> void:
	match wave["type"]:
		"horizontal":
			spawn_wave_horizontal(
				wave.get("count", 5),
				wave.get("offset", Vector2(600, 0))
			)
		"vertical":
			spawn_wave_vertical(
				wave.get("count", 5),
				wave.get("offset", Vector2(600, 0)),
				wave.get("spacing", 50)
			)
		"snake":
			spawn_wave_snake(
				wave.get("count", 5),
				wave.get("offset", Vector2(600, 0)),
				wave.get("spacing", 50)
			)
		"spiral":
			spawn_spiral_enemy(
				get_camera_world_position() + wave.get("pos", Vector2.ZERO),
				wave.get("clockwise", true)
			)
		_:
			print("Unknown wave type:", wave["type"])	
	
func spawn_wave_horizontal(count: int, offset: Vector2):
	var cam_pos := get_camera_world_position()
	var start_pos = cam_pos + offset
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		enemy.position = start_pos + Vector2(i * 40, 0)
		enemy.wave_offset = i * 0.4
		enemy.frequency = 3.0
		enemy.amplitude = 20.0
		enemy.speed = 30
		enemy_container.add_child(enemy)

func spawn_wave_vertical(count: int, offset: Vector2, spacing: float):
	var cam_pos := get_camera_world_position()
	var start_pos = cam_pos + offset
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		enemy.position = start_pos + Vector2(0, i * spacing)
		enemy.wave_offset = i * 0.5
		enemy.frequency = 2.5
		enemy.amplitude = 30.0
		enemy.speed = 30
		enemy_container.add_child(enemy)
		
func spawn_wave_snake(count: int, offset: Vector2, spacing: float):
	var cam_pos := get_camera_world_position()
	var start_pos = cam_pos + offset
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		enemy.position = start_pos + Vector2(i * spacing, i * 10)  # diagonal snake
		enemy.wave_offset = i * 0.6
		enemy.frequency = 4.0
		enemy.amplitude = 40.0
		enemy.speed = 30
		enemy_container.add_child(enemy)
		
func spawn_spiral_enemy(pos: Vector2, clockwise := true):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemy.center_point = pos
	enemy.movement_type = "spiral"
	enemy.initial_radius = 0
	enemy.radius_speed = 50
	enemy.angle_speed = 2.0 if clockwise else -2.0
	enemy.start_angle = 0.0
	enemy_container.add_child(enemy)

func spawn_arc_enemy(pos: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemy.center_point = pos
	enemy.movement_type = "arc"
	enemy.initial_radius = 100
	enemy.angle_speed = 2.0
	enemy.start_angle = PI / 2
	enemy_container.add_child(enemy)


func get_camera_world_position() -> Vector2:
	return camera.global_position + camera.offset
