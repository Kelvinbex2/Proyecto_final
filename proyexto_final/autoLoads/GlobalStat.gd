extends Node

var currently_held_coins = 5
const DEFAULT_COINS = 5

func get_current_coin() -> int:
	return currently_held_coins
	
func add_coins(val: int) -> void:
	currently_held_coins = val

func remove_coin(val: int) -> void:
	currently_held_coins -= val

func reset_coins() -> void:
	currently_held_coins = DEFAULT_COINS
