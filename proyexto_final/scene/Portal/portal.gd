extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var activated := false

func _ready():
	connect("body_entered", _on_body_entered)
	# Establecer animación cerrada al inicio
	animated_sprite.play("close")

func _on_body_entered(body: Node) -> void:
	if activated:
		return

	if body is Player:
		activated = true
		if animated_sprite.sprite_frames.has_animation("open"):
			animated_sprite.play("open")
			await animated_sprite.animation_finished  # Espera que termine la animación

		SignalBus.emit_signal("on_portal_triggered")
		set_deferred("monitoring", false)
