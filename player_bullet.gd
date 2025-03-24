extends Area2D

@export var speed := 400

func _process(delta: float) -> void:
	position += Vector2.RIGHT * speed * delta
	
	if position.x > 2000:
		queue_free()

func _on_area_entered(area: Area2D):
	print("COLLISION")
	if area.is_in_group("enemy"):
		area.queue_free()    # kill the enemy
		queue_free()         # destroy the bullet too
