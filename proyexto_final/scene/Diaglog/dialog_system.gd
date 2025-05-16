@tool
class_name DialogSysytemNode 
extends CanvasLayer

@onready var label: Label = $DialogUI/DialogProgressIndicator/Label
@onready var potrait_sprite: Sprite2D = $DialogUI/PotraitSprite
@onready var dialog_progress_indicator: PanelContainer = $DialogUI/DialogProgressIndicator
@onready var name_label: Label = $DialogUI/NameLabel
@onready var content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var dialog_ui: Control = $DialogUI

signal finished
var is_active : bool = false
var dialog_items : Array [DialogItem]
var dialog_index : int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	hide_dialog()


func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	
	if(event.is_action_pressed("interact") or event.is_action_pressed("space") or event.is_action_pressed("ui_accept")):
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
	if dialog_items.size() == 0:
		hide_dialog()
	else:
		start_dialog()
	pass

		

func hide_dialog()-> void:
	is_active = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	
	
	
func start_dialog() -> void:
	show_dialog_button_indicator( true )
	var _d : DialogItem = dialog_items[dialog_index]
	set_dialog_data(_d)


func set_dialog_data( _d : DialogItem ) -> void:
	if _d is DialogText:
		content.text = _d.text
	name_label.text = _d.npc_info.npc_name
	potrait_sprite.texture = _d.npc_info.potrait
	
	

func show_dialog_button_indicator( _is_visible : bool ) -> void:
	dialog_progress_indicator.visible = _is_visible
	if dialog_index + 1 < dialog_items.size():
		label.text = "NEXT"
	else:
		label.text = "END"
