extends Node2D

var ClassicMode := preload("res://Scenes/TestScene.tscn")

func _on_classic_button_pressed() -> void:
	get_tree().get_root().add_child(ClassicMode.instantiate())
	queue_free()
