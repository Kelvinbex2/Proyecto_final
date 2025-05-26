class_name PlayerCamera
extends Camera2D

@export_range(0.0, 10.0, 0.1) var follow_speed: float = 5.0
@export var camera_offset: Vector2 = Vector2.ZERO
@export var shake_strength := 10.0  # Fuerza de la sacudida

var shake_timer := 0.0
var player: Player = null

func _ready() -> void:
	SignalBus.on_player_ready.connect(set_target)
	SignalBus.on_camera_shake.connect(start_shake)  # ✅ Se conecta a la señal de sacudida
	make_current()

func _physics_process(delta: float) -> void:
	if player:
		follow_target(delta)

	if shake_timer > 0:
		shake_timer -= delta
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO

func set_target(target: Player) -> void:
	if target == null:
		return
	player = target
	global_position = player.global_position + camera_offset

func follow_target(delta: float) -> void:
	var target_position = player.global_position + camera_offset
	global_position = global_position.lerp(target_position, follow_speed * delta)

func start_shake(duration: float) -> void:
	shake_timer = duration
