@tool
class_name DialogInterraction extends Area2D

@export var enabled : bool = true
@onready var animation: AnimationPlayer = $AnimationPlayer

signal player_interacted
signal finished
var dialog_items : Array[DialogItem]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
		
	for i in get_children():
		if i is DialogItem:
			dialog_items.append(i)

func player_interact() -> void:
	player_interacted.emit()
	DialogSystem.show_dialog(dialog_items)
	

func _on_area_enter(_a :Area2D ) -> void:
	if enabled == false || dialog_items.size() ==0:
		return
		
	animation.play("show")
	SignalBus.interact_pressed.connect(player_interact)
	player_interact()
	
	
func _on_area_exit(_a :Area2D ) -> void:
	animation.play("hide")
	SignalBus.interact_pressed.disconnect(player_interact)
	DialogSystem.hide_dialog()
	finished.emit()
	
	
func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_item() == false:
		return ["Se requiere al menos un nodo DialogItem."]
	else:
		return[]
	

func _check_for_dialog_item() -> bool:
	for i in get_children():
		if i is DialogItem:
			return true
	return false
