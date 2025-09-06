extends Node2D
class_name planetIndicator

@export var player : Player

@onready var planet_idenetifer: TextureRect = $Arrows/PlanetIdenetifer
@onready var arrows: Node2D = $Arrows
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	var allDistances = []
	var closestPlanet
	var closestDistance
	if player:
		if not player.crashed:
			for i in player.NBodySim.allBodies:
				var dis = (Vector2(i.position.x + i.Radius, i.position.y + i.Radius) - player.position)
				allDistances.append([i, dis.length()]) # allDistances has arrays of [planet, its distance from the player]

			if not player.NBodySim.allBodies.is_empty():
				closestPlanet = allDistances.get(allDistances.find(allDistances.min()))[0] # gets the closest Object by distance
				closestDistance = allDistances.get(allDistances.find(allDistances.min()))[1]
				if closestPlanet:
					if (player.position - closestPlanet.position).length() <= 10000:
						if not player.nearMisser.isNearMiss:
							arrows.show()
							animation_player.play("Smooth")
							var dirToPlanet = (closestPlanet.position - arrows.position).normalized()
							var positionOnSphere = arrows.global_position + dirToPlanet
							arrows.global_position = player.position

							var direction = (arrows.position - closestPlanet.position).normalized()
							var angle = rad_to_deg(direction.angle())
							arrows.rotation_degrees = lerp(arrows.rotation_degrees, angle, 0.05)
							planet_idenetifer.texture = closestPlanet.mesh.texture
						else:
							animation_player.stop()
							arrows.hide()
					else:
						animation_player.stop()
						arrows.hide()
