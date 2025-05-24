class_name MainMenu
extends Control
@onready var btn_start: Button = $MarginContainer/hboxButton/VBoxContainer/btnStart
@onready var btn_join: Button = $MarginContainer/hboxButton/VBoxContainer/btnJoin
@onready var btn_exit: Button = $MarginContainer/hboxButton/VBoxContainer/btnExit
@onready var btn_opcion: Button = $MarginContainer/hboxButton/VBoxContainer/btnOpcion

@onready var start_game : PackedScene = preload("res://scene/main/main.tscn")
@onready var option_menus: OptionMenu = $option_menu
@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	handle_con_signal()

func handle_con_signal() -> void:
	btn_exit.button_down.connect(on_exit_pressed)
	btn_opcion.button_down.connect(on_option_pressed)
	btn_start.button_down.connect(on_start_pressed)
	btn_join.button_down.connect(on_join_pressed)
	option_menus.exit_options_menu.connect(on_exit_options_menu)

func on_start_pressed() -> void:
	MultiplayerManager.reset_multiplayer()  # Reinicia cualquier conexión previa
	if not MultiplayerManager.multiplayer_ready.is_connected(_start_game):
		MultiplayerManager.multiplayer_ready.connect(_start_game)
	MultiplayerManager.host_game()

func on_join_pressed() -> void:
	MultiplayerManager.reset_multiplayer()
	if not MultiplayerManager.multiplayer_ready.is_connected(_start_game):
		MultiplayerManager.multiplayer_ready.connect(_start_game)
	MultiplayerManager.join_game("localhost", 8888)



func _start_game() -> void:
	GlobalStat.reset_coins()
	get_tree().change_scene_to_packed(start_game)

func on_exit_pressed() -> void:
	get_tree().quit()

func on_option_pressed() -> void:
	margin_container.visible = false 
	option_menus.set_process(true)
	option_menus.visible = true

func on_exit_options_menu() -> void:
	margin_container.visible = true
	option_menus.visible = false
