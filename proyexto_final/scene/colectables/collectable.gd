class_name Collectable
extends Node

var current_coins_collected : int = 0

func _ready() -> void:
	if GlobalStat.get_current_coin() != 0:
		current_coins_collected = GlobalStat.get_current_coin()
		
	SignalBus.on_collectable_collected.connect(on_collectable_collected)
	SignalBus.on_hit.connect(on_player_hit)
	
func on_collectable_collected(value: int) -> void:
	GlobalStat.add_coins(value) 
	current_coins_collected = GlobalStat.get_current_coin()



func on_player_hit(value: int) -> void:
	GlobalStat.remove_coin(value)
	current_coins_collected = GlobalStat.get_current_coin()
	SignalBus.emit_on_coin_counter_update(current_coins_collected)
