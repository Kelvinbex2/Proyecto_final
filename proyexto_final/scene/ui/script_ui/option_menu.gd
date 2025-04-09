class_name option_menu
extends Control
@onready var btn_exit: Button = $MarginContainer/VBoxContainer/btnExit

signal exit_options_menu

func _ready() -> void:
	btn_exit.button_down.connect(on_exit_pressed)
	set_process(false)
	
	
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
