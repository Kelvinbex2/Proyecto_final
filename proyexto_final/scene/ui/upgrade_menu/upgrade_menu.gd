class_name UpgradeMenu
extends Control

@onready var button: Button = $MarginContainer/VBoxContainer/Button
@export var upgrade_option_ar : Array[UpgradOption] = []
@export var available_upgrade : Array[BaseUpgrade] = []

signal exit_btn_pressed

func _ready() -> void:
	button.button_down.connect(on_exit_button_down)
	select_random_upgrade()
	connect_upgrade_opt_signals()
	

func connect_upgrade_opt_signals() -> void:
	for i in  upgrade_option_ar:
		i.on_upgrade_selected.connect(on_exit_button_down)


func select_random_upgrade()-> void:
	var  upgrade_name_list : Array[String] = []
	for u_name in DirAccess .get_files_at("res://scene/resources/upgrade_folder/upgrades/"):
		upgrade_name_list.append(u_name)
	
	for  u_name in upgrade_name_list.size():
		available_upgrade.append(load("res://scene/resources/upgrade_folder/upgrades/" + upgrade_name_list[u_name]))
		
	for upgrade in upgrade_option_ar:
		available_upgrade.shuffle()
		upgrade.set_upgrade_option(available_upgrade.pick_random())


func on_exit_button_down() ->void:
	exit_btn_pressed.emit()
	queue_free()
	
