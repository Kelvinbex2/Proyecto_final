extends Area2D

@export var target_scene: PackedScene

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and target_scene:
		get_node("/root/GameState").change_to_scene_packed(target_scene)
