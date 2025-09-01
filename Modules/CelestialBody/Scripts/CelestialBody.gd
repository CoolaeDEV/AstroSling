extends StaticBody2D
class_name CelestialBody

@export_category("-Planetary Settings-")
@export var Mass : float = 0.0
var Radius : float = 0.0

func _ready():
	Radius = transform.get_scale().x + 10

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		body.crashed = true
		Audio.play(Audio.AudioSettings.new()
					.set_path("res://Audio/Death.wav")
					.set_bus("res://Audio/MainAudioBus.tres")
					.set_volume(1.0))
