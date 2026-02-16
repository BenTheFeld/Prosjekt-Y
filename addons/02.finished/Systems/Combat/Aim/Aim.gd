@tool
class_name Aim2D
extends Node2D

signal aim_direction_changed(new_direction: Vector2)
signal aim_angle_changed_radians(new_angle: float)
signal aim_angle_changed_degree(new_angle: float)


@export_tool_button("Update") var butoon := update
@export var target: Node2D : set = set_target
@export var spread_in_degrees := 45.0 : set = set_spread_in_degrees


func set_target(new_target: Node2D) -> void:
	target = new_target
	update()


func set_spread_in_degrees(new_spread_in_degrees: float) -> void:
	spread_in_degrees = new_spread_in_degrees
	queue_redraw()


func aim(_target := target) -> void:
	look_at(_target.global_position)
	
	var spread := deg_to_rad(randf_range(-spread_in_degrees, spread_in_degrees))
	rotate(spread)
	
	var direction_vector := Vector2.RIGHT.rotated(global_rotation)
	aim_direction_changed.emit(direction_vector)
	aim_angle_changed_radians.emit(global_rotation)
	aim_angle_changed_degree.emit(global_rotation_degrees)
	queue_redraw()


func update() -> void:
	aim()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	var radius := 300.0
	draw_arc(Vector2.ZERO, radius,
		- deg_to_rad(spread_in_degrees),
		deg_to_rad(spread_in_degrees),
		64,
		Color.BLUE_VIOLET,
		16.0,
		true)
