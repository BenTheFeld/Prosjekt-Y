@tool
extends Path2D

@export var line: Line2D

func _process(delta: float) -> void:
	if not line:
		return
	if not curve:
		line.points = []
		return
	line.points = curve.get_baked_points()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not line:
		warnings.append("Assign a Line2D node in the `line` property")
	return warnings
