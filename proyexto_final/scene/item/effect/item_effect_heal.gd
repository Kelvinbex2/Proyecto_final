class_name ItemEffectHeal 
extends ItemEffect


@export var heal_amount : int = 1
@export var sound: AudioStream
var health_handler: HealthHandler = null

func use() -> void:
	if health_handler:
		health_handler.handle_healing(heal_amount)
	
	
