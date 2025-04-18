class_name MovementHandler
extends Node2D

@export var move_speed : int = 0

func handle_movement(body : CharacterBody2D, input_direc : float, delta :float) -> void:
	handle_decelartion(body,delta)
	if input_direc < 0 :
		body.velocity.x = -move_speed * delta
		
	if input_direc > 0:
		body.velocity.x = +move_speed * delta



func handle_decelartion(body: CharacterBody2D, delta : float) -> void:
	body.velocity.x =0
