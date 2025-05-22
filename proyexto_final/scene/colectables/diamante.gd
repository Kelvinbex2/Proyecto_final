extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_sound: AudioStreamPlayer = $PickupSound


func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("add_frutas"):
		body.add_frutas()
		
	
		if pickup_sound:
			pickup_sound.play()
	
		await get_tree().create_timer(0.1).timeout
		queue_free()
