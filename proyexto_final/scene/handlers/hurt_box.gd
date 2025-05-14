class_name HurtBox
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if not area is HitBoxHandler:
		return
	
	print("HurtBox hit by:", area.name)
	var health = get_parent().get_node_or_null("HealthHandler")
	if health:
		health.damage(2)
