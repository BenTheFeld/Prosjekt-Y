class_name ShapeDrawing2D
extends Node2D

@export var color: Color = Color(0.949, 0.827, 0.671) : set = set_color


func draw_shape() -> void:
	pass


func update_drawing() -> void:
	queue_redraw()


func _draw() -> void:
	draw_shape()


func set_color(new_color: Color) -> void:
	color = new_color
	update_drawing()
