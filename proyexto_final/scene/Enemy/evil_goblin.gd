extends CharacterBody2D
#region handlers
@onready var ai_handler: AIHandler = $handlers/AIHandler
@onready var flip_handler: FlipHandler = $handlers/FlipHandler
@onready var gravity_handler: GravityHandler = $handlers/GravityHandler
@onready var movement_handler: MovementHandler = $handlers/MovementHandler
@onready var death_handler: DeathHandler = $handlers/DeathHandler
@onready var drop_handler: DropHandler = $handlers/DropHandler
@onready var health_handler: HealthHandler = $handlers/HealthHandler
@onready var hurt_box: HurtBox = $handlers/HurtBox
@onready var hit_box_handler: HitBoxHandler = $handlers/HitBoxHandler
#endregion
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D



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
	animated.frame_changed.connect(_on_frame_changed)



	

func _physics_process(delta: float) -> void:
	if player and player.health_handler.current_health <= 0:
		is_dying = true
		return

	if health_handler.is_dead or is_dying:
		return

	#if is_knocked_back:
		#knockback_timer -= delta
		#if knockback_timer <= 0.0:
			#is_knocked_back = false
		move_and_slide()
		#return

	if is_attacking:
		return

	gravity_handler.apply_gravity(self, delta)
	ai_handler.handle_state(self, delta)
	move_and_slide()
	flip_handler.handle_flip(self)

	

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
		animated.modulate.a = 0.0  
		await get_tree().create_timer(blink_interval).timeout
		animated.modulate.a = 1.0  
		await get_tree().create_timer(blink_interval).timeout


func _on_detection_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = true
		player = body

		if body.global_position.x < global_position.x:
			velocity.x = -1
		else:
			velocity.x = 1

		flip_handler.handle_flip(self)

		if not is_attacking and not is_dying:
			attack_loop()

func _on_detection_area_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = false

func attack_loop() -> void:
	if is_attacking or health_handler.is_dead or is_dying:
		return
		
	is_attacking = true

	while is_player_in_range and not health_handler.is_dead and not is_dying:
		animated.play("hit")
		await animated.animation_finished

		if not is_player_in_range or health_handler.is_dead:
			break

		await get_tree().create_timer(1.0).timeout

	is_attacking = false

	if not health_handler.is_dead and not is_dying:
		animated.play("walk")


func play_death_animation() -> void:
	print("💀 Reproduciendo animación 'die'")
	is_dying = true
	is_attacking = false
	if audio:
		audio.play()
		await get_tree().create_timer(0.2).timeout
		audio.stop()
		
	animated.play("die")
	await animated.animation_finished
	queue_free()


func _on_player_respawned() -> void:
	print("🔁 Jugador revivió, reactivando enemigo")
	is_dying = false

func enable_hitbox() -> void:
	hit_box_handler.collision_shape_2d.set_deferred("disabled", false)

func disable_hitbox() -> void:
	hit_box_handler.collision_shape_2d.set_deferred("disabled", true)

func _on_frame_changed() -> void:
	var current_anim := animated.animation
	var frame := animated.frame

	match current_anim:
		"hit":
			if frame == 3:
				enable_hitbox()
			else:
				disable_hitbox()
		"double_hit":
			if frame == 1:
				enable_hitbox()
			else:
				disable_hitbox()
		_:
			disable_hitbox()
