class_name ItemEffectHeal 
extends ItemEffect


@export var heal_amount : int = 1
@export var sound: AudioStream
var health_handler: HealthHandler = null
var pause_menu: PauseMenu = null


func use() -> void:
	if health_handler:
		health_handler.handle_healing(heal_amount)
		
	if pause_menu and sound:
		pause_menu.play_audio(sound)
	
