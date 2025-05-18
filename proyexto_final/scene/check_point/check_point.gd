extends Area2D

@onready var respawn_point: Marker2D = $Respawn

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_checkpoint(respawn_point.global_position)
