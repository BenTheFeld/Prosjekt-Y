extends Node2D

signal synced


func update_position(_target: Node2D) -> void:
	global_position = _target.global_position
	synced.emit()
