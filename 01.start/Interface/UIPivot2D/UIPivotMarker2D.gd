extends Marker2D


@export var shake_strength := 20.0
@export var min_shake_duration := 0.1
@export var max_shake_duration := 0.5

@onready var timer := $Timer

@onready var pivot := $Pivot2D
@onready var initial_position: Vector2 = pivot.position

func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	pivot.position.x = randf_range(-shake_strength, shake_strength)
	pivot.position.y = randf_range(-shake_strength, shake_strength)


func shake(strength := shake_strength) -> void:
	set_process(true)
	timer.start(randf_range(min_shake_duration, max_shake_duration))


func stop() -> void:
	set_process(false)
	pivot.position = initial_position
	timer.stop()


func _on_timer_timeout() -> void:
	stop()
