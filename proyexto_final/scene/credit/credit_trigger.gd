extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  
		call_deferred("go_to_credit_scene")  

func go_to_credit_scene():
	get_tree().change_scene_to_file("res://scene/credit/Credit.tscn")
