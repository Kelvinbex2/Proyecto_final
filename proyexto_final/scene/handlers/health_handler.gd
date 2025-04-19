class_name HealthHandler
extends Node2D


@export var max_health =0
@export var death_handler : DeathHandler = null
@export_enum("Player", "Enemy") var type : String = "Player"

var current_health =0

func set_max_health(value : int) -> void:
	if value !=0:
		max_health = value
		current_health = max_health
		return
	current_health = max_health
	

func damage(val : int ) -> void:
	match type:
		"Player":
			SignalBus.emit_on_hit(1)
			current_health -=val
		"Enemy":
			current_health -=val
			
	current_health -=val
	
	if current_health <=0:
		current_health =0
		death_handler.death()
