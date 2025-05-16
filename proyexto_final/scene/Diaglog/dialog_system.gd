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
	#if is_active == false:
	#	return
	
	if event.is_action_pressed("text"):
		if is_active == false:
			show_dialog(dialog_items)
		else:
			hide_dialog()
	
	
		

func show_dialog( _items : Array[DialogItem])-> void:
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	pass
		

func hide_dialog()-> void:
	is_active = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	pass
