@tool
class_name ArcDrawing2D
extends ShapeDrawing2D

@export var radius := 100.0 : set = set_radius
@export var start_angle := 0.0 : set = set_start_angle
@export var end_angle := 10.0 : set = set_end_angle
@export var point_count := 16 : set = set_point_count
@export var width := 4.0 : set = set_width
@export var antialiased := true : set = set_antialiased


func draw_shape() -> void:
	draw_arc(Vector2.ZERO, radius, deg_to_rad(start_angle), deg_to_rad(end_angle),
		point_count, color, width, antialiased)


func set_radius(new_radius: float) -> void:
	radius = new_radius
	update_drawing()


func set_start_angle(new_value: float) -> void:
	start_angle = new_value
	update_drawing()


func set_end_angle(new_value: float) -> void:
	end_angle = new_value
	update_drawing()


func set_point_count(new_value: int) -> void:
	point_count = new_value
	update_drawing()


func set_width(new_width: float) -> void:
	width = new_width
	update_drawing()


func set_antialiased(new_value: bool) -> void:
	antialiased = new_value
	update_drawing()
