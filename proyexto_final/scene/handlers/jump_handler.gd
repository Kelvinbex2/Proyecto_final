class_name  JumpHandler
extends Node2D
@export var jump_speed = 300

func handle_jump(body: CharacterBody2D, is_jumping: bool) -> void:
	if is_jumping and  body.is_on_floor():
		body.velocity.y = -jump_speed
