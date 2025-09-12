extends Control
class_name PlayUI

@onready var score: Label = $TopBar/Score
@onready var slingshotsuage: TextureProgressBar = $slingshotsuage
@onready var slingshotPercent: Label = $slingshotsuage/Label

@onready var high_score: Label = $TopBar/TextureRect/HighScore
@onready var play_button: TextureButton = $playButton
@onready var quit_button: TextureButton = $quitButton
@onready var upgrade_button: TextureButton = $UpgradeButton
@onready var wardrobe_button: TextureButton = $WardrobeButton
@onready var shop_button: TextureButton = $ShopButton
@onready var top_bar: Control = $TopBar
@onready var home_button: TextureButton = $HomeButton

@onready var rcs_left: TextureButton = $RCSLeft
@onready var rcs_right: TextureButton = $RCSRight

@onready var coins: Label = $TopBar/TextureRect2/Coins


var playbuttonTexture := preload("res://Modules/UI/Assets/PlayUI/Play.png")
var playingButtonTexture := preload("res://Modules/UI/Assets/PlayUI/Playing.png")

var MainMenu := preload("res://Modules/UI/Scenes/MainMenu.tscn")

@export var player: Player
@export var upgradeUI : UpgradesManager

func _ready() -> void:
	if player:
		if player.universe.isFreeplayModeOn:
			top_bar.hide()
		else:
			top_bar.show()

func _process(_delta: float) -> void:
	if player:
		if not player.universe.isFreeplayModeOn:
			score.text = str(snapped(player.score, 0))
			slingshotsuage.value = lerp(slingshotsuage.value, clamp(player.slingShotUsage, 0.0, 100.0), 0.05)
			slingshotPercent.text = str(snapped(player.slingShotUsage, 0)) + "%"
			high_score.text = str(snapped(player.HighScore, 0))
			
			coins.text = str(snapped(player.coins, 0))
		
		if player.NBodySim.running:
			play_button.texture_normal = playingButtonTexture
			quit_button.show()
			upgrade_button.hide()
			#wardrobe_button.hide()
			#shop_button.hide()
			home_button.hide()
			rcs_left.show()
			rcs_right.show()
		else:
			play_button.texture_normal = playbuttonTexture
			quit_button.hide()
			upgrade_button.show()
			#wardrobe_button.show()
			#shop_button.show()
			home_button.show()
			rcs_left.hide()
			rcs_right.hide()
			
func _onSlingShotDisableMouseEntered() -> void:
	if player:
		player.canSlingShot = false

func _onSlingShotDisableMouseExited() -> void:
	if player:
		player.canSlingShot = true

func _on_play_button_pressed() -> void:
	if player:
		if not player.tutorialUI.doShowTutorial:
			player.canSlingShot = false
			if not player.NBodySim.running:
				player.position = player.initalPosition
				player.NBodySim.running = true

func _on_quit_button_pressed() -> void:
	if player:
		if not player.tutorialUI.doShowTutorial:
			player.reset()

func _on_upgrade_button_pressed() -> void:
	if not player.tutorialUI.doShowTutorial:
		upgradeUI.animation_player.play("Open")
		upgradeUI.isClosed = false
		if upgradeUI.tutorialTimerStartedAlready == false:
			upgradeUI.animation_player_2.play("TutorialStart")
			upgradeUI.Tutorialtimer.start()
			upgradeUI.tutorialTimerStartedAlready = true

func _on_home_button_pressed() -> void:
	if not player.tutorialUI.doShowTutorial:
		get_tree().change_scene_to_file("res://Modules/UI/Scenes/MainMenu.tscn")
		player.NBodySim.queue_free() # This is the main root of the MainGame so deleting it kills the game

func _on_rcs_left_button_down() -> void:
	player.isUsingLeftThruster = true

func _on_rcs_left_button_up() -> void:
	player.isUsingLeftThruster = false


func _on_rcs_right_button_down() -> void:
	player.isUsingRightThruster = true

func _on_rcs_right_button_up() -> void:
	player.isUsingRightThruster = false
