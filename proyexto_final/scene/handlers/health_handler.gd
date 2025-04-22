class_name HealthHandler
extends Node2D

@export var max_health = 0
@export var death_handler : DeathHandler = null
@export_enum("Player", "Enemy") var type : String = "Player"

var current_health = 0

func _ready() -> void:
	set_max_health()

func set_max_health() -> void:
	current_health = max_health
	if type == "Player":
		SignalBus.emit_on_collectable_collected(max_health)

func damage(val: int) -> void:
	match type:
		"Player":
			SignalBus.emit_on_hit(1)
			current_health -= val
		"Enemy":
			current_health -= val
			
	if current_health <= 0:
		current_health = 0
		death_handler.death()

func handle_healing(value: int) -> void:
	current_health += value
