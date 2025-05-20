@tool
class_name DialogSysytemNode 
extends CanvasLayer

@onready var label: Label = $DialogUI/DialogProgressIndicator/Label
@onready var potrait_sprite: DialogPotrait = $DialogUI/PotraitSprite
@onready var dialog_progress_indicator: PanelContainer = $DialogUI/DialogProgressIndicator
@onready var name_label: Label = $DialogUI/NameLabel
@onready var content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var dialog_ui: Control = $DialogUI
@onready var timer: Timer = $DialogUI/Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogUI/AudioStreamPlayer

signal finished
signal letter_added(letter : String)

var is_active : bool = false
var dialog_items : Array [DialogItem]
var dialog_index : int = 0
var text :bool = false
var text_speed =0.03
var text_length = 0
var plain_text : String


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	timer.timeout.connect(_on_timer_timeout)
	hide_dialog()


func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	
	if( event.is_action_pressed("ui_accept")):
		
		
		if text ==true:
			content.visible_characters =text_length
			timer.stop()
			text = false
			show_dialog_button_indicator(true)
			return
		dialog_index +=1
		if dialog_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()

	
	
		

func show_dialog( _items : Array[DialogItem])-> void:
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = _items
	dialog_index =0
	get_tree().paused = true
	await get_tree().process_frame
	start_dialog()
	

		

func hide_dialog()-> void:
	is_active = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	
	
	
func start_dialog() -> void:
	show_dialog_button_indicator( false )
	var _d : DialogItem = dialog_items[dialog_index]
	set_dialog_data(_d)
	
	content.visible_characters=0
	text_length = content.get_total_character_count()
	plain_text=content.get_parsed_text()
	text =true
	start_timer()


func set_dialog_data( _d : DialogItem ) -> void:
	if _d is DialogText:
		content.text = _d.text
	name_label.text = _d.npc_info.npc_name
	potrait_sprite.texture = _d.npc_info.potrait
	potrait_sprite.audio_pitch = _d.npc_info.dialogo_audio
	
	

func show_dialog_button_indicator( _is_visible : bool ) -> void:
	dialog_progress_indicator.visible = _is_visible
	if dialog_index + 1 < dialog_items.size():
		label.text = "NEXT"
	else:
		label.text = "END"


func start_timer() -> void:
	timer.wait_time = text_speed
	timer.start()


func _on_timer_timeout() -> void:
	content.visible_characters +=1
	if content.visible_characters <= text_length:
		letter_added.emit(plain_text[content.visible_characters - 1])
		start_timer()
	else:
		show_dialog_button_indicator(true)
		text = false
