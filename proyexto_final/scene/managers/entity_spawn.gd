class_name EntitySpawn
extends Node

@export var player_spawn_point : Marker2D = null
@export var player_packed_scene : PackedScene = null

var player_spawned : bool = false


func _process(delta: float) -> void:
	if player_spawned == false:
		spawn_player()
	else:
		pass


func spawn_player()->void:
	var new_player : Player = player_packed_scene.instantiate()
	var entity_container: Node2D = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
		
	entity_container.add_child(new_player)
	new_player.position = player_spawn_point.position
	
	player_spawned = true
