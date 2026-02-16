class_name RandomChance
extends Node

signal number_generated(number: int)
signal luck_generated(luck: int)
signal chance_generated(change: int)
signal jackpotted

@export var dice_faces := 6
@export_range(0.0, 1.0, 0.01) var luck_threshold := 0.0

var number := 0
var chance := 0.0
var luck := 0.0
var jackpot := false


var _random_number_generator := RandomNumberGenerator.new()


func throw_dice() -> void:
	_random_number_generator.randomize()
	number = _random_number_generator.randi_range(1, dice_faces)
	chance = 1.0 / dice_faces
	luck = chance * number
	jackpot = luck >= luck_threshold
	
	number_generated.emit(number)
	chance_generated.emit(chance)
	luck_generated.emit(luck)
	if jackpot:
		jackpotted.emit()
