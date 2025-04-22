class_name DeathHandler
extends Node2D

@export var parent : Node = null
@export_enum("Player", "Enemy") var type : String = "Player"

func death() -> void:
	match type:
		"Player":
			pass
		"Enemy":
			SignalBus.emit_on_enemy_death()

	var drop_handler : DropHandler = null
	
	#  Buscar el DropHandler entre los hijos del parent
	for child in parent.get_children():
		if child is DropHandler:
			drop_handler = child
			break
	
	if drop_handler != null:
		drop_handler.drop_coin()
		
	parent.queue_free()
