class_name PlayerDeathState
extends BasePlayerState

func _ready() -> void:
	set_physics_process(false)

func enter_state() -> void:
	set_physics_process(true)
	player.velocity = Vector2.ZERO
	player.animatedSprite2D.play("die")

	await player.animatedSprite2D.animation_finished

	get_tree().reload_current_scene()

func exit_state() -> void:
	set_physics_process(false)
