class_name VisionArea2D
extends Area2D

signal visible_area_found(visible_area: Area2D)

func update() -> void:
	if get_overlapping_areas().size() > 0:
		visible_area_found.emit(get_overlapping_areas()[0])
