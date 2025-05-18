extends Node

var last_loc
var player



func _ready() -> void:
	player = get_parent().get_node("Player")
	last_loc = player.global_position
