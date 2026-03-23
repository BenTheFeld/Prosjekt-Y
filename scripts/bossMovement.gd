extends CharacterBody2D

@export var speed = 100
@export var gravity = 980 

# Last inn scenene først
@onready var longattack_scene = preload("res://scenes/boss_projectile.tscn") 
@onready var closeattack_scene = preload("res://scenes/closeattack_projectile.tscn") 

# Denne holder styr på hvilket prosjektil som skal brukes akkurat nå
var current_bullet_scene: PackedScene

@onready var animated_sprite = $Sprite2D
@onready var ui = $Sprite2D/CanvasLayer

var player: CharacterBody2D
var is_near_player = false # Brukes for bevegelse/UI

func _ready():
	# Sett standard angrep med en gang
	current_bullet_scene = longattack_scene
	
	player = get_tree().get_first_node_in_group("player")
	
	# Timer-oppsett
	var shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 1.0
	shoot_timer.one_shot = false
	shoot_timer.autostart = true
	shoot_timer.timeout.connect(shoot)
	shoot_timer.start()

func _physics_process(delta):
	# 1. Tyngdekraft
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 10 

	# 2. Bevegelse (Går mot spilleren hvis is_near_player er true)
	if is_instance_valid(player) and is_near_player:
		var dir_x = sign(player.global_position.x - global_position.x)
		velocity.x = dir_x * speed
		
		if dir_x != 0:
			animated_sprite.flip_h = dir_x > 0
		
		ui.show()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		ui.hide()

	move_and_slide()

func shoot():
	# Skyter bare hvis spilleren finnes og bossen er "aktiv" (nær spilleren)
	if is_instance_valid(player) and is_near_player:
		if current_bullet_scene:
			var b = current_bullet_scene.instantiate()
			b.global_position = global_position
			var dir = (player.global_position - global_position).normalized()
			
			# Sjekk om prosjektilet har disse variablene før vi setter dem
			if "direction" in b:
				b.direction = dir
			b.rotation = dir.angle()
			
			get_tree().root.add_child(b)

# --- SIGNALER ---

# Når spilleren er nærme nok til å bli skutt på med "CLOSE" attack
func _on_close_attack_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		current_bullet_scene = closeattack_scene
		print("Byttet til: Nærkamp-skudd")

# Når spilleren går lenger unna, bytt tilbake til "LONG" attack
func _on_close_attack_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		current_bullet_scene = longattack_scene
		print("Byttet til: Langdistanse-skudd")

# Denne styrer om bossen i det hele tatt skal bevege seg/skyte
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_near_player = true
