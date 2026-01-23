extends CharacterBody2D

@export var speed = 50
@onready var animated_sprite = $AnimatedSprite2D

var player: CharacterBody2D
var isClose = false

func _ready():
	# Find player by group (assign "Player" group to your player in editor)
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	# Exit early if player or sprite is invalid
	if not is_instance_valid(player) or not is_instance_valid(animated_sprite):
		return

	# Only apply movement if isClose is true
	if isClose:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		animated_sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO  # Stop moving when not close

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		isClose = true  
