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
		
	for i in get_children():
		if i is DialogItem:
			dialog_items.append(i)


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
