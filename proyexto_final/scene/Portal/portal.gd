extends Area2D

@export var target_scene: PackedScene

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player and target_scene:
		call_deferred("_change_scene_safely")

func _change_scene_safely():
	get_tree().change_scene_to_packed(target_scene)
