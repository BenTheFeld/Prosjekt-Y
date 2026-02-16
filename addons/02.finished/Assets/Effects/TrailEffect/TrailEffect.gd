class_name TrailEffect
extends Node2D

signal disappeared

@onready var line_one := $Line2D
@onready var line_two := $Line2D2

@export var resolution := 10.0
@export var length := 50

var last_point: Vector2


func _ready() -> void:
	reset()
	set_process(false)


func reset() -> void:
	line_one.clear_points()
	line_two.clear_points()
	last_point = global_position


func start() -> void:
	last_point = global_position
	line_one.add_point(line_one.to_local(global_position))
	line_two.add_point(line_two.to_local(global_position))
	set_process(true)


func stop() -> void:
	set_process(false)
	while line_one.points.size() > 0:
		line_one.remove_point(0)
		line_two.remove_point(0)
		await get_tree().process_frame
	disappeared.emit()


func _process(delta: float) -> void:
	var distance = global_position.distance_to(last_point)
	if distance >= resolution:
		if line_one.points.size() >= length:
			line_one.remove_point(0)
			line_two.remove_point(0)
		
		line_one.add_point(line_one.to_local(global_position))
		line_two.add_point(line_two.to_local(global_position))
		last_point = global_position
