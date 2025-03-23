extends ParallaxLayer

@export var star_count := 100
@export var size := Vector2(2000, 1200)

func _ready():
	motion_scale = Vector2(0.3, 0.3)
	_generate_stars(1, Color.WHITE)

func _generate_stars(size_px: int, color: Color):
	var rng = RandomNumberGenerator.new()
	for i in range(star_count):
		var star = ColorRect.new()
		star.color = color
		star.size = Vector2(size_px, size_px)
		star.position = Vector2(rng.randi_range(0, size.x), rng.randi_range(0, size.y))
		
		# Add twinkling script
		var twinkle_script := preload("res://star_twinkle.gd")
		star.set_script(twinkle_script)
		star.set("twinkle_speed", rng.randf_range(1.0, 3.0))
		star.set("twinkle_offset", rng.randf_range(0.0, TAU))
		
		add_child(star)
