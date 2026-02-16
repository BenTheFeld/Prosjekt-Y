@tool
extends Node2D

@export var target: Node2D

@export var inner_radius := 200.0 : set = set_inner_radius
@export var outer_radius := 400.0 : set = set_outer_radius

@export var inner_color: Color = Color.BLUE
@export var outer_color: Color = Color.RED


func randomize_position(_target: Node2D = target) -> void:
	var distance := randf_range(inner_radius, outer_radius)
	var angle := randf_range(-TAU, TAU)
	var target_position := (Vector2.RIGHT * distance).rotated(angle)
	_target.global_position = to_global(target_position)


func distribute(_target: Node2D = target) -> void:
	randomize_position(_target)


func set_inner_radius(new_value: float) -> void:
	inner_radius = clampf(new_value, 0.0, outer_radius)
	queue_redraw()


func set_outer_radius(new_value: float) -> void:
	outer_radius = clampf(new_value, inner_radius, new_value)
	queue_redraw()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_circle(Vector2.ZERO, outer_radius, outer_color, false, 4)
	draw_circle(Vector2.ZERO, inner_radius, inner_color, false, 4)
