class_name HealthHandler
extends Node2D

@export var max_health = 0
@export var death_handler : DeathHandler = null
@export_enum("Player", "Enemy") var type : String = "Player"

var current_health = 0
var is_dead := false

func _ready() -> void:
	set_max_health()

func set_max_health() -> void:
	current_health = max_health
	is_dead=false
	if type == "Player":
		max_health = GlobalStat.get_current_coin()
		current_health = max_health

func damage(val: int) -> void:
	if is_dead: 
		return
		
	match type:
		"Player":
			SignalBus.emit_on_hit(1)
			current_health -= val
			
		"Enemy":
			current_health -= val
			
	if current_health <= 0:
		current_health = 0
		is_dead = true
		death_handler.death()

func handle_healing(value: int) -> void:
	current_health += value

	if type == "Player":
		GlobalStat.currently_held_coins = clamp(current_health, 0, max_health)
		SignalBus.emit_on_coin_counter_update(GlobalStat.currently_held_coins)


func reset_health() -> void:
	current_health = max_health
	is_dead = false
	if type == "Player":
		GlobalStat.currently_held_coins = max_health
		SignalBus.emit_on_coin_counter_update(current_health)
