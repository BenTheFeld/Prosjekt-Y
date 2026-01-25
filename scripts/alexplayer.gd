extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 800.0
const coyote_time = 0.3
const max_jump_amount = 2

var health = 0
var last_direction = 1
var dashing = false
var can_dash = true
var coyote = false
var was_on_floor = true
var was_on_wall
var jumping = false
var jump_amount = max_jump_amount
@onready var healthbar = $CanvasLayer/HealthBar
@onready var damage_timer = $damage_timer
@onready var coyote_timer: Timer = $coyote_timer
@onready var character_sprite: Sprite2D = $character_sprite
@onready var hands_sprite: Sprite2D = $character_sprite/hands_sprite

func _ready():
	health = 100
	healthbar.init_health(health)
	coyote_timer.set_wait_time(coyote_time) #assigns the coyote timers duration
	
func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("walk_left", "walk_right")
	
	if direction != 0:
		last_direction = direction
		
	if last_direction > 0:
		hands_sprite.flip_h = true
	
	if last_direction < 0:
		hands_sprite.flip_h = false
		
	if dashing:
		velocity.x = last_direction * DASH_SPEED
	else:
		velocity.x = direction * SPEED

	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		$dash_duration_timer.start()
		$dash_cooldown_timer.start()
		can_dash = false
	
	# Handle jump.
	
	#saves if the player was on the floor or not in the last frame
	was_on_floor = is_on_floor()
	
	was_on_wall = is_on_wall_only()
	
	move_and_slide()
	
	#resets jump status after landing in the floor
	if is_on_floor():
		jumping = false
		coyote_timer.stop()
		jump_amount = max_jump_amount
	
	#slows the players decent when colliding with a wall
	if is_on_wall() and last_direction == direction and !jumping:
		velocity = get_gravity() * delta * 0.5
		hands_sprite.visible = true
	else:
		hands_sprite.visible = false
		velocity += get_gravity() * delta
	
	#when the player touches a wall they gain a jump
	if is_on_wall_only() and !was_on_wall:
		jump_amount = 1
		jumping = false
		
	#jump action
	if Input.is_action_just_pressed("jump") and (jump_amount > 0 or is_on_floor() or coyote):
			velocity.y = JUMP_VELOCITY
			jumping = true
			coyote = false
			jump_amount -= 1
	
	#starts coyote timer after falling of a ledge
	if !is_on_floor() and was_on_floor and !jumping:
		coyote = true
		coyote_timer.start()
	
func take_damage(amount):
	health = max(0, health - amount)
	healthbar._set_health(health)
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_dash_timer_timeout() -> void:
	dashing = false 

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):   
		damage_timer.start()
		take_damage(10)
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		damage_timer.stop()

#when the coyote timer runs out stops the player from jumping
func _on_coyote_timer_timeout():
	coyote = false
