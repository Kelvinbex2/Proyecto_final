extends CharacterBody2D

#region Handlers
@onready var ai_handler: AIHandler = $Handlers/AIHandler
@onready var flip_handler: FlipHandler = $Handlers/FlipHandler
@onready var gravity_handler: GravityHandler = $Handlers/GravityHandler
@onready var movement_handler: MovementHandler = $Handlers/MovementHandler
@onready var death_handler: DeathHandler = $Handlers/DeathHandler
@onready var health_handler: HealthHandler = $Handlers/HealthHandler
@onready var drop_handler: DropHandler = $Handlers/Drop_handler
@onready var hurt_box: HurtBox = $Handlers/HurtBox
@onready var hit_box_handler: HitBoxHandler = $Handlers/HitBoxHandler
#endregion

#region Nodes
@onready var start_position: Marker2D = $StartPosition
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
#endregion

#region Config
@export var detection_range := 200
@export var move_speed := 150
@export var flee_health_threshold := 1
#endregion

enum State { IDLE, CHASE, ATTACK, FLEE, RETURN }
var state = State.IDLE

var player: Player = null
var is_attacking := false
var is_dying := false
var is_knocked_back := false
var is_player_in_range := false

var knockback_time := 0.2
var knockback_timer := 0.0

var blood = load("res://scene/effect/blood_effect.tscn")

func _ready() -> void:
	hurt_box.area_entered.connect(on_player_hit)
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	SignalBus.on_player_ready.connect(func(p): player = p)
	SignalBus.on_player_respawned.connect(_on_player_respawned)

func _physics_process(delta: float) -> void:
	if player and player.health_handler.current_health <= 0:
		is_dying = true
		return
	if health_handler.is_dead or is_dying:
		return

	if is_knocked_back:
		handle_knockback(delta)
		return

	gravity_handler.apply_gravity(self, delta)

	match state:
		State.IDLE:
			handle_idle()
		State.CHASE:
			handle_chase()
		State.ATTACK:
			# Coroutine already handles this
			pass
		State.FLEE:
			handle_flee()
		State.RETURN:
			handle_return()

	move_and_slide()
	flip_handler.handle_flip(self)

	if health_handler.current_health <= flee_health_threshold and state != State.FLEE:
		state = State.FLEE

# ──────────────── STATE METHODS ──────────────── #

func handle_idle() -> void:
	velocity.x = 0
	animated_sprite.play("idle")

func handle_chase() -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * move_speed
	animated_sprite.play("run")

	if global_position.distance_to(player.global_position) < 50 and not is_attacking:
		state = State.ATTACK
		attack_loop()

func handle_flee() -> void:
	var direction = (start_position.global_position - global_position).normalized()
	velocity.x = direction.x * move_speed
	animated_sprite.play("run")

	if global_position.distance_to(start_position.global_position) < 10:
		state = State.RETURN

func handle_return() -> void:
	velocity.x = 0
	state = State.IDLE
	animated_sprite.play("idle")

# ──────────────── COMBAT ──────────────── #

func attack_loop() -> void:
	if is_attacking or health_handler.is_dead or is_dying:
		return

	is_attacking = true
	state = State.ATTACK

	while is_player_in_range and not health_handler.is_dead and not is_dying:
		hit_box_handler.collision_shape_2d.set_deferred("disabled", false)
		animated_sprite.play("hit")
		await animated_sprite.animation_finished

		hit_box_handler.collision_shape_2d.set_deferred("disabled", true)
		if not is_player_in_range:
			break

		await get_tree().create_timer(0.6).timeout

		animated_sprite.play("double_hit")
		await animated_sprite.animation_finished

	is_attacking = false
	if not health_handler.is_dead and not is_dying:
		state = State.CHASE

# ──────────────── SIGNAL HANDLERS ──────────────── #

func _on_detection_area_entered(body: Node) -> void:
	if body.is_in_group("Player") and state != State.FLEE and not is_dying:
		is_player_in_range = true
		player = body
		state = State.CHASE

func _on_detection_area_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = false
		if state == State.CHASE:
			state = State.RETURN

func on_player_hit(area: Area2D) -> void:
	if is_dying:
		return

	var direction = sign(global_position.x - area.global_position.x)
	velocity.x = direction * 150
	is_knocked_back = true
	knockback_timer = knockback_time
	drop_handler.add_coin(1)
	start_blink()

func _on_player_respawned() -> void:
	is_dying = false
	state = State.IDLE

# ──────────────── UTILITIES ──────────────── #

func handle_knockback(delta: float) -> void:
	knockback_timer -= delta
	if knockback_timer <= 0:
		is_knocked_back = false

func start_blink() -> void:
	for i in range(5):
		animated_sprite.modulate.a = 0.0
		await get_tree().create_timer(0.1).timeout
		animated_sprite.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout

func play_death_animation() -> void:
	is_dying = true
	is_attacking = false
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	queue_free()
