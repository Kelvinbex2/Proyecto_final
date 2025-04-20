class_name PlayerJumpState
extends BasePlayerState

signal  enter_fall_state

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	set_physics_process(true)
	player.jump_handler.handle_jump(player,true)
	

func exit_state() ->void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	player.jump_handler.handle_jump(player,true)
	
	if player.velocity.y >  0:
		enter_fall_state.emit()
