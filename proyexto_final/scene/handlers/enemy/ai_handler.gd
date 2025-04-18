class_name AIHandler
extends Node2D

@export var left_cast : RayCast2D = null 
@export var right_cast : RayCast2D = null 
@export var left_wall_cast : RayCast2D = null 
@export var right_wall_cast : RayCast2D = null 
@export var movement : MovementHandler = null


enum {MOVE_LEFT,MOVE_RIGHT}

var current_state = MOVE_LEFT

func handle_state(body:CharacterBody2D, delta:float) -> void:
	check_state()
	match current_state:
		MOVE_LEFT:
			movement.handle_movement(body,Vector2.LEFT,delta)
		MOVE_RIGHT:
			movement.handle_movement(body,Vector2.RIGHT,delta)


func check_state() -> void:
	if left_cast.is_colliding() == false or left_wall_cast.is_colliding():
		current_state = MOVE_RIGHT
	if  right_cast.is_colliding() == false or right_wall_cast.is_colliding():
		current_state = MOVE_LEFT
