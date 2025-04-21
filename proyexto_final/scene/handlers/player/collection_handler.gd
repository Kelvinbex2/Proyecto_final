class_name CollectionHandler
extends Area2D

@export var health_handler : HealthHandler = null

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
func on_area_entered(area:Area2D)-> void:
	var area_parent := area.get_parent()
	if !area.is_in_group("collectable"):
		return


	health_handler.handle_healing(area_parent.value)
	SignalBus.emit_on_collectable_collected(area_parent.value)
	area_parent.queue_free()
		
