class_name PlayerStompState
extends BasePlayerState

signal enter_idle_state
signal enter_bounce_state

@export var stomp_box_handler: HurtBox = null

func _ready() -> void:
	stomp_box_handler.area_entered.connect(on_stomp_hit)
	set_physics_process(false)
	
func enter_state() ->void:
	stomp_box_handler.collision_shape_2d.disabled = false
	set_physics_process(true)
	

func exit_state() ->void:
	stomp_box_handler.collision_shape_2d.set_deferred("disabled",true)
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	player.movement_handler.handle_movement(player,player.input_handler.handle_movement_input(),delta)
	
	if player.is_on_floor() ==true:
		enter_idle_state.emit()


func on_stomp_hit(area: Area2D) -> void:
	if not area is HitBoxHandler:
		return
	enter_bounce_state.emit()
