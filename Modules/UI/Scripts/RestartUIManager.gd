extends Control

@onready var max_speed: Label = $Panel/MaxSpeedRect/MaxSpeed
@onready var max_altitude: Label = $Panel/maxAlttextureRect/MaxAltitude
@onready var coins: Label = $Panel/CoinsRect/Coins

@onready var restartbutton: TextureButton = $Panel/Restartbutton
@onready var restart_with_ads_button: TextureButton = $Panel/RestartWithAdsButton

@onready var reset_anim: AnimationPlayer = $ResetAnim

@export var player : Player

var mouseInResetButton := false
var mouseInResetAdButton := false

func _ready():
	if OS.get_name() == "Windows" || OS.get_name() == "Web":
		restart_with_ads_button.hide()

func _on_restart_button_pressed() -> void:
	if player:
		reset_anim.play("close")
		player.reset()
		hide()

func _on_visibility_changed() -> void:
	if player:
		reset_anim.play("open")
		max_speed.text = str(snapped(player.maxVelocity, 0)) + "m/s"
		max_altitude.text = str(snapped(player.maxAltitude, 0)) + "km"
		
		coins.text = str(snapped((player.score / 2.5) * player.coinMultiplier, 0))
		
func _process(_delta: float) -> void:
		if mouseInResetButton:
			restartbutton.scale = lerp(restartbutton.scale, Vector2(0.9, 0.9), 0.5)
		else:
			restartbutton.scale = lerp(restartbutton.scale, Vector2(0.8, 0.8), 0.5)
		
		if mouseInResetAdButton:
			restart_with_ads_button.scale = lerp(restart_with_ads_button.scale, Vector2(0.9, 0.9), 0.5)
		else:
			restart_with_ads_button.scale = lerp(restart_with_ads_button.scale, Vector2(0.8, 0.8), 0.5)

func _on_restartbutton_mouse_entered() -> void:
	mouseInResetButton = true

func _on_restartbutton_mouse_exited() -> void:
	mouseInResetButton = false

func _on_restart_with_ads_button_pressed() -> void:
	if player:
		player.reset()
		reset_anim.play("close")
		
		player.coins += 1500

		hide()

func _on_restart_with_ads_button_mouse_entered() -> void:
	mouseInResetAdButton = true

func _on_restart_with_ads_button_mouse_exited() -> void:
	mouseInResetAdButton = false
