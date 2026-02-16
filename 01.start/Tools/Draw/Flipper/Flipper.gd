@tool
class_name Flipper
extends Node

@export var target: Node2D
@export var with: Node2D
@export_tool_button("Update") var update_button := update

func flip(_with := with) -> void:
	var direction := target.global_position.direction_to(_with.global_position)
	if direction.x <= 0.0:
		target.scale.x = -1.0
	else:
		target.scale.x = 1.0


func update() -> void:
	flip()
