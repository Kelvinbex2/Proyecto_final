class_name FlipHandler
extends Node2D

func handle_flip(body: CharacterBody2D) -> void:
	var sprite = body.get_node_or_null("AnimatedSprite2D")
	if sprite and sprite is AnimatedSprite2D:
		if body.velocity.x < 0:
			sprite.flip_h = true
		elif body.velocity.x > 0:
			sprite.flip_h = false
