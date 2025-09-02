extends RigidBody2D
class_name Player

# -Required Nodes-
@export_category("Required Nodes")
@export var camera : CameraController
@export var resetUI : Control
@export var PlayUI : PlayUI
@export var trajectoryVisualizer : TrajectorVisualizer
@export var nearMisser : NearMisser
var NBodySim : NBodySimulation

# -Velocity Vars-
@export_category("Velocity Vars")
var currentVelocity : Vector2 = Vector2.ZERO
@export var initalVelocity : Vector2 = Vector2.ZERO
var maxVelocity : float

# -Upgrades / Mulipliers-
@export_category("Upgrades / Mulipliers")
@export var coinMultiplier : int = 1.5
@export var slingShotDepletionMultiplier : float = 100.0
@export var slingShotPowerMultipler : float = 150.0

# -Misc-
@export_category("Misc")
var initalPosition : Vector2

@export var doDrawTrajectory : bool = true
var crashed : bool = false

var coins : int = 10

var altitude : float
var initalAltitude : float
var maxAltitude : float

var canSlingShot : bool = true
var slingShotUsage : float = 100.0

var score := 0.0
var HighScore := 0.0

func _ready():
	if get_parent() is NBodySimulation:
		NBodySim = get_parent()
		currentVelocity = initalVelocity
		initalAltitude = position.y
	initalPosition = position


func _process(_delta: float) -> void:
	if NBodySim.running:
		if crashed:
			if resetUI:
				resetUI.show()
			doDrawTrajectory = false
		else:
			doDrawTrajectory = true

		if score >= HighScore:
			HighScore = score

		if currentVelocity.length() >= maxVelocity:
			maxVelocity = currentVelocity.length()
		if altitude >= maxAltitude:
			maxAltitude = altitude

	altitude = (initalAltitude - position.y) / 5

	if slingShotUsage <= 0:
		canSlingShot = false

func _physics_process(_delta: float) -> void:
	if NBodySim.running and not crashed:
		updateVelocity(NBodySim.physicsTimeStep)
		updatePosition(NBodySim.physicsTimeStep)

func updateVelocity(timeStep):
	for i in NBodySim.allBodies:
		var sqrDst:float = (i.position - self.position).length_squared()
		var forceDir:Vector2 = (i.position - self.position).normalized()
		var force:Vector2 = forceDir * Universe.gravitationalConstant * self.mass * i.Mass / sqrDst
		var acceleration:Vector2 = force / self.mass
		currentVelocity += acceleration * timeStep

func updatePosition(timeStep):
	position += currentVelocity * timeStep

func reset():
	NBodySim.running = false
	position = initalPosition
	rotation = 0
	trajectoryVisualizer.clear_points()

	crashed = false
	currentVelocity = initalVelocity
	coins += (score / 2.5) * coinMultiplier

	NBodySim.currentTimewarp = NBodySim.Timewarps[0]

	maxVelocity = 0
	maxAltitude = 0
	slingShotUsage = 100
	score = 0
