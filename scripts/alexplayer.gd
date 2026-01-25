extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 1200.0
const coyote_time = 0.3
const max_jump_amount = 2
var health = 0

var dashing = false
var can_dash = true
var coyote = false
var was_on_floor = true
var jumping = false
var jump_amount = max_jump_amount
@onready var healthbar = $CanvasLayer/HealthBar
@onready var damage_timer = $damage_timer
@onready var coyote_timer: Timer = $coyote_timer

func _ready():
	health = 100
	healthbar.init_health(health)
	coyote_timer.set_wait_time(coyote_time) #assigns the coyote timers duration
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		$dash_duration_timer.start()
		$dash_cooldown_timer.start()
		can_dash = false
	
	# Handle jump.
	
	#saves if the player was on the floor or not in the last frame
	was_on_floor = is_on_floor()
	
	move_and_slide()
	
	#resets jump status after landing in the floor
	if is_on_floor():
		jumping = false
		coyote_timer.stop()
		jump_amount = max_jump_amount
		
	#jump action
	if Input.is_action_just_pressed("jump") and (jump_amount > 0 or is_on_floor() or coyote):
			velocity.y = JUMP_VELOCITY
			jumping = true
			coyote = false
			jump_amount -= 1
			print("-1")
			print(jump_amount)
	
	#starts coyote timer after falling of a ledge
	if !is_on_floor() and was_on_floor and !jumping:
		coyote = true
		coyote_timer.start()
		print("coyote")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walk_left", "walk_right")
	
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
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
	print("no coyote")
