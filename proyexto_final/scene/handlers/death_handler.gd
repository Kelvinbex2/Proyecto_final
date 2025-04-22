class_name DeathHandler
extends Node2D

@export var parent : Node = null
@export_enum("Player", "Enemy") var type : String = "Player"


func death()-> void:
	match type:
		"Player":
			pass
		"Enemy":
			SignalBus.emit_on_enemy_death()
			
	var drop_handler :DropHandler = null
	drop_handler = parent.drop_handler
	
	if drop_handler != null:
		drop_handler.drop_coin()
		
	parent.queue_free()
