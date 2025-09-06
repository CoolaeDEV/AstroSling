extends Line2D
class_name Slingshot

@onready var player : Player
@export var TrajectoryViz : TrajectorVisualizer

var vecStart := Vector2.ZERO
var vecFinish := Vector2.ZERO

@onready var newtrajectory: Line2D = $NewTrajectory
var draggin : bool = false
var previousTimewarp : float = 0.05

# Camera effect tuning
var zoom_out_factor: Vector2 = Vector2(0.5, 0.5)
var zoom_normal: Vector2 = Vector2(0.8, 0.8)
var offset_strength: float = 1.0
var zoom_lerp_speed: float = 0.2
var offset_lerp_speed: float = 0.01

func _ready():
	if get_parent() is Player:
		player = get_parent()

func _process(_delta: float) -> void:
	if draggin:
		if player.NBodySim.running and player.canSlingShot:
			# zoom out while dragging
			player.camera.zoom = player.camera.zoom.lerp(zoom_out_factor, zoom_lerp_speed)

			# inverse offset (camera moves opposite to finger)
			var drag_dir = (player.camera.global_position - vecFinish) * offset_strength
			player.camera.offset = player.camera.offset.lerp(drag_dir, offset_lerp_speed)
			player.NBodySim.currentTimewarp = lerp(player.NBodySim.currentTimewarp, 0.005, 0.5)
			
			vecFinish = get_global_mouse_position()
			var worldPoints = [vecStart, vecFinish]
			var localPoints : PackedVector2Array = []
			for p in worldPoints:
				localPoints.append(to_local(p))
			points = localPoints
		
			if player.doDrawTrajectory:
				worldPoints = predict_trajectory(player, (player.currentVelocity + (vecStart - vecFinish) * player.slingShotPowerMultipler / 600), player.NBodySim.allBodies, 50)
				localPoints = []
				for p in worldPoints:
					localPoints.append(to_local(p))
				newtrajectory.points = localPoints

	elif draggin == false and player.crashed == false:
		# reset zoom + offset when not dragging
		player.camera.zoom = player.camera.zoom.lerp(zoom_normal, zoom_lerp_speed)
		player.camera.offset = player.camera.offset.lerp(Vector2.ZERO, offset_lerp_speed)


func _input(event: InputEvent) -> void:
	if player:
		if player.NBodySim.running:
			if Input.is_action_just_pressed("click"):
				vecStart = get_global_mouse_position()
				vecFinish = vecStart
				draggin = true

		if Input.is_action_just_released("click"):
			if player and player.canSlingShot:
				if player.NBodySim.running:
					player.currentVelocity += (vecStart - vecFinish) * player.slingShotPowerMultipler / 800
					var subtractedPowerUsage = snapped((vecStart - vecFinish).length() / player.slingShotDepletionMultiplier, 0)
					player.slingShotUsage -= subtractedPowerUsage
					player.NBodySim.currentTimewarp = previousTimewarp
					draggin = false
			clear_points()
			newtrajectory.clear_points()

func predict_trajectory(body, vel: Vector2, planets: Array, steps: int = 1000, dt: float = 0.1) -> PackedVector2Array:
	var points := PackedVector2Array()
	points.resize(steps + 1)

	var pos: Vector2 = body.position
	points[0] = pos

	var gm = Universe.gravitationalConstant * body.mass

	for s in range(1, steps + 1):
		var total_force := Vector2.ZERO

		for p in planets:
			if p == body:
				continue
			var r: Vector2 = p.position - pos
			var sqrDst := r.x * r.x + r.y * r.y
			if sqrDst == 0.0:
				continue
			var inv_len := 1.0 / sqrt(sqrDst)
			var force = r * (gm * p.Mass * inv_len / sqrDst)
			total_force += force

		var acc = total_force / body.mass
		vel += acc * dt
		pos += vel * dt
		points[s] = pos


	return points
