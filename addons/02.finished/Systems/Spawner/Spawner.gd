extends Node2D
class_name Spawner

signal created(product: Node2D)

@export var product_packed_scene: PackedScene
@export var common_ancestor_name: StringName
@export var target_container_name: StringName


func create(_product_packed_scene := product_packed_scene) -> Node2D:
	var product: Node2D = _product_packed_scene.instantiate()
	product.global_position = global_position
	product.top_level = top_level
	
	var container: Node2D
	if common_ancestor_name:
		container = find_parent(common_ancestor_name)
	if target_container_name:
		container = container.find_child(target_container_name)
	if not container:
		container = self
	container.call_deferred("add_child", product)
	
	created.emit(product)
	return product
