extends Node


const DEFAULT_COINS = 10
var currently_held_coins = DEFAULT_COINS
var currently_selected : BaseUpgrade = null



func _ready() -> void:
	SignalBus.on_upgrade_purchased.connect(on_upgrade_selected)

func get_current_coin() -> int:
	return currently_held_coins

func add_coins(val: int) -> void: 
	currently_held_coins = min(currently_held_coins + val, DEFAULT_COINS)
	SignalBus.emit_on_coin_counter_update(currently_held_coins)

func remove_coin(val: int) -> void:
	
	currently_held_coins -= val
	currently_held_coins = max(0, currently_held_coins)
	SignalBus.emit_on_coin_counter_update(currently_held_coins)
	#currently_held_coins -= val
	#if currently_held_coins <= 0:
		#currently_held_coins = 0
		#SignalBus.emit_on_player_die()
	#else:
		#SignalBus.emit_on_coin_counter_update(currently_held_coins)


func reset_coins() -> void: 
	currently_held_coins = DEFAULT_COINS
	SignalBus.emit_on_coin_counter_update(currently_held_coins)


func on_upgrade_selected(upgrade : BaseUpgrade) -> void:
	currently_selected = upgrade
	
