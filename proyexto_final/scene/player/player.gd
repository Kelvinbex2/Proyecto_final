@icon("res://Assets/svg/potriat.svg")
class_name Player
extends CharacterBody2D

@export var animatedSprite2D: AnimatedSprite2D = null
@onready var death_sound_player: AudioStreamPlayer2D = $DeathSoundPlayer

#region Handlers Region
@onready var hit_box_handler: HitBoxHandler = $HandlerContainer/HitBoxHandler
@onready var input_handler: InputHandler = $HandlerContainer/InputHandler
@onready var movement_handler: MovementHandler = $HandlerContainer/MovementHandler
@onready var jump_handler: JumpHandler = $HandlerContainer/JumpHandler
@onready var flip_handler: FlipHandler = $HandlerContainer/FlipHandler
@onready var gravity_handler: GravityHandler = $HandlerContainer/GravityHandler
@onready var health_handler: HealthHandler = $HandlerContainer/HealthHandler
@onready var collection_handler: CollectionHandler = $HandlerContainer/CollectionHandler

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
var game_state: GameState = null
var checkpoint_position: Vector2 = Vector2.ZERO
#var is_frozen := false




func _ready() -> void:
	is_dying = false
	
	handle_state_machine_signals()
	SignalBus.on_player_attack.connect(_on_player_attack)
	SignalBus.emit_on_player_ready(self)
	SignalBus.on_player_die.connect(_on_player_die)
	#SignalBus.emit_on_player_die()
	SignalBus.on_game_state_manager_ready.connect(_on_game_state_manager_ready)
	## on hit con parpadeo
	SignalBus.on_hit.connect(_on_hit)



	if SignalBus.game_state_manager != null:
		_on_game_state_manager_ready(SignalBus.game_state_manager)

func _physics_process(delta: float) -> void:
	if is_dying:
		return	
		
	gravity_handler.apply_gravity(self,delta)
	move_and_slide()
	flip_handler.handle_flip(self)
	

func _unhandled_input(event: InputEvent) -> void:
	if is_dying:
		return
		
	if event.is_action_pressed("interact"):
		SignalBus.emit_interact_pressed()


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
	
	freeze()
	
	if death_sound_player:
		death_sound_player.play()
		
	animatedSprite2D.play("die")
	await get_tree().create_timer(2.5).timeout
	
	
	GameOver.show_game_over_screen()
	#if checkpoint_position == Vector2.ZERO:
		#reload_scene_level()
		#GlobalStat.reset_coins()
	#else:
		#respawn_at_checkpoint()



func _on_game_state_manager_ready(gs: GameState) -> void:
	game_state = gs


	

func _on_player_die() -> void:
	
	if health_handler.current_health <= 0:
		is_dying = true
		##SignalBus.emit_on_player_die()
		play_death_animation()
		#queue_free()

func reload_scene() -> void:
	
	get_tree().reload_current_scene()
	GlobalStat.reset_coins()

func reload_scene_level() -> void:
	if game_state:
		game_state.restart_level()
	else:
		get_tree().reload_current_scene() 
	GlobalStat.reset_coins()

	
func _on_player_attack(attacking_player: Player) -> void:
	if is_dying :
		return
		
	if attacking_player == self:
		hit_box_handler.apply_hit()
		
		
func change_state(new_state: BasePlayerState) -> void:
	if is_dying :
		return
	player_state.change_state(new_state)


func freeze() -> void:
	set_physics_process(false)
	velocity = Vector2.ZERO  
	move_and_slide()
	
func unfreeze() -> void:
	set_physics_process(true)
	velocity = Vector2.ZERO  
	

func add_frutas():
	frutas += 1
	SignalBus.emit_on_fruta_recogida(frutas)
	



func reset_stats() -> void:
	frutas = 0
	SignalBus.emit_on_fruta_recogida(frutas)


func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos
	print("✔️ Checkpoint actualizado a:", pos)


func respawn_at_checkpoint() -> void:
	global_position = checkpoint_position
	velocity = Vector2.ZERO
	is_dying = false

	if health_handler:
		health_handler.reset_health()

	reset_stats()
	
	change_state(player_idle_state)
	unfreeze()

	SignalBus.emit_on_coin_counter_update(GlobalStat.get_current_coin())
	print("🔁 Jugador reapareció en el checkpoint con vida restaurada:", checkpoint_position)


func flash_on_damage(blinks := 6, interval := 0.1) -> void:
	var sprite := animatedSprite2D
	if sprite == null:
		return

	# Iniciar el parpadeo como una corrutina
	await _flash_coroutine(sprite, blinks, interval)


func _flash_coroutine(sprite: AnimatedSprite2D, blinks: int, interval: float) -> void:
	for i in blinks:
		sprite.visible = false
		await get_tree().create_timer(interval).timeout
		sprite.visible = true
		await get_tree().create_timer(interval).timeout


func _on_hit(val: int) -> void:
	if is_dying :
		return
	flash_on_damage()
