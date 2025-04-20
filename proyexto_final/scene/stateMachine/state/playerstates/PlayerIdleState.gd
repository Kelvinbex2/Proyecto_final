class_name PlayerIdleState
extends BasePlayerState

signal  enter_walk_sate
signal  enter_jump_state

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	set_physics_process(true)
	

func exit_state() ->void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	player.movement_handler.handle_decelartion(player,delta)
	
	if player.input_handler.handle_movement_input() !=Vector2.ZERO:
		enter_walk_sate.emit()
	
	if player.input_handler.handle_jump_input()==true:
		enter_jump_state.emit()
