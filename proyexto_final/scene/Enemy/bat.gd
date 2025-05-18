extends CharacterBody2D

#region Handlers
@onready var flip_handler: FlipHandler = $Handlers/FlipHandler
@onready var gravity_handler: GravityHandler = $Handlers/GravityHandler
@onready var movement_handler: MovementHandler = $Handlers/MovementHandler
@onready var death_handler: DeathHandler = $Handlers/DeathHandler
@onready var drop_handler: DropHandler = $Handlers/DropHandler
@onready var health_handler: HealthHandler = $Handlers/HealthHandler
@onready var hurt_box: HurtBox = $Handlers/HurtBox
@onready var hit_box_handler: HitBoxHandler = $Handlers/HitBoxHandler
@onready var ai_handler: AIHandler = $Handlers/AIHandler
#endregion

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@export var speed: float = 100.0
@export var dive_speed: float = 300.0
@export var hover_height: float = 50.0
@export var hover_amplitude: float = 30.0
@export var hover_frequency: float = 2.0

var player_ref: Node2D = null
var time: float = 0.0

enum {
	IDLE,
	EMERGING,
	FLYING,
	DIVING,
	RETURNING
}

var state = IDLE
var is_player_in_range = false
var dive_cooldown := 1.5
var time_since_last_dive := 0.0

func _ready():
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	health_handler.death_handler = death_handler
	animated.play("idle")

func _physics_process(delta: float) -> void:
	if health_handler.is_dead:
		return

	time += delta
	time_since_last_dive += delta

	match state:
		IDLE, EMERGING, RETURNING:
			velocity = Vector2.ZERO

		FLYING:
			if player_ref:
				var target_y = player_ref.global_position.y - hover_height
				var offset_x = sin(time * hover_frequency) * hover_amplitude
				var target_position = Vector2(player_ref.global_position.x + offset_x, target_y)

				var direction = (target_position - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
				animated.play("fly")
				flip_handler.handle_flip(self)

				# 🧠 Condición para iniciar picada
				if abs(global_position.x - player_ref.global_position.x) < 10.0 and time_since_last_dive > dive_cooldown:
					state = DIVING
					time_since_last_dive = 0.0

		DIVING:
			if player_ref:
				var direction = (player_ref.global_position - global_position).normalized()
				velocity = direction * dive_speed
				move_and_slide()
				animated.play("dive")
				flip_handler.handle_flip(self)

				# Opcional: volver a volar después de pasar por el jugador
				if global_position.y > player_ref.global_position.y + 30:
					state = RETURNING
					animated.play("nest_in")
					await animated.animation_finished
					_return_to_idle()

	if state == FLYING and player_ref:
		var distance = global_position.distance_to(player_ref.global_position)
		if distance > 500:
			_on_detection_area_exited(player_ref)

func _on_detection_area_entered(body: Node) -> void:
	if body.is_in_group("Player") and state == IDLE:
		is_player_in_range = true
		player_ref = body
		state = EMERGING
		animated.play("nest_out")
		await animated.animation_finished
		state = FLYING

func _on_detection_area_exited(body: Node) -> void:
	if body == player_ref and state in [FLYING, DIVING]:
		is_player_in_range = false
		player_ref = null
		state = RETURNING
		animated.play("nest_in")
		await animated.animation_finished
		_return_to_idle()

func _return_to_idle():
	state = IDLE
	animated.play("idle")

func play_death_animation() -> void:
	print("☠️ Animación de muerte iniciada")
	state = IDLE
	velocity = Vector2.ZERO
	player_ref = null

	if death_sound:
		death_sound.play()

	animated.play("die")
	await animated.animation_finished
	queue_free()
