extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1200.0
var health = 0

var dashing = false
var can_dash = true
@onready var healthbar = $CanvasLayer/HealthBar
@onready var timer = $Timer 

func _ready():
	health = 100
	healthbar.init_health(health)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		$dash_timer.start()
		$dash_again_timer.start()
		can_dash = false
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
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



	move_and_slide()

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
		print("Damaged")   
		timer.start()
		take_damage(10)
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		timer.stop()

func _on_timer_timeout() -> void:
	take_damage(20)
