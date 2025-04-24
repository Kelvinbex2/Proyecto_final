class_name UpgradeMenu
extends Control

@onready var button: Button = $MarginContainer/VBoxContainer/Button
@export var upgrade_option_ar : Array[UpgradOption] = []
@export var available_upgrade : Array[BaseUpgrade] = []

signal exit_btn_pressed

func _ready() -> void:
	button.button_down.connect(on_exit_button_down)
	select_random_upgrade()


func select_random_upgrade()-> void:
	for upgrade_option in upgrade_option_ar:
		available_upgrade.shuffle()
		upgrade_option.set_upgrade_option(available_upgrade.pick_random())


func on_exit_button_down() ->void:
	exit_btn_pressed.emit()
	queue_free()
	
