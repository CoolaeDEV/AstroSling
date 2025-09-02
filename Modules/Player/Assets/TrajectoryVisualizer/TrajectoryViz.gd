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
				var worldPoints = predict_trajectory(player, player.NBodySim.allBodies, 50)
				var localPoints : PackedVector2Array = []
				for p in worldPoints:
					localPoints.append(to_local(p))
				points = localPoints
				
				if worldPoints.size() > 1:
					var futureDirection = (worldPoints[1] - worldPoints[0]).normalized()
					player.rotation = futureDirection.angle() + PI/2
		elif player.doDrawTrajectory == false:
			points.clear()

func predict_trajectory(body, planets:Array, steps:int = 50, dt:float = 0.05) -> PackedVector2Array:
	var points := PackedVector2Array()
	points.resize(steps + 1)

	var pos: Vector2 = body.position
	var vel: Vector2 = body.currentVelocity
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

		# impact check
		for p in planets:
			var r2 = (pos - p.position).length_squared()
			if r2 <= p.Radius * p.Radius:
				points.resize(s + 1)
				return points

	return points
