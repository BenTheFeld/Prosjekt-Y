extends AnimatedSprite2D

@onready var healthbar = $HealthBar

var health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100
	healthbar.init_health(health)

func take_damage(amount):
	health = max(0, health - amount)
	healthbar._set_health(health)
	
	if health <= 0:
		queue_free() 

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		take_damage(20)  
		print("Enemy damaged")
		
