class_name PauseMenu
extends Control

signal menu_shown
signal menu_hidden

var player_ref: Player = null
@onready var item_desc: Label = $itemDesc
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

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
	resume()
	GlobalStat.reset_coins()
	SignalBus.emit_on_fruta_recogida(0)
	get_tree().paused = false
	
	var game_state = SignalBus.get_game_state_manager()
	if game_state:
		game_state.restart_level()



func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")



func update_item_description(new_text :String) -> void:
	item_desc.text = new_text


func play_audio(sound:AudioStream) -> void:
	audio_stream_player.stream = sound
	audio_stream_player.play()
