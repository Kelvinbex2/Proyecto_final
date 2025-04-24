class_name UpgradOption
extends Control


@export var base_null_upgrade : BaseUpgrade = null
@onready var upgrade_label: Label = $Panel/MarginContainer/VBoxContainer/UpgradeLabel
@onready var stats_label: Label = $Panel/MarginContainer/VBoxContainer/StatsLabel
@onready var des_label: Label = $Panel/MarginContainer/VBoxContainer/ScrollContainer/DesLabel
@onready var button: Button = $Panel/MarginContainer/VBoxContainer/Button


var stored_upgrade : BaseUpgrade = null

func _ready() -> void:
	button.button_down.connect(on_upgrade_purchased)
	set_upgrade_option(null)



func set_upgrade_option(upgrade: BaseUpgrade) -> void:
	
	if upgrade == null:
		upgrade_label.text = base_null_upgrade.upgrade_name
		des_label.text = base_null_upgrade.description
		button.text = "Buy(" + str(base_null_upgrade.upgrade_cost) + ")"
	else:
		upgrade_label.text = upgrade.upgrade_name
		des_label.text = upgrade.description
		button.text = "Buy(" + str(upgrade.upgrade_cost) + ")"
		stored_upgrade = upgrade
		

func on_upgrade_purchased() -> void:
	SignalBus.emit_on_upgrade_purchased(stored_upgrade)
	
