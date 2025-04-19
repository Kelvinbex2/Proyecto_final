class_name HitBoxHandler
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var invul_timer: Timer = $InvulTimer
@export var time  =0
signal  on_hit

func _ready() -> void:
	on_hit.connect(on_area_hit)
	invul_timer.timeout.connect(in_invuln_timer_timeout)

func on_area_hit() -> void:
	apply_hit()
	print("hit")
	SignalBus.emit_on_hit(1)
	
func in_invuln_timer_timeout() -> void:
	collision_shape_2d.disabled = false
	print("fin")
	
func apply_hit() -> void:
	collision_shape_2d.set_deferred("disabled",true)
	print("Started")
	invul_timer.start(time)
