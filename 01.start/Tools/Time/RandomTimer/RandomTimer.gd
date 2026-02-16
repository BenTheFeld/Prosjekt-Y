extends Timer

@export_range(0.0, 10.0, 0.05,"or_greater", "suffix: seconds") var min_wait_time := 0.1
@export_range(0.0, 10.0, 0.05,"or_greater", "suffix: seconds") var max_wait_time := 1.0


func _ready() -> void:
	if autostart:
		start_random()


func _on_timeout() -> void:
	if not one_shot:
		start_random()


func start_random(_min_wait_time := min_wait_time, _max_wait_time := max_wait_time) -> void:
	var random_wait_time := randf_range(_min_wait_time, _max_wait_time)
	start(random_wait_time)
