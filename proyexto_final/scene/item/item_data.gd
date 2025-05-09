class_name ItemData 
extends Resource

@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D
@export var cost : int = 10

@export_category("Item Use Effects")
@export var effects : Array[ ItemEffect ]


func use(health_handler: HealthHandler = null, pause_menu: PauseMenu = null) -> bool:
	if effects.size() == 0:
		return false
		
	for i in effects:
		if i:
			i.health_handler = health_handler
			i.pause_menu = pause_menu
			i.use()
	return true
