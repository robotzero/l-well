extends ColorRect

@export var twinkle_speed := 1.5
@export var twinkle_offset := 0.0


func _process(delta: float) -> void:
	var alpha = 0.5 + 0.5 * sin(Time.get_ticks_msec() / 1000.0 * twinkle_speed + twinkle_offset)
	self.modulate.a = alpha
