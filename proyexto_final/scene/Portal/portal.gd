extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		SignalBus.emit_signal("on_portal_triggered")
		set_deferred("monitoring", false)
