extends CharacterBody2D

@export var speed = 100        # Bumped speed up a bit
@export var gravity = 980 
@onready var animated_sprite = $Sprite2D
@onready var ui = $Sprite2D/CanvasLayer
@onready var bullet_scene = preload("res://scenes/boss_projectile.tscn") 

var player: CharacterBody2D
var isClose = true # Set to true by default so he moves immediately

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	var shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 1.0
	shoot_timer.one_shot = false
	shoot_timer.autostart = true
	shoot_timer.timeout.connect(shoot)
	shoot_timer.start()

func _physics_process(delta):
	# 1. Gravity Logic
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Keeps him snapped to the floor without building up infinite gravity
		velocity.y = 10 

	# 2. Movement Logic
	if is_instance_valid(player) and isClose:
		# Get direction (-1 for Left, 1 for Right)
		var dir_x = sign(player.global_position.x - global_position.x)
		
		# Set horizontal velocity
		velocity.x = dir_x * speed
		
		# Flip Sprite
		if dir_x != 0:
			animated_sprite.flip_h = dir_x < 0
		
		ui.show()
	else:
		# Slow down to a stop if player is gone or out of range
		velocity.x = move_toward(velocity.x, 0, speed)
		ui.hide()

	# 3. Final Movement
	move_and_slide()

func shoot():
	if is_instance_valid(player) and isClose:
		var b = bullet_scene.instantiate()
		b.global_position = global_position
		var dir = (player.global_position - global_position).normalized()
		b.direction = dir
		b.rotation = dir.angle()
		get_tree().root.add_child(b)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		isClose = true
