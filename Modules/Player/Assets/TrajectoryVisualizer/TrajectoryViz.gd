extends Line2D
class_name TrajectorVisualizer

var player : Player

func _ready():
	if get_parent() is Player:
		player = get_parent()

func _process(_delta: float) -> void:
	if player:
		if player.doDrawTrajectory:
			if player.NBodySim:
				var worldPoints = predict_trajectory(player, player.NBodySim.allBodies)
				var localPoints : PackedVector2Array = []
				for p in worldPoints:
					localPoints.append(to_local(p))
				points = localPoints
				
				if worldPoints.size() > 1:
					var futureDirection = (worldPoints[1] - worldPoints[0]).normalized()
					player.rotation = futureDirection.angle() + PI/2
		elif player.doDrawTrajectory == false:
			points.clear()

func predict_trajectory(body, planets:Array, steps:int = 100, dt:float = 0.05) -> PackedVector2Array:
	var points:PackedVector2Array = []

	var pos:Vector2 = body.position
	var vel:Vector2 = body.currentVelocity
	points.append(pos)

	for s in range(steps):
		var total_force := Vector2.ZERO
		for p in planets:
			if p == body:
				continue
			var r = p.position - pos
			var sqrDst = r.length_squared()
			if sqrDst == 0:
				continue
			var forceDir = r.normalized()
			var force = forceDir * Universe.gravitationalConstant * body.mass * p.Mass / sqrDst
			total_force += force

		# integrate
		var acc = total_force / body.mass
		vel += acc * dt
		pos += vel * dt

		points.append(pos)

		# impact check
		for p in planets:
			var radius = p.Radius   # assume you store planet radius
			if pos.distance_to(p.position) <= radius:
				return points  # stop at impact point

	return points
