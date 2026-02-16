extends Node2D

@export var NOISE_SHAKE_SPEED: float = 30.0
@export var NOISE_SHAKE_STRENGTH: float = 10.0
@export var SHAKE_DECAY_RATE: float = 5.0

@onready var camera = $alexplayer/Camera2D
@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

var noise_i: float = 0.0
var shake_strength: float = 1.0

func _ready() -> void:
	rand.randomize()
	noise.seed = rand.randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX  # Use Simplex noise
	noise.frequency = 0.5

func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH

func _process(delta: float) -> void:
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)

	if shake_strength > 0.0:
		camera.offset = get_noise_offset(delta)
	else:
		camera.offset = Vector2.ZERO

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	return Vector2(
		noise.get_noise_2d(1.0, noise_i) * shake_strength,
		noise.get_noise_2d(100.0, noise_i) * shake_strength
	)   
