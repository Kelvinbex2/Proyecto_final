@tool
class_name DialogSysytemNode 
extends CanvasLayer


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
