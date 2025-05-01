class_name InputHandler
extends Node2D


func handle_movement_input() -> Vector2:
	var movement_direc : Vector2 = Vector2.ZERO
	
	movement_direc.x = Input.get_axis("move_left","move_right")
	

	return movement_direc

func handle_jump_input() -> bool:
	if get_tree().paused:
		return false
	return Input.is_action_just_pressed("jump_up")
