class_name DeathHandler
extends Node2D

@export var parent : Node = null
@export_enum("Player", "Enemy") var type : String = "Player"

func _ready() -> void:
	SignalBus.on_level_changed.connect(on_level_change)
	
func death() -> void:
	match type:
		"Player":
			if parent is Player:
				await parent.play_death_animation()
				return 
			

		"Enemy":
			SignalBus.emit_on_enemy_death()
			var drop_handler : DropHandler = null
			for child in parent.get_children():
				if child is DropHandler:
					drop_handler = child
					break

			if drop_handler != null:
				drop_handler.drop_coin()

			parent.queue_free()

	
	

func on_level_change() -> void:
	get_parent().get_parent().queue_free()
