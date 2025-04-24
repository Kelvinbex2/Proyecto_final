class_name Collectable
extends Node

var current_coins_collected : int = 0

func _ready() -> void:
	if GlobalStat.get_current_coin() != 0:
		current_coins_collected = GlobalStat.get_current_coin()
		
	SignalBus.on_collectable_collected.connect(on_collectable_collected)
	SignalBus.on_hit.connect(on_player_hit)
	
func on_collectable_collected(value : int) -> void:
	current_coins_collected +=value
	GlobalStat.add_coins(current_coins_collected)
	SignalBus.emit_on_coin_counter_update(current_coins_collected)


func on_player_hit(value: int) -> void:
	current_coins_collected -=value
	
	GlobalStat.remove_coin(value)
	if current_coins_collected <=0:
		current_coins_collected =0
		
	SignalBus.emit_on_coin_counter_update(current_coins_collected)
