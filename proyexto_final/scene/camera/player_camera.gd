class_name PlayerCamera
extends Camera2D

@export_range(0.0,1.0) var camera_move_speed 
@export var camera_offset : Vector2 = Vector2.ZERO
var player : Player = null

func _ready() -> void:
	SignalBus.on_player_ready.connect(set_target)
	
	
func _physics_process(delta: float) -> void:
	follow_target(delta)


func set_target(target : Player) -> void:
	if target == null:
		return
	player = target


func follow_target(delta: float) -> void:
	if player == null:
		return
	
	position = lerp(position,player.position + camera_offset,camera_move_speed)
