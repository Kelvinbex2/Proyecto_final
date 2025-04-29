class_name PlayerIdleState
extends BasePlayerState

signal  enter_walk_sate
signal  enter_jump_state
signal enter_attack_state 

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	set_physics_process(true)
	player.animatedSprite2D.play("idle")
	

func exit_state() ->void:
	set_physics_process(false)





func _physics_process(delta: float) -> void:
	player.movement_handler.handle_decelartion(player, delta)

	if player.input_handler.handle_movement_input() != Vector2.ZERO:
		enter_walk_sate.emit()
		return
	
	if player.input_handler.handle_jump_input():
		enter_jump_state.emit()
		return

	
	if Input.is_action_just_pressed("space"):
		enter_attack_state.emit()
		return
