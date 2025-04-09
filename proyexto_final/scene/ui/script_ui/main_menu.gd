class_name main_menu
extends Control
@onready var btn_start: Button = $MarginContainer/hboxButton/VBoxContainer/btnStart
@onready var btn_exit: Button = $MarginContainer/hboxButton/VBoxContainer/btnExit
@onready var btn_opcion: Button = $MarginContainer/hboxButton/VBoxContainer/btnOpcion
#@onready var start_game : PackedScene = preload()
@onready var option_menus: option_menu = $option_menu
@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	handle_con_signal()
	


func  on_exit_pressed() -> void:
	get_tree().quit()

func on_option_pressed() -> void:
	margin_container.visible = false 
	option_menus.set_process(true)
	option_menus.visible = true

func on_exit_options_menu() -> void:
	margin_container.visible = true
	option_menus.visible = false

func  handle_con_signal()-> void:
	btn_exit.button_down.connect(on_exit_pressed)
	btn_opcion.button_down.connect(on_option_pressed)
	option_menus.exit_options_menu.connect(on_exit_options_menu)


	
