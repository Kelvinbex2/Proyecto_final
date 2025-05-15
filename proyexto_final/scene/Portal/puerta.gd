extends Area2D

@onready var destination: Marker2D = $Destination
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		audio.play()
		body.set_position(destination.global_position)
