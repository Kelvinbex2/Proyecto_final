class_name HealthHandler
extends Node2D

@export var max_health = 10
@export var death_handler : DeathHandler = null
@export_enum("Player", "Enemy") var type : String = "Player"

var current_health = 0
var is_dead := false

func _ready() -> void:
	set_max_health()

func set_max_health() -> void:
	is_dead = false

	if type == "Player":
		max_health = GlobalStat.DEFAULT_COINS
		current_health = GlobalStat.get_current_coin()
	else:
		current_health = max_health



func damage(val: int) -> void:
	print("💥 DAMAGE taken:", val)
	if is_dead: 
		return
		
	match type:
		"Player":
			
			GlobalStat.remove_coin(val)
			current_health = GlobalStat.get_current_coin()
			var maybe_player = get_parent().get_parent()
			if maybe_player and maybe_player.has_method("apply_hit_feedback"):
				maybe_player.apply_hit_feedback()
			
		"Enemy":
			current_health -= val
			
	if current_health <= 0 and not is_dead:
		current_health = 0
		is_dead = true
		death_handler.death()

func handle_healing(value: int) -> void:
	if is_dead: return

	GlobalStat.add_coins(value)
	current_health = GlobalStat.get_current_coin()



func reset_health() -> void:
	is_dead = false

	if type == "Player":
		GlobalStat.reset_coins()
		current_health = GlobalStat.get_current_coin()
	else:
		current_health = max_health

	SignalBus.emit_on_coin_counter_update(current_health)
