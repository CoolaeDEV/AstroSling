extends Node2D
# Keeps chunks around the player and generates them

@export_node_path("Node2D")
var player_path: NodePath
var player: Node2D

@export var celestialScene : PackedScene

const CHUNK_SIZE := 1024                    # world units per chunk
const PIXEL_RES := 256                      # texture size per chunk (square)
const ACTIVE_RADIUS := 2                    # chunks radius around player (Manhattan/radial)
const SITES_MIN := 4
const SITES_MAX := 10

var seed : int = 123456789
var activeChunks := {}

func _ready():
	player = get_node(player_path)
	updateActiveChunks(true)

func _process(_delta: float) -> void:
	updateActiveChunks()
	
func updateActiveChunks(force=false):
	if not player:
		return
	
	var pc := worldToChunk(player.global_position)
	var needed := {}
	for x in range(pc.x - ACTIVE_RADIUS, pc.x + ACTIVE_RADIUS + 1):
		for y in range(pc.y - ACTIVE_RADIUS, pc.y + ACTIVE_RADIUS + 1):
			var key = Vector2i(x,y)
			needed[key] = true
			if not activeChunks.has(key) or force:
				createChunk(key)
	# remove distant chunks
	for key in activeChunks.keys():
		if not needed.has(key):
			removeChunk(key)

func worldToChunk(world_pos: Vector2) -> Vector2i:
	return Vector2i(floor(world_pos.x / CHUNK_SIZE), floor(world_pos.y / CHUNK_SIZE))

func chunkOrigin(chunk_coords: Vector2i) -> Vector2:
	return Vector2(chunk_coords.x * CHUNK_SIZE, chunk_coords.y * CHUNK_SIZE)

func createChunk(chunk_coords: Vector2i) -> void:
	if activeChunks.has(chunk_coords):
		return
	var chunk := Node2D.new()
	chunk.name = "Chunk_%s_%s" % [chunk_coords.x, chunk_coords.y]
	add_child(chunk)
	chunk.position = chunkOrigin(chunk_coords)
	# attach script to populate visuals and bodies
	var chunk_script = preload("res://Modules/CelestialBody/Assets/PlanetGeneration/Chunk.tscn")
	var inst = chunk_script.instantiate()
	inst.setup(chunk_coords, CHUNK_SIZE, PIXEL_RES, seed, SITES_MIN, SITES_MAX, celestialScene)
	chunk.add_child(inst)
	activeChunks[chunk_coords] = { "node": chunk, "script": inst }

func removeChunk(chunk_coords: Vector2i) -> void:
	var info = activeChunks.get(chunk_coords, null)
	if not info:
		return
	if info.node:
		info.node.queue_free()
	activeChunks.erase(chunk_coords)
