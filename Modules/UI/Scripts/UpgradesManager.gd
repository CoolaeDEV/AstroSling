extends Control
class_name UpgradesManager

enum upgradeType{
	SlingBoost
}

@export var player : Player

# Upgrade Infomation
@onready var upgradeInfoPanel: TextureRect = $UpgradeInfoPanel
@onready var upgradeInfoName: Label = $UpgradeInfoPanel/UpgradeName
@onready var upgradeInformation: Label = $UpgradeInfoPanel/Label

@onready var SlingShotBootstUpgradeBtn: TextureButton = %SlingShotUpgradeButton

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2


@onready var tutorial_close_area: TextureRect = $TutorialCloseArea
@onready var Tutorialtimer: Timer = $TutorialCloseArea/Timer
var tutorialTimerStartedAlready := false

var isClosed := true

func _ready() -> void:
	Tutorialtimer.timeout.connect(func():
		animation_player_2.play("TutorialEnd")
		)
func addUpgrade(upType: upgradeType):
	if player:
		var newUpgrade = {}
		match upType:
			0:#                    ---- SlingBoost ----
				newUpgrade = {
					"UpgradeImage": preload("res://Modules/UI/Assets/UpgradesUI/Launch.png"),
					"UpgradeName": "SlingBoost",
					"UpgradeType": upType,
					"UpgradeCost": 500,
				}
		player.upgrades.append(newUpgrade)

func _on_close_button_pressed() -> void:
	if not isClosed:
		animation_player.play("Close")


func _onUpgradeButtonClicked(upgradeName: String, upgradeButtonPath: NodePath, upgradeCost: int) -> void:
	if not player.tutorialUI.doShowTutorial:
		match upgradeName:
			"SlingBoost":
				if player.coins >= 500:
					player.coins -= 500
					addUpgrade(upgradeType.SlingBoost)
					var upButton = get_node(upgradeButtonPath).find_child("SlingShotUpgradeButton")
					if upButton is TextureButton:
						upButton.disabled = true
				else:
					print("Your too Broke")

func _on_close_area_pressed() -> void:
	if not isClosed and not player.NBodySim.running:
		animation_player.play("Close")
