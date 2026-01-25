extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 600.0 + SPEED
const COYOTE_TIME = 0.3
const MAX_JUMP_AMOUNT = 2

var health = 0
var last_direction = 1
var dashing = false
var can_dash = true
var coyote = false
var was_on_floor = true
var was_on_wall
var jumping = false
var jump_amount = MAX_JUMP_AMOUNT
var dash_ready = true
var walljump_ready = false
var walljumping = false
@onready var healthbar = $CanvasLayer/HealthBar
@onready var damage_timer = $damage_timer
@onready var coyote_timer: Timer = $coyote_timer
@onready var character_sprite: Sprite2D = $character_sprite
@onready var hands_sprite: Sprite2D = $character_sprite/hands_sprite

func _ready():
	health = 100
	healthbar.init_health(health)
	coyote_timer.set_wait_time(COYOTE_TIME) #assigns the coyote timers duration
	
func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("walk_left", "walk_right")
	var mouse_direction = get_local_mouse_position().normalized()
	
	#records the last direction
	if direction != 0:
		last_direction = direction
	
	#points the character to the right when going right
	if last_direction > 0:
		hands_sprite.flip_h = true
		
	#points the character to the left when going left
	if last_direction < 0:
		hands_sprite.flip_h = false
	
	#moves player
	if direction and !dashing and !walljumping:
		velocity.x = direction * SPEED
	else: 
		velocity.x = move_toward(velocity.x, 0, 40)

	#triggers dashes
	if Input.is_action_just_pressed("dash") and can_dash and dash_ready:
		#velocity.x = last_direction * DASH_SPEED
		dash_ready = false
		velocity = mouse_direction * DASH_SPEED
		dashing = true
		can_dash = false
		$dash_duration_timer.start()
		$dash_cooldown_timer.start()
		
	# Handle jump.
	
	#saves if the player was on the floor or not in the last frame
	was_on_floor = is_on_floor()
	
	was_on_wall = is_on_wall_only()
	
	move_and_slide()
	
	#resets jump status after landing in the floor
	if is_on_floor():
		jumping = false
		walljump_ready = false
		walljumping = false
		coyote_timer.stop()
		jump_amount = MAX_JUMP_AMOUNT
		dash_ready = true
	
	#slows the players decent when colliding with a wall
	if is_on_wall() and last_direction == direction and !jumping:
		velocity = get_gravity() * 0.5
		hands_sprite.visible = true
		#walljumps
		if Input.is_action_just_pressed("jump") and walljump_ready:
			velocity = mouse_direction * DASH_SPEED
			jumping = true
			jump_amount -= 1
			coyote = false
			walljump_ready = false
			walljumping = true
	else:
		hands_sprite.visible = false
		velocity += get_gravity()
	
	#when the player touches a wall they gain a jump
	if is_on_wall_only() and !was_on_wall:
		walljump_ready = true
		jumping = false
		walljumping = false
		
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
