class_name PauseMenu
extends Control

signal menu_shown
signal menu_hidden

var player_ref: Player = null

func _ready() -> void:
	visible = false
	SignalBus.on_player_ready.connect(_on_player_ready)

func _on_player_ready(player: Player) -> void:
	player_ref = player

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause() -> void:
	get_tree().paused = true
	visible = true
	menu_shown.emit()
	
	if player_ref:
		player_ref.freeze()
	
	



func resume() -> void:
	get_tree().paused = false
	visible = false
	menu_hidden.emit()

	if player_ref:
		player_ref.unfreeze()
		
	
 

func _on_btn_resum_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	GlobalStat.reset_coins()  
	get_tree().paused = false  
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")
