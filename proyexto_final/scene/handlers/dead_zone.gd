extends Area2D



func _ready() -> void:
	body_entered.connect(on_body_entered)






func  on_body_entered(body:Node2D) -> void:
	if body is Player:
		SignalBus.emit_on_player_entered_dead_zone()
	body.queue_free()
