extends Node2D
class_name NBodySimulation

var allBodies = []

var running = false : set = _runningSetter

var physicsTimeStep = 0.01

signal setRunningState

var Timewarps : Array = [
	0.05, # 1x
	0.1, # 1.5x
	0.2, # 2x
	0.25,  # 2.5x
	0.3, # 3x
]
var currentTimewarp = Timewarps[0]

func _runningSetter(value : bool):
	running = value
	
	var player
	for i in get_children():
		if i is Player:
			player = i 
	
	if value == false:
		player.canSlingShot = false
	else:
		player.canSlingShot = true
	
	setRunningState.emit()

func _ready() -> void:
	for i in get_children():
		if i is CelestialBody:
			allBodies.push_back(i)

func _process(_delta: float) -> void:
	physicsTimeStep = lerp(physicsTimeStep, currentTimewarp, 0.5)
