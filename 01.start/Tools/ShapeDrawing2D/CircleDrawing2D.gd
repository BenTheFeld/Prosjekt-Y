@tool
class_name CircleDrawing2D
extends ShapeDrawing2D

@export var radius := 100.0 : set = set_radius
@export var filled := true : set = set_filled
@export var width := 4.0 : set = set_width
@export var antialiased := true : set = set_antialiased


func draw_shape() -> void:
	draw_circle(Vector2.ZERO, radius, color, filled, width, antialiased)


func set_radius(new_radius: float) -> void:
	radius = new_radius
	update_drawing()


func set_filled(new_value: bool) -> void:
	filled = new_value
	update_drawing()


func set_width(new_width: float) -> void:
	width = new_width
	update_drawing()


func set_antialiased(new_value: bool) -> void:
	antialiased = new_value
	update_drawing()
