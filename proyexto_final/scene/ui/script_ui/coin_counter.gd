class_name CoinCounter_UI
extends Control
@onready var coin_counter: Label = $HBoxContainer/coinCounter


func _ready() -> void:
	SignalBus.on_coin_counter_update.connect(set_coin_counter)
	


func set_coin_counter(value : int) -> void:
	coin_counter.text = str(value)
