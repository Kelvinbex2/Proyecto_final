class_name FlipHandler
extends Node2D




func handle_flip(body: CharacterBody2D) -> void:
	if body.velocity.x < 0:
		body.ani_player.flip_h = true
	elif body.velocity.x > 0:
		body.ani_player.flip_h = false
