class_name AIHandler
extends Node2D

@export var left_cast : RayCast2D = null 
@export var right_cast : RayCast2D = null 
@export var left_wall_cast : RayCast2D = null 
@export var right_wall_cast : RayCast2D = null 
@export var movement : MovementHandler = null


enum { MOVE_LEFT, MOVE_RIGHT, ATTACK }


var current_state = MOVE_LEFT
var player_in_range: bool = false


func handle_state(body:CharacterBody2D, delta:float) -> void:
	check_state()
	match current_state:
		MOVE_LEFT:
			movement.handle_movement(body,Vector2.LEFT,delta)
		MOVE_RIGHT:
			movement.handle_movement(body,Vector2.RIGHT,delta)
		ATTACK:
			if body.has_method("play_hit_animation"):
				body.play_hit_animation()


func check_state() -> void:
	if player_in_range:
		current_state = ATTACK
		return
	if not left_cast.is_colliding() or left_wall_cast.is_colliding():
		current_state = MOVE_RIGHT
	elif not right_cast.is_colliding() or right_wall_cast.is_colliding():
		current_state = MOVE_LEFT
