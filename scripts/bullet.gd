extends Node2D

const SPEED = 300

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
