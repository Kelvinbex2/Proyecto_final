class_name  GravityHandler
extends Node2D
const GRAVITY : int = 600


func apply_gravity(body: CharacterBody2D , delta: float) -> void:
	if not  body.is_on_floor():
		body.velocity.y += GRAVITY * delta
