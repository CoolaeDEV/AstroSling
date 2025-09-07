extends Node2D
class_name NearMisser

@onready var distanceLabel: Label = $Control/Label

@onready var player_distance_node: Node2D = $playerArrow/playerDistanceNode
@onready var planet_distance_node: Node2D = $planetArrow/planetDistanceNode

@onready var playerArrow: Sprite2D = $playerArrow
@onready var planetArrow: Sprite2D = $planetArrow

@onready var cameraTarget: Node2D = $CameraTarget

@export var player : Player

var isNearMiss : bool = false

func _process(_delta: float) -> void:
	var allDistances = []
	var closestPlanet
	var closestDistance
	if player:
		if player.NBodySim.running:
			if not player.crashed:
				for i in player.NBodySim.allBodies:
					var dis = (Vector2(i.position.x + i.Radius, i.position.y + i.Radius) - player.position)
					allDistances.append([i, dis.length()]) # allDistances has arrays of [planet, its distance from the player]

				if not player.NBodySim.allBodies.is_empty():
					closestPlanet = allDistances.get(allDistances.find(allDistances.min()))[0] # gets the closest Object by distance
					closestDistance = allDistances.get(allDistances.find(allDistances.min()))[1]
					if closestPlanet:
						if (closestPlanet.position - player.position).length() <= 250:
							isNearMiss = true
							distanceLabel.show()
							playerArrow.show()
							planetArrow.show()
							
							distanceLabel.text = str(snapped(closestDistance, 0)) + "m"
							player.NBodySim.currentTimewarp = lerp(player.NBodySim.currentTimewarp, 0.03, 0.1)
							
							var PArrowScaleFactor = clamp(closestPlanet.position.distance_to(player.position) / 150, 0, 1)
							var PArrowScale = 0.01 + (PArrowScaleFactor * (0.4 - 0.01))
							playerArrow.scale = Vector2(PArrowScale, PArrowScale)
							
							var PlanetArrowScaleFactor = clamp(player.position.distance_to(closestPlanet.position) / 150, 0, 1)
							var PlanetArrowScale = 0.01 + (PlanetArrowScaleFactor * (0.4 - 0.01))
							planetArrow.scale = Vector2(PlanetArrowScale, PlanetArrowScale)
							
							var clampedSpeed = clampf(player.currentVelocity.length(), 0.0, 0.5)
							player.camera.zoom = lerp(player.camera.zoom, Vector2(0.5 + clampedSpeed, 0.5 + clampedSpeed), 0.1)
							
							playerArrow.global_position = player.global_position
							var direction = (planetArrow.position - player.position).normalized()
							var angle = rad_to_deg(direction.angle())
							playerArrow.rotation_degrees = lerp(playerArrow.rotation_degrees, angle, 0.1)
							
							var dirToPlayer = (player.position - closestPlanet.position).normalized()
							var positionOnSphere
							if closestPlanet is CelestialBody:
								if not closestPlanet.isMoon:
									positionOnSphere = closestPlanet.global_position + dirToPlayer * (closestPlanet.scale * 20)
								else:
									positionOnSphere = closestPlanet.global_position + dirToPlayer * (closestPlanet.scale * 20)
							planetArrow.global_position = positionOnSphere
							
							var planetDir = (playerArrow.position - planetArrow.position).normalized()
							var angleToPlayer = rad_to_deg(planetDir.angle())
							planetArrow.rotation_degrees = lerp(planetArrow.rotation_degrees, angleToPlayer, 0.1)
							
							distanceLabel.global_position = player.position + Vector2(10, 20)
							
							cameraTarget.position = (player_distance_node.global_position + planet_distance_node.global_position) / 2
							player.camera.target = cameraTarget
							
							if (closestPlanet.position - player.position).length() <= 200:
								player.score += 0.1

							if (closestPlanet.position - player.position).length() <= 150:
									player.score += 1
									player.camera.zoom = lerp(player.camera.zoom, Vector2(6, 6), 0.05)
									player.NBodySim.currentTimewarp = 0.01

							if (closestPlanet.position - player.position).length() <= 90:
									player.score += 3
									player.camera.zoom = lerp(player.camera.zoom, Vector2(8, 8), 0.05)
									player.NBodySim.currentTimewarp = 0.007
						else:
							player.camera.target = player
							player.camera.zoom = lerp(player.camera.zoom, Vector2(0.8, 0.8), 0.1)
							distanceLabel.hide()
							playerArrow.hide()
							planetArrow.hide()
							isNearMiss = false
				else:
					distanceLabel.hide()
					playerArrow.hide()
					planetArrow.hide()
