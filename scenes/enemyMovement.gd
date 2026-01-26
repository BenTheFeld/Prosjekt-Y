extends CharacterBody2D

@export var speed = 150
@onready var animated_sprite = $AnimatedSprite2D

var player: CharacterBody2D
var isClose = false

func _ready():
	#finne player
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	# Exit vis ting ikke funker
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
	print("close")
	
	if area.is_in_group("player"):
		isClose = true  
		print("closeerrr")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("close")
	
	if body.is_in_group("player"):
		isClose = true  
		print("closeerrr")
