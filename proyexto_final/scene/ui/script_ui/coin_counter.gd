class_name CoinCounter_UI
extends Control


@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	set_coin_counter(GlobalStat.get_current_coin())
	SignalBus.on_coin_counter_update.connect(set_coin_counter)
	


func set_coin_counter(value: int) -> void:
	if health_bar:
		health_bar.max_value = GlobalStat.DEFAULT_COINS
		health_bar.value = clamp(value, 0, GlobalStat.DEFAULT_COINS)

		
