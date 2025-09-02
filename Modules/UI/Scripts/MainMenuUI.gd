extends Node2D

var ClassicMode := preload("res://Scenes/TestScene.tscn")
@onready var classic_button: TextureButton = $CanvasLayer/ClassicButton

var hoveredOverClassicbutton := false
func _on_classic_button_pressed() -> void:
	get_tree().get_root().add_child(ClassicMode.instantiate())
	queue_free()


func _process(_delta: float) -> void:
	if hoveredOverClassicbutton:
		classic_button.scale = lerp(classic_button.scale, Vector2(.55, .55), 0.3)
	else:
		classic_button.scale = lerp(classic_button.scale, Vector2(.5, .5), 0.3)

func _on_classic_button_mouse_entered() -> void:
	hoveredOverClassicbutton = true
	
func _on_classic_button_mouse_exited() -> void:
	hoveredOverClassicbutton = false
