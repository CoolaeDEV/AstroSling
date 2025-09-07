extends Node2D

var ClassicMode := preload("res://Scenes/TestScene.tscn")
@onready var classic_button: TextureButton = $CanvasLayer/ClassicButton
@onready var freeplay_button: TextureButton = $CanvasLayer/FreeplayButton

var universe : Universe

var hoveredOverClassicbutton := false
var hoverdOverFreeplaybutton := false

func _on_classic_button_pressed() -> void:
	universe.isFreeplayModeOn = false
	get_tree().get_root().add_child(ClassicMode.instantiate())
	queue_free()

func _ready():
	for i in get_tree().root.get_children():
		if i is Universe:
			universe = i 

func _process(_delta: float) -> void:
	if hoveredOverClassicbutton:
		classic_button.scale = lerp(classic_button.scale, Vector2(.55, .55), 0.3)
	else:
		classic_button.scale = lerp(classic_button.scale, Vector2(.5, .5), 0.3)

	if hoverdOverFreeplaybutton:
		freeplay_button.scale = lerp(freeplay_button.scale, Vector2(.55, .55), 0.3)
	else:
		freeplay_button.scale = lerp(freeplay_button.scale, Vector2(.5, .5), 0.3)

func _on_classic_button_mouse_entered() -> void:
	hoveredOverClassicbutton = true
	
func _on_classic_button_mouse_exited() -> void:
	hoveredOverClassicbutton = false

func _on_freeplay_button_pressed() -> void:
	universe.isFreeplayModeOn = true
	get_tree().get_root().add_child(ClassicMode.instantiate())
	queue_free()


func _on_freeplay_button_mouse_entered() -> void:
	hoverdOverFreeplaybutton = true

func _on_freeplay_button_mouse_exited() -> void:
	hoverdOverFreeplaybutton = false
