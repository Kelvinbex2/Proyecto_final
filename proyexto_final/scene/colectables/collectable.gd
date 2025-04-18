extends Node

var current_coins_collected : int = 0

func _ready() -> void:
	SignalBus.on_collectable_collected.connect(on_collectable_collected)
	
func on_collectable_collected(value : int) -> void:
	current_coins_collected +=value
	SignalBus.emit_on_coin_counter_update(current_coins_collected)
