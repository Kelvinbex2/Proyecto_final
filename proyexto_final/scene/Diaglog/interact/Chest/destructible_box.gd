extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var destroy_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var max_health: int = 3
@export var num_diamantes: int = 3
@export var diamante_scene: PackedScene = preload("res://scene/colectables/diamante.tscn")

var current_health: int
var is_destroying: bool = false

func _ready():
	current_health = max_health
	area.area_entered.connect(_on_hit)

func _on_hit(area: Area2D) -> void:
	if is_destroying:
		return

	if area is HitBoxHandler:
		current_health -= 1
		if current_health <= 0:
			call_deferred("destroy_box")

func destroy_box():
	is_destroying = true

	if animated_sprite_2d.sprite_frames.has_animation("destroy"):
		animated_sprite_2d.play("destroy")
	else:
		queue_free()
		return

	if destroy_sound:
		destroy_sound.play()

	await animated_sprite_2d.animation_finished

	# Soltar diamantes como Area2D con Tween
	for i in num_diamantes:
		var diamond = diamante_scene.instantiate()
		get_parent().add_child(diamond)
		diamond.global_position = global_position

		var offset = Vector2(randf_range(-16, 16), 0)
		var jump_pos = diamond.position + offset + Vector2(0, -32)
		var final_pos = diamond.position + offset + Vector2(0, 16)

		var tween = create_tween()
		tween.tween_property(diamond, "position", jump_pos, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(diamond, "position", final_pos, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)

	await get_tree().create_timer(0.5).timeout
	queue_free()
