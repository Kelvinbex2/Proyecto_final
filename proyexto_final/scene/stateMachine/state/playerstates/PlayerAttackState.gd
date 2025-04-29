class_name PlayerAttackState
extends BasePlayerState

signal enter_idle_state

func _ready() -> void:
	set_physics_process(false)

func enter_state() -> void:
	set_physics_process(true)

	player.animatedSprite2D.play("attack")
	SignalBus.emit_on_player_attack(player)  # Emit signal to activate HitBox

	await player.animatedSprite2D.animation_finished
	enter_idle_state.emit()

func exit_state() -> void:
	set_physics_process(false)
