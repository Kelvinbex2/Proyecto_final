extends Area2D

var value : int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: CharacterBody2D) -> void:
	if !body.is_in_group("Player"):
		return
	
	SignalBus.emit_on_collectable_collected(value)
	queue_free()
