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
	animation_player.play("Close")
	

func _onUpgradeButtonClicked(upgradeName: String, upgradeButtonPath: NodePath, upgradeCost: int) -> void:
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
