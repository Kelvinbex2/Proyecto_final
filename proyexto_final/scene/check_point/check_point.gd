extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_point: Marker2D = $Respawn
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
var activated := false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not activated:
		activated = true
		body.set_checkpoint(respawn_point.global_position)
		animated_sprite.play("flag")
		audio_player.play()
