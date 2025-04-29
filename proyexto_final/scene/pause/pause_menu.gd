extends Control

func _ready() -> void:
	visible = false 
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause() -> void:
	get_tree().paused = true
	visible = true  

func resume() -> void:
	get_tree().paused = false
	visible = false  

func _on_btn_resum_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	get_tree().paused = false  
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")
