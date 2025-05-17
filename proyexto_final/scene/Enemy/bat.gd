extends CharacterBody2D

@onready var flip_handler: FlipHandler = $Handlers/FlipHandler
@onready var gravity_handler: GravityHandler = $Handlers/GravityHandler
@onready var movement_handler: MovementHandler = $Handlers/MovementHandler
@onready var death_handler: DeathHandler = $Handlers/DeathHandler
@onready var drop_handler: DropHandler = $Handlers/DropHandler
@onready var health_handler: HealthHandler = $Handlers/HealthHandler
@onready var hurt_box: HurtBox = $Handlers/HurtBox
@onready var hit_box_handler: HitBoxHandler = $Handlers/HitBoxHandler

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@export var speed: float = 100.0

var player_ref: Node2D = null

enum {
	IDLE,
	EMERGING,
	FLYING,
	RETURNING
}

var state = IDLE
var is_player_in_range = false

func _ready():
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	health_handler.death_handler = death_handler
	animated.play("idle")

func _physics_process(delta: float) -> void:
	if health_handler.is_dead:
		return

	match state:
		IDLE, EMERGING, RETURNING:
			velocity = Vector2.ZERO

		FLYING:
			if player_ref:
				var direction = (player_ref.global_position - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
				animated.play("fly")
				flip_handler.handle_flip(self)

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
	if body == player_ref and state == FLYING:
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
