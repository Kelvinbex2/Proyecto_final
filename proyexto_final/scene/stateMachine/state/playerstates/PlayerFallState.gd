class_name PlayerFallState
extends BasePlayerState

signal enter_idle_state
signal enter_stomp_state

@export var stomp_trans =100

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	if player.is_dying:
		return
	set_physics_process(true)
	player.animatedSprite2D.play("fall")
	
	

func exit_state() ->void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	if player.is_dying:
		return
	player.movement_handler.handle_movement(player,player.input_handler.handle_movement_input(),delta)
	
	if player.is_on_floor() ==true:
		enter_idle_state.emit()

	if player.velocity.y > stomp_trans:
		enter_stomp_state.emit()
		
