class_name CollectableSpawn
extends Node

@export var timer_min =0.1
@export var timer_max =5.0
@export var spawn_point: Array[Marker2D] = []
@export var coin_scene : PackedScene =null
@onready var spawn_timer: Timer = $SpawnTimer



func _ready() -> void:
	spawn_timer.timeout.connect(handle_collectable_spawn)
	spawn_timer.start()



func _process(delta: float) -> void:
	pass


func get_random_time() -> float:
	return randf_range(timer_max,timer_max)


func handle_collectable_spawn()-> void:
	var new_coin : BaseCoin = coin_scene.instantiate()
	var entity_container : Node2D = NodeExtensions.get_entity_container()
	
	if entity_container == null:
		return
	
	spawn_point.shuffle()
	var chosen_spawn: Marker2D =spawn_point.pick_random()
	entity_container.add_child(new_coin)
	new_coin.position = chosen_spawn.position
	
	spawn_timer.start(get_random_time())
	
	
	
