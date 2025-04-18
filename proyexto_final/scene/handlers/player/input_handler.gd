class_name InputHandler
extends Node2D


func handle_movement_input() -> float:
	return Input.get_axis("move_left", "move_right")

func handle_jump_input() -> bool:
	return Input.is_action_just_pressed("jump_up")
