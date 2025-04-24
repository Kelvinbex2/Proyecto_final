class_name RoundTimerUI
extends Label




var round_timer : Timer = null

func _ready() -> void:
	SignalBus.on_game_state_manager_ready.connect(on_game_state_manager_ready)



func _process(delta: float) -> void:
	if round_timer == null:
		return
	
	set_timer_label_text()
	


func set_timer_label_text() -> void:
	self.text = str(roundf(round_timer.time_left))


func on_game_state_manager_ready(GS:GameState) ->void:
	round_timer = GS.state_timer
