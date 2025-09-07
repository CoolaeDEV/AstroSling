extends Control
class_name PlayUI

@onready var score: Label = $Score
@onready var slingshotsuage: TextureProgressBar = $slingshotsuage
@onready var slingshotPercent: Label = $slingshotsuage/Label

@onready var high_score: Label = $TextureRect/HighScore
@onready var play_button: TextureButton = $playButton
@onready var quit_button: TextureButton = $quitButton
@onready var upgrade_button: TextureButton = $UpgradeButton

@onready var coins: Label = $TextureRect2/Coins

var playbuttonTexture := preload("res://Modules/UI/Assets/PlayUI/Play.png")
var playingButtonTexture := preload("res://Modules/UI/Assets/PlayUI/Playing.png")

@export var player: Player
@export var upgradeUI : UpgradesManager

func _process(_delta: float) -> void:
	if player:
		score.text = str(snapped(player.score, 0))
		slingshotsuage.value = lerp(slingshotsuage.value, player.slingShotUsage, 0.05)
		slingshotPercent.text = str(snapped(player.slingShotUsage, 0)) + "%"
		high_score.text = str(snapped(player.HighScore, 0))
		
		coins.text = str(snapped(player.coins, 0))
		
		if player.NBodySim.running:
			play_button.texture_normal = playingButtonTexture
			quit_button.show()
			upgrade_button.hide()
		else:
			play_button.texture_normal = playbuttonTexture
			quit_button.hide()
			upgrade_button.show()

func _onSlingShotDisableMouseEntered() -> void:
	if player:
		player.canSlingShot = false

func _onSlingShotDisableMouseExited() -> void:
	if player:
		player.canSlingShot = true

func _on_play_button_pressed() -> void:
	if player:
		player.canSlingShot = false
		if not player.NBodySim.running:
			player.position = player.initalPosition
			player.NBodySim.running = true

func _on_quit_button_pressed() -> void:
	if player:
		player.reset()

func _on_upgrade_button_pressed() -> void:
	upgradeUI.animation_player.play("Open")
	upgradeUI.isClosed = false
