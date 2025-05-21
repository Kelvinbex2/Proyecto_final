class_name PlayerCamera
extends Camera2D

@export_range(0.0, 10.0, 0.1) var follow_speed: float = 5.0
@export var camera_offset: Vector2 = Vector2.ZERO

var player: Player = null

func _ready() -> void:
	SignalBus.on_player_ready.connect(set_target)
	make_current()  # Esta cámara se activa automáticamente


func _physics_process(delta: float) -> void:
	if player:
		follow_target(delta)


func set_target(target: Player) -> void:
	if target == null:
		return
	player = target
	global_position = player.global_position + camera_offset


func follow_target(delta: float) -> void:
	var target_position = player.global_position + camera_offset
	global_position = global_position.lerp(target_position, follow_speed * delta)
