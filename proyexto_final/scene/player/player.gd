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
@onready var health_handler: HealthHandler = $HandlerContainer/HealthHandler

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
@onready var player_death_state: PlayerDeathState = $PlayerState/PlayerDeathState

#endregion



var frutas :int =0
var is_dying := false


func _ready() -> void:
	handle_state_machine_signals()
	SignalBus.on_player_attack.connect(_on_player_attack)
	SignalBus.emit_on_player_ready(self)
	SignalBus.on_player_die.connect(_on_player_die)


func _physics_process(delta: float) -> void:
	if get_tree().paused:
		print("🚨 Player is running while paused!")
		return
		
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
	player_idle_state.enter_attack_state.connect(player_state.change_state.bind(player_attack_state))
	player_attack_state.enter_idle_state.connect(player_state.change_state.bind(player_idle_state))



func play_death_animation() -> void:
	if is_dying:
		return
	is_dying = true

	animatedSprite2D.play("die")

	await get_tree().create_timer(2.5).timeout  
	call_deferred("reload_scene")




func _on_player_die() -> void:
	play_death_animation()

func reload_scene() -> void:
	
	get_tree().reload_current_scene()
	GlobalStat.reset_coins()
	
	
func _on_player_attack(attacking_player: Player) -> void:
	if attacking_player == self:
		hit_box_handler.apply_hit()
		
func change_state(new_state: BasePlayerState) -> void:
	player_state.change_state(new_state)


func freeze() -> void:
	set_physics_process(false)
	
func unfreeze() -> void:
	set_physics_process(true)
	velocity = Vector2.ZERO  

func add_frutas():
	frutas += 1
	SignalBus.emit_on_fruta_recogida(frutas)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		SignalBus.emit_interact_pressed()
