class_name HitArea
extends Area2D

signal hit_landed(damage: int)

@export var hit_data: HitData


func hit(hurt_area: HurtArea) -> void:
	if not hurt_area.armor_data.origin == hit_data.origin:
		hit_landed.emit(hurt_area.hurt(hit_data))


func _on_area_entered(area2D: Area2D) -> void:
	hit(area2D)
