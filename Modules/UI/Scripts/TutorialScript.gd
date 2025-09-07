extends Control
class_name TutorialUI

@onready var tutorial_1: Sprite2D = $Tutorial1
@onready var tutorial_2: Sprite2D = $Tutorial2
@onready var tutorial_3: Sprite2D = $Tutorial3
@onready var tutorial_4: Sprite2D = $Tutorial4

var doShowTutorial := true
var currentTutorial := 0

func _process(_delta: float) -> void:
	if doShowTutorial:
		match currentTutorial:
			0:#             Tutorial 1
				tutorial_1.show()
				tutorial_2.hide()
				tutorial_3.hide()
				tutorial_4.hide()
			1:#             Tutorial 2
				tutorial_1.hide()
				tutorial_2.show()
				tutorial_3.hide()
				tutorial_4.hide()
			2:#             Tutorial 3
				tutorial_1.hide()
				tutorial_2.hide()
				tutorial_3.show()
				tutorial_4.hide()
			3:#             Tutorial 4
				tutorial_1.hide()
				tutorial_2.hide()
				tutorial_3.hide()
				tutorial_4.show()

func _onDonePressed() -> void:
	doShowTutorial = false
	hide()

func _onBackTutorialPressed(backTo: int) -> void:
	match backTo:
		1:
			currentTutorial = 0
		2:
			currentTutorial = 1
		3:
			currentTutorial = 2

func _onNextTutorialPressed(NextTo: int) -> void:
	match NextTo:
		1:
			currentTutorial = 0
		2:
			currentTutorial = 1
		3:
			currentTutorial = 2
		4:
			currentTutorial = 3
