extends CharacterBody2D

#region handlers
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

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_position: Marker2D = $StartPosition
@onready var detection_area: Area2D = $DetectionArea
@export var detection_range := 200
@export var move_speed := 150
@export var flee_health_threshold := 1

enum State { IDLE, CHASE, ATTACK, FLEE, RETURN }
var state:= State.IDLE

var is_attacking: bool = false
var is_player_in_range: bool = false
var is_dying: bool = false
var blood = load("res://scene/effect/blood_effect.tscn")
var player: Player = null

var knockback_time := 0.2
var knockback_timer := 0.0
var is_knocked_back := false

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
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
		else:
			move_and_slide()
			return

	gravity_handler.apply_gravity(self, delta)

	match state:
		State.IDLE:
			velocity.x = 0
			animated_sprite_2d.play("idle")
		
		State.CHASE:
			chase_player(delta)
		
		State.ATTACK:
			# attack handled in coroutine
			pass
		
		State.FLEE:
			flee_to_start(delta)
		
		State.RETURN:
			return_to_idle(delta)

	move_and_slide()
	flip_handler.handle_flip(self)

	if health_handler.current_health <= flee_health_threshold and state != State.FLEE:
		state = State.FLEE

func on_player_hit(area: Area2D) -> void:
	if is_dying:
		return

	var direction = sign(global_position.x - area.global_position.x)
	var knockback_force = 150.0
	velocity.x = direction * knockback_force
	is_knocked_back = true
	knockback_timer = knockback_time

	drop_handler.add_coin(1)
	start_blink()

func start_blink() -> void:
	var blink_times = 5
	var blink_interval = 0.1

	for i in range(blink_times):
		animated_sprite_2d.modulate.a = 0.0
		await get_tree().create_timer(blink_interval).timeout
		animated_sprite_2d.modulate.a = 1.0
		await get_tree().create_timer(blink_interval).timeout

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

func chase_player(delta: float) -> void:
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * move_speed
	if global_position.distance_to(player.global_position) < 50 and not is_attacking:
		state = State.ATTACK
		attack_loop()

func flee_to_start(delta: float) -> void:
	var direction = (start_position.global_position - global_position).normalized()
	velocity.x = direction.x * move_speed
	if global_position.distance_to(start_position.global_position) < 10:
		state = State.RETURN

func return_to_idle(delta: float) -> void:
	velocity.x = 0
	state = State.IDLE

func attack_loop() -> void:
	if is_attacking or health_handler.is_dead or is_dying:
		return

	is_attacking = true
	state = State.ATTACK

	while is_player_in_range and not health_handler.is_dead and not is_dying:
		print("👊 Attacking player")
		hit_box_handler.collision_shape_2d.set_deferred("disabled", false)
		animated_sprite_2d.play("hit")
		await animated_sprite_2d.animation_finished
		hit_box_handler.collision_shape_2d.set_deferred("disabled", true)

		if not is_player_in_range or health_handler.is_dead:
			break

		await get_tree().create_timer(1.0).timeout

		animated_sprite_2d.play("double_hit")
		await animated_sprite_2d.animation_finished

	is_attacking = false
	if not health_handler.is_dead and not is_dying:
		state = State.CHASE

func play_death_animation() -> void:
	print("💀 Playing 'die' animation")
	is_dying = true
	is_attacking = false

	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_player_respawned() -> void:
	print("🔁 Player respawned, reactivating boss")
	is_dying = false
	state = State.IDLE
