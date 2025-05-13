extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("add_frutas"):
		body.add_frutas()
		queue_free()
