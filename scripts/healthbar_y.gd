extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

const SMOOTH_SPEED := 24.0

var health := 0 : set = _set_health
var target_health := 0 

func _process(delta):
	if damage_bar.value > value:
		damage_bar.value = move_toward(damage_bar.value, value, SMOOTH_SPEED * delta)

func _set_health(new_health):
	health = clamp(new_health, 0, max_value)
	value = health 

	if health < target_health:
		timer.start()

func init_health(start_health):
	health = start_health
	target_health = start_health
	max_value = start_health

	value = start_health
	damage_bar.max_value = start_health
	damage_bar.value = start_health

func _on_timer_timeout():
	target_health = value
	
