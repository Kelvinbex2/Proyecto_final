class_name Player
extends CharacterBody2D

@export var animatedSprite2D: AnimatedSprite2D = null
#region Handlers Region
@onready var hit_box_handler: HitBoxHandler = $HandlerContainer/HitBoxHandler
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
@onready var player_stomp_state: PlayerStompState = $PlayerState/PlayerStompState
@onready var player_bounce_state: PlayerBounceState = $PlayerState/PlayerBounceState
@onready var player_attack_state: PlayerAttackState = $PlayerState/PlayerAttackState

#endregion

func _ready() -> void:
	handle_state_machine_signals()
	SignalBus.on_player_attack.connect(_on_player_attack)
	SignalBus.emit_on_player_ready(self)
	

func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self,delta)
	move_and_slide()

	flip_handler.handle_flip(self)
	


func handle_state_machine_signals() -> void:
	player_idle_state.enter_walk_sate.connect(player_state.change_state.bind(player_walk_state))
	player_idle_state.enter_jump_state.connect(player_state.change_state.bind(player_jump_state))
	player_walk_state.enter_idle_sate.connect(player_state.change_state.bind(player_idle_state))
	player_walk_state.enter_jump_state.connect(player_state.change_state.bind(player_jump_state))
	player_walk_state.enter_fall_state.connect(player_state.change_state.bind(player_fall_state))
	player_jump_state.enter_fall_state.connect(player_state.change_state.bind(player_fall_state))
	player_fall_state.enter_idle_state.connect(player_state.change_state.bind(player_idle_state))
	player_fall_state.enter_stomp_state.connect(player_state.change_state.bind(player_stomp_state))
	player_stomp_state.enter_idle_state.connect(player_state.change_state.bind(player_idle_state))
	player_stomp_state.enter_bounce_state.connect(player_state.change_state.bind(player_bounce_state))
	player_bounce_state.enter_fall_state.connect(player_state.change_state.bind(player_fall_state))
	#player_idle_state.enter_attack_state.connect(player_state.change_state.bind(player_attack_state))
	#player_attack_state.enter_idle_state.connect(player_state.change_state.bind(player_idle_state))


func play_death_animation() -> void:
	animatedSprite2D.play("die")
	await animatedSprite2D.animation_finished
	get_tree().reload_current_scene()


func _on_player_attack(attacking_player: Player) -> void:
	if attacking_player == self:
		hit_box_handler.apply_hit()
