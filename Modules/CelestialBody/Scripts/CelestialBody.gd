extends StaticBody2D
class_name CelestialBody

@export_category("-Planetary Settings-")
@export var Mass : float = 0.0

@export var minRadius := 8.0
@export var maxRadius := 64.0

@export var bodyTexture : Texture2D
@onready var mesh: Sprite2D = $Mesh
enum Bodytypes{
	Earthlike,
	Moonlike,
	Marslike
}
@export var bodyType : Bodytypes = Bodytypes.Earthlike
@onready var earth_atmosphere: Sprite2D = $EarthAtmosphere
@onready var mars_atmosphere: Sprite2D = $MarsAtmosphere

@export var isMoon : bool = false
const EARTHLIKE : Texture2D = preload("res://Modules/UI/Assets/PlayUI/Earthlike.png")
const MARS_LIKE : Texture2D = preload("res://Modules/UI/Assets/PlayUI/MarsLike.png")
const MOON_LIKE : Texture2D = preload("res://Modules/UI/Assets/PlayUI/MoonLike.png")

@onready var kill_box: Area2D = $KillBox
@onready var collision_shape_2d: CircleShape2D = $KillBox/CollisionShape2D.shape

var rng := RandomNumberGenerator.new()
var Radius : float = 16.0
var rotationSpeed := 0.0

func setupFromSeed(s: int) -> void:
	rng.seed = abs(s)
	Radius = rng.randf_range(minRadius, maxRadius)
	kill_box.scale = Vector2(Radius, Radius)
	
	rotationSpeed = rng.randf_range(-0.5, 0.5)
	createVisual()

func _ready():
	Radius = scale.x
	initPlanetTextures()

func initPlanetTextures() -> void:
	match bodyType: #setup Atmospheres
		0: # Earthlike
			if mesh:
				mesh.texture = EARTHLIKE
			earth_atmosphere.show()
			mars_atmosphere.hide()
			collision_shape_2d.radius = 19
			isMoon = false
		1: # MoonLike
			if mesh:
				mesh.texture = MOON_LIKE
			earth_atmosphere.hide()
			mars_atmosphere.hide()
			collision_shape_2d.radius = 17
			isMoon = true
		2: # MarsLike
			if mesh:
				mesh.texture = MARS_LIKE 
			earth_atmosphere.hide()
			mars_atmosphere.show()
			collision_shape_2d.radius = 19
			isMoon = false

func _process(_delta: float) -> void:
	rotation_degrees += rotationSpeed

func createVisual() -> void:
	# If we have a texture, use Sprite2D. if not then draw a circle through CircleShape in a CanvasItem.
	if bodyTexture:
		var sp = Sprite2D.new()
		sp.texture = bodyTexture
		sp.scale = Vector2.ONE * (Radius / (max(bodyTexture.get_width(), 1)))
		add_child(sp)
	else:
		# fallback: simple ColorRect with rounded effect via shader would be better.
		var circle = NinePatchRect.new()
		circle.rect_size = Vector2(Radius*2, Radius*2)
		circle.modulate = Color(rng.randf(), rng.randf(), rng.randf())
		circle.centered = true
		add_child(circle)

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		body.crashed = true
		Audio.play(Audio.AudioSettings.new()
					.set_path("res://Audio/Death.wav")
					.set_bus("res://Audio/MainAudioBus.tres")
					.set_volume(1.0))
