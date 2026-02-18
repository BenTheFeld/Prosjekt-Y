extends Sprite2D

@export var speed = 300
@export var shootRange = 500 

var direction = Vector2.ZERO
var start_position: Vector2

func _ready():
	add_to_group("projectile")
	start_position = global_position 

func _process(delta: float) -> void:
	# Move in the assigned direction (Rotation is already set by the Boss)
	global_position += direction * speed * delta

	# Destroy the bullet if it goes past its range
	if global_position.distance_to(start_position) > shootRange:
		queue_free()

# If your projectile is an Area2D, connect the area_entered signal here


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()
