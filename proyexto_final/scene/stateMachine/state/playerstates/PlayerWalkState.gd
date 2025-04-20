class_name PlayerWalkState
extends BasePlayerState

signal enter_idle_sate
signal enter_jump_state
signal enter_fall_state

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	set_physics_process(true)
	player.movement_handler.handle_movement(player,player.input_handler.handle_movement_input(),0)

func exit_state() ->void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	player.movement_handler.handle_movement(player,player.input_handler.handle_movement_input(),delta)
	
	if player.input_handler.handle_movement_input()==Vector2.ZERO:
		enter_idle_sate.emit()
		
	if player.input_handler.handle_jump_input()==true:
		enter_jump_state.emit()

	if player.velocity.y > 0:
		enter_fall_state.emit()
