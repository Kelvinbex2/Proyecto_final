extends CanvasLayer
@export var button_focus_audio : AudioStream = preload("res://Assets/audio/menu_focus.wav")
@export var button_selected_audio : AudioStream = preload("res://Assets/audio/menu_select.wav")

@onready var control: Control = $Control
@onready var btn_con: Button = $Control/VBoxContainer/btnCon
@onready var btn_title: Button = $Control/VBoxContainer/btnTitle

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	hide_game_over_screen()
	btn_con.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	btn_con.pressed.connect( load_game )
	btn_title.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	btn_title.pressed.connect( title_screen )
	
	

func hide_game_over_screen() -> void:
	control.visible = false
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control.modulate = Color(1,1,1,0)
	
func show_game_over_screen() -> void:
	control.visible = true
	control.mouse_filter = Control.MOUSE_FILTER_STOP
	
	btn_con.visible 
	animation_player.play("show_game_over")
	await  animation_player.animation_finished
	
	btn_con.grab_focus()
	
	
func play_audio(_a : AudioStream) -> void:
	audio.stream = _a
	audio.play()


func load_game()-> void:
	play_audio(button_selected_audio)
	await  fade_game_over_Screen()
	#call my load scene 

func title_screen() -> void:
	play_audio(button_selected_audio)
	await fade_game_over_Screen()
	#load main scene 
	
func fade_game_over_Screen() -> bool: 
	animation_player.play("fade_tp_black")
	await animation_player.animation_finished
	
	return true
