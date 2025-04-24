class_name CoinCounter_UI
extends Control

@onready var coin_counter: Label = $MarginContainer/MarginContainer/coinCounter


func _ready() -> void:
	set_coin_counter(GlobalStat.get_current_coin())
	SignalBus.on_coin_counter_update.connect(set_coin_counter)
	


func set_coin_counter(value : int) -> void:
	coin_counter.text = str(value)
