class_name HurtArea
extends Area2D

signal damaged(damage: int)

@export var armor_data: ArmorData


func hurt(hit_data: HitData) -> int:
	var damage: int = max(0, hit_data.damage - armor_data.defense)
	damaged.emit(damage)
	return damage
