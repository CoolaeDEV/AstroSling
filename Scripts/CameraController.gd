extends Camera2D
class_name CameraController

var player : Player

@export var cameraOffset: Vector2
@export var lerpSpeed : float = 0.05
@export var doFollow: bool = true

var target : Node2D

var originalOffset: Vector2
var shaking : bool = false

func _ready():
	player = get_parent().find_child("Player")
	originalOffset = offset
	target = player

func _physics_process(_delta: float) -> void:
	if doFollow:
		position = lerp(position, target.position + cameraOffset, lerpSpeed)
	if player.crashed:
		player.camera.zoom = lerp(player.camera.zoom, Vector2(1.7, 1.7), 0.05)
