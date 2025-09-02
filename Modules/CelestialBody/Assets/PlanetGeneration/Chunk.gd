extends Node2D
# makes the inverse Vorioni Image Teexture and spawns CelestialBody's

var chunk_Coords : Vector2i
var chunk_Size : int
var pixel_Res : int
var seed : int
var sites_Min : int
var sites_Max : int
var Celestial_Scene : PackedScene

var backgroundSprite : Sprite2D

func setup(chunkCoords: Vector2i, chunkSize: int, pixelRes: int, seed: int, sitesMin: int, sitesMax: int, celestialScene: PackedScene) -> void:
	chunk_Coords = chunkCoords
	chunk_Size = chunkSize
	pixel_Res = pixelRes
	pixel_Res = seed
	sites_Min = sitesMin
	sites_Max = sitesMax
	Celestial_Scene = celestialScene
	
	backgroundSprite = Sprite2D.new()
	add_child(backgroundSprite)
	backgroundSprite.centered = true
	backgroundSprite.position = Vector2(chunk_Size/2, chunk_Size/2)
	
	generateChunk()
func rngForChunk() -> RandomNumberGenerator:
	var rng = RandomNumberGenerator.new()
	var h = int(chunk_Coords.x * 73856093) ^ int(chunk_Coords.y * 19349663) ^ seed
	rng.seed = abs(h)
	return rng

func generateChunk() -> void:
	var rng = rngForChunk()
	var site_count = rng.randi_range(sites_Min, sites_Max)
	var sites := []
	for i in site_count:
		# site position in world local chunk space (0..chunk_size)
		var sx = rng.randi_range(0, chunk_Size - 1) + rng.randf()
		var sy = rng.randi_range(0, chunk_Size - 1) + rng.randf()
		sites.append(Vector2(sx, sy))
	# create inverse Voronoi texture
	var img = Image.create(pixel_Res, pixel_Res, false, Image.FORMAT_RGBA8)
	#img.lock()
	for py in pixel_Res:
		for px in pixel_Res:
			var ux = float(px) / (pixel_Res - 1) * chunk_Size
			var uy = float(py) / (pixel_Res - 1) * chunk_Size
			var min_d2 = 1e18
			for s in sites:
				var d2 = s.distance_squared_to(Vector2(ux, uy))
				if d2 < min_d2:
					min_d2 = d2
			# normalize distance: 0 at site center, larger far away
			var max_possible = (chunk_Size * chunk_Size) * 0.5
			var norm = clamp(1.0 - (min_d2 / max_possible), 0.0, 1.0)
			# apply soft curve to emphasize cell centers
			var v = pow(norm, 0.7)
			var col = Color(v, v * 0.8, v * 0.5, 1.0)
			img.set_pixel(px, py, col)
	#img.unlock()
	# convert to texture
	var tex = ImageTexture.create_from_image(img)
	backgroundSprite.texture = tex
	backgroundSprite.scale = Vector2(float(chunk_Size) / pixel_Res, float(chunk_Size) / pixel_Res)
	backgroundSprite.z_index = -10

	# spawn celestial bodies at site positions with probability and spacing
	spawnBodiesFromSites(sites, rng)

func spawnBodiesFromSites(sites: Array, rng: RandomNumberGenerator) -> void:
	for s in sites:
		# decide to spawn
		if rng.randf() < 0.5: # 50% chance; tune
			if Celestial_Scene:
				var inst = Celestial_Scene.instantiate()
				add_child(inst)
				inst.position = s
				# pass RNG seed for consistent randomization per body
				if inst.has_method("setup_from_seed"):
					var body_seed = int((chunk_Coords.x * 10007) ^ (chunk_Coords.y * 30011) ^ int(s.x*1009) ^ int(s.y*7919))
					inst.setup_from_seed(body_seed)
