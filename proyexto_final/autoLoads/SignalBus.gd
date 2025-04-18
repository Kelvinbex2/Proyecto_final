extends Node

signal on_collectable_collected(value : int)
signal  on_coin_counter_update(value: int)
signal on_player_ready(player: Player)

func emit_on_collectable_collected(value : int) -> void:
	on_collectable_collected.emit(value)
	
func emit_on_coin_counter_update(value:int)-> void:
	on_coin_counter_update.emit(value)

func emit_on_player_ready(player: Player) -> void:
	on_player_ready.emit(player)
