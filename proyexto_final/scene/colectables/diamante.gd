extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play("diamante")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_group("Player", "add_frutas")
		queue_free()
