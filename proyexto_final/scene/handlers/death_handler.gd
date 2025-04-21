class_name DeathHandler
extends Node2D

@export var parent : Node = null


func death()-> void:
	var drop_handler :DropHandler = null
	drop_handler = parent.drop_handler
	
	if drop_handler != null:
		drop_handler.drop_coin()
		
	parent.queue_free()
