class_name Player
extends CharacterBody2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
#region Handlers Region

@onready var input_handler: InputHandler = $HandlerContainer/InputHandler
@onready var movement_handler: MovementHandler = $HandlerContainer/MovementHandler
@onready var jump_handler: JumpHandler = $HandlerContainer/JumpHandler
@onready var flip_handler: FlipHandler = $HandlerContainer/FlipHandler
@onready var gravity_handler: GravityHandler = $HandlerContainer/GravityHandler
#endregion
#region StateMachine Region

@onready var player_state: PlayerState = $PlayerState
@onready var player_idle_state: PlayerIdleState = $PlayerState/PlayerIdleState
@onready var player_walk_state: PlayerWalkState = $PlayerState/PlayerWalkState
@onready var player_jump_state: PlayerJumpState = $PlayerState/PlayerJumpState
@onready var player_fall_state: PlayerFallState = $PlayerState/PlayerFallState

#endregion

func _ready() -> void:
	handle_state_machine_signals()
	SignalBus.emit_on_player_ready(self)

func _physics_process(delta: float) -> void:
	
	gravity_handler.apply_gravity(self,delta)
	jump_handler.handle_jump(self,input_handler.handle_jump_input())
	move_and_slide()

	flip_handler.handle_flip(self)
	handle_animation()


func handle_state_machine_signals() -> void:
	player_idle_state.enter_walk_sate.connect(player_state.change_state.bind(player_walk_state))
	player_idle_state.enter_jump_state.connect(player_state.change_state.bind(player_jump_state))
	player_walk_state.enter_idle_sate.connect(player_state.change_state.bind(player_idle_state))
	player_walk_state.enter_jump_state.connect(player_state.change_state.bind(player_jump_state))
	player_jump_state.enter_fall_state.connect(player_state.change_state.bind(player_fall_state))
	player_fall_state.enter_idle_state.connect(player_state.change_state.bind(player_idle_state))
	
	
func handle_animation() -> void:
	if not is_on_floor():
		animatedSprite2D.play("jump")
	elif abs(velocity.x) < 1:
		animatedSprite2D.play("idle")
	else:
		animatedSprite2D.play("run")
