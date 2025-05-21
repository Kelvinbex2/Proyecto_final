extends CanvasLayer

@export var button_focus_audio : AudioStream = preload("res://Assets/audio/menu_focus.wav")
@export var button_selected_audio : AudioStream = preload("res://Assets/audio/menu_select.wav")
@export var game_over_bgm : AudioStream = preload("res://Assets/audio/Breathless_Oblivion.wav")

@onready var control: Control = $Control
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var btn_con: Button = $Control/VBoxContainer/btnCon
@onready var btn_title: Button = $Control/VBoxContainer/btnTitle
@onready var audio_bgm: AudioStreamPlayer = $AudioStreamPlayerBGM

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var player: Player = null

func _ready() -> void:
	hide_game_over_screen()
	btn_con.focus_entered.connect(play_audio.bind(button_focus_audio))
	btn_con.pressed.connect(load_game)
	btn_title.focus_entered.connect(play_audio.bind(button_focus_audio))
	btn_title.pressed.connect(title_screen)
	
	SignalBus.on_player_ready.connect(func(p): player = p)


func hide_game_over_screen() -> bool:
	if control == null:
		push_error("Control node is missing!")
		return false
	control.visible = false
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control.modulate = Color(1, 1, 1, 0)
	return true


func show_game_over_screen() -> void:
	control.visible = true
	control.mouse_filter = Control.MOUSE_FILTER_STOP
	control.modulate = Color(1, 1, 1, 1)

	btn_con.visible = true
	btn_con.disabled = false
	btn_title.disabled = false
	
	audio_bgm.stream = game_over_bgm
	audio_bgm.play()
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished

	btn_con.grab_focus()

func play_audio(_a: AudioStream) -> void:
	audio.stream = _a
	audio.play()

# 🕹 Carga la partida desde el checkpoint
func load_game() -> void:
	disable_buttons()
	audio_bgm.stop()
	play_audio(button_selected_audio)
	await fade_game_over_screen()
	hide_game_over_ui()
	if player:
		player.is_dying = false  
		player.unfreeze()
		player.respawn_at_checkpoint()



func title_screen() -> void:
	disable_buttons()
	audio_bgm.stop()
	play_audio(button_selected_audio)
	await fade_game_over_screen()
	hide_game_over_ui()
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")


func fade_game_over_screen() -> bool:
	animation_player.play("fade_tp_black")
	await animation_player.animation_finished
	return true


func hide_game_over_ui() -> void:
	control.visible = false
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control.modulate = Color(1, 1, 1, 0)


func disable_buttons() -> void:
	btn_con.disabled = true
	btn_title.disabled = true
