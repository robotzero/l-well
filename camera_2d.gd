extends Camera2D

@export var scroll_speed := Vector2(50, 0)

func _process(delta: float) -> void:
	offset += scroll_speed * delta
