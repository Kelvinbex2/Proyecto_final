class_name HurtBox
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio: AudioStreamPlayer2D = $Audio

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if not area is HitBoxHandler:
		return
	
	print("HurtBox hit by:", area.name)
	var health = get_parent().get_node_or_null("HealthHandler")
	if health:
		health.damage(1)
	if audio:
		audio.play()
		
	var blood_scene = load("res://scene/effect/blood_effect.tscn")
	var blood_instance = blood_scene.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	blood_instance.emitting = true
