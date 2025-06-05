extends MarginContainer

@export var menu_screen : VBoxContainer
@export var open_menu_screen : VBoxContainer

func toggle_visibility(object) -> void:
	if object.visible:
		object.visible = false
	else:
		object.visible = true
	


func _on_toggle_button_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)
