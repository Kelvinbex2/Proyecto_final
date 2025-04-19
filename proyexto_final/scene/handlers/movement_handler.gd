class_name MovementHandler
extends Node2D

@export var move_speed: float  = 0.0
@export var acceleration : float =0.0
@export var decceleration : float =0.0

func handle_movement(body : CharacterBody2D, input_direc : Vector2, delta :float) -> void:

	if input_direc.x < 0 :
		body.velocity.x = lerp(body.velocity.x, -move_speed,acceleration*delta)
		return
	if input_direc.x > 0:
		body.velocity.x = lerp(body.velocity.x, +move_speed,acceleration*delta)
		return
	handle_decelartion(body,delta)

func handle_decelartion(body: CharacterBody2D, delta : float) -> void:
	body.velocity.x =lerp(body.velocity.x,0.0,decceleration *delta)
