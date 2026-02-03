extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1200.0
var health = 0
var can_take_damage: bool = true

var dashing = false
var can_dash = true
@onready var healthbar = $CanvasLayer/Node2D/HealthBar
@onready var timer = $Timer 
@onready var screenShake = get_parent()

func _ready():
	health = 5
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		$dash_timer.start()
		$dash_again_timer.start()
		can_dash = false
		
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Horizontal movement
	var direction := Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = direction * (DASH_SPEED if dashing else SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Take damage and start invincibility
func take_damage(amount):
	health = max(0, health - amount)
	healthbar._set_health(health)
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/map.tscn")

# Check for overlapping enemies every frame
func _process(delta):
	if !can_take_damage:
		return
	var overlapping_areas = $Area2D.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("enemy"):
			screenShake.apply_noise_shake()
			take_damage(1)
			can_take_damage = false
			timer.start()
			break

func _on_dash_timer_timeout() -> void:
	dashing = false 

func _on_dash_again_timer_timeout() -> void:
	can_dash = true

# Invincibility ends, allow damage again
func _on_timer_timeout() -> void:
	can_take_damage = true   
