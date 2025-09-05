extends Node2D

@export var celestialScene : PackedScene
@export var spawnArea: Rect2 = Rect2(Vector2(0,0), Vector2(800, 600))
@export var spawnInterval : float = 0.5
@export var minRadius : float = 10.0
@export var maxRadius : float = 50.0
@export var maxPlanets : int = 10
@export var minSpacing : float = 20.0
@export var maxAttempts : int = 20

@export var player : Player

var timer : float = 0.0
var planetsSpawned : int = 0
var planets: Array[CelestialBody] = []

func _ready() -> void:
	spawnArea.position = global_position

func _process(_delta: float) -> void:
	timer += _delta
	if timer >= spawnInterval and not planetsSpawned >= maxPlanets:
		timer = 0.0
		spawnPlanet()

		if player:
			player.NBodySim.updateAllBodies()

func spawnPlanet() -> void:
	if celestialScene == null:
		return
	
	for attempt in range(maxAttempts):
		var radius  = randf_range(minRadius, maxRadius)
		var pos = Vector2(
			randf_range(spawnArea.position.x + radius, spawnArea.position.x + spawnArea.size.x - radius),
			randf_range(spawnArea.position.y + radius, spawnArea.position.y + spawnArea.size.y - radius)
		)
	
		if not overlapsExisting(pos, radius):
			var planet = celestialScene.instantiate()
			if player:
				var selfIndex = player.NBodySim.get_index()
				player.NBodySim.add_child(planet)
				player.NBodySim.move_child(planet, selfIndex+1)
				
	
			planet.position = pos
		
			if planet is CelestialBody:
				planet.bodyType = randi_range(0, planet.Bodytypes.size() - 1)
				planet.initPlanetTextures()
				
				planet.Mass = randf_range(100, 1000)

			var scaleFactor = randf_range(minRadius, maxRadius) / 32.0
			planet.scale = Vector2(scaleFactor, scaleFactor)
			planet.Radius = scaleFactor
			planetsSpawned += 1
			planets.append({"pos": pos, "radius": radius})

func overlapsExisting(pos: Vector2, radius: float) -> bool:
	for data in planets:
		var other_pos: Vector2 = data["pos"]
		var other_radius: float = data["radius"]
		if pos.distance_to(other_pos) < radius + other_radius + minSpacing:
			return true
	return false
