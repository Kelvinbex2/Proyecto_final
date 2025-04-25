class_name OptionMenu
extends Control
@onready var btn_exit: Button = $MarginContainer/VBoxContainer/btnExit
@onready var setting_con: Control = $MarginContainer/VBoxContainer/setting_con

signal exit_options_menu

func _ready() -> void:
	btn_exit.button_down.connect(on_exit_pressed)
	setting_con.exit_opt_menu.connect(on_exit_pressed) #Escape btn to exit
	SettingSignalBus.emit_request_reload_settings()
	set_process(false)
	
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	SettingSignalBus.emit_set_settings_dictionary(SettingDataContainer.create_storage_dictionary())
	set_process(false)
