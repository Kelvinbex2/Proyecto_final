class_name EntitySpawn
extends Node

#region Player Region
@export_category("Player")
@export var player_spawn_point : Marker2D = null
@export var player_packed_scene : PackedScene = null

var player_spawned : bool = false
#endregion


#region Enemy Region
@export_category("Enemey")
@export var enemy_timer_min =0.1
@export var enemy_timer_max =4.0
@export var enemy_spawn_points : Array[Marker2D] = []
@export var enemy_packed_scene : PackedScene = null
@export var max_enemies_alive =0

@onready var entity_spawn_timer: Timer = $EntitySpawnTimer

var enemy_count =0
#endregion


func _ready() -> void:
	SignalBus.on_enemy_death.connect(on_enemy_death)
	entity_spawn_timer.timeout.connect(enemy_spawn)
	SignalBus.on_player_entered_dead_zone.connect(on_player_respawn)
	
	
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


func on_player_respawn() -> void:
	player_spawned = false

func enemy_spawn() -> void:
	if enemy_count >= max_enemies_alive:
		return
	
	var new_enemy : Patrol = enemy_packed_scene.instantiate()
	var entity_container : Node2D = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	enemy_spawn_points.shuffle()
	var chosen_enemy : Marker2D = enemy_spawn_points.pick_random()
	
	entity_container.add_child(new_enemy)
	new_enemy.position = chosen_enemy.position
	entity_spawn_timer.start(NodeExtensions.get_random_time(enemy_timer_min, enemy_timer_max))
	
	enemy_count += 1  


func on_enemy_death()->void:
	enemy_count -=1
	
