class_name PlayerJumpState
extends BasePlayerState

signal  enter_fall_state

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	if player.is_dying:
		return
	set_physics_process(true)
	player.jump_handler.handle_jump(player,true)
	player.movement_handler.handle_movement(player,player.input_handler.handle_movement_input(),0)
	player.animatedSprite2D.play("jump")

func exit_state() ->void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	if player.is_dying:
		return
		
	player.jump_handler.handle_jump(player,true)
	player.movement_handler.handle_movement(player,player.input_handler.handle_movement_input(),delta)

	
	if player.velocity.y >  0:
		enter_fall_state.emit()
