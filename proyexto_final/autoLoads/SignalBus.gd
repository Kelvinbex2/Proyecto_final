extends Node

signal on_collectable_collected(value : int)

func emit_on_collectable_collected(value : int) -> void:
	on_collectable_collected.emit(value)
	
	
	
