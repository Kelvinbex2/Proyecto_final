extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var destroy_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var max_health: int = 3  # Cantidad de golpes necesarios
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

	# Reproducir animación si existe
	if animated_sprite_2d.sprite_frames.has_animation("destroy"):
		animated_sprite_2d.play("destroy")
	else:
		queue_free()
		return

	# Reproducir sonido si existe
	if destroy_sound:
		destroy_sound.play()

	# Esperar animación
	await animated_sprite_2d.animation_finished

	# Instanciar ítem
	var fruit_scene = preload("res://scene/colectables/diamante.tscn")
	var fruit = fruit_scene.instantiate()
	get_parent().add_child(fruit)
	fruit.global_position = global_position

	# Rebote usando Tween
	var tween = create_tween()
	var start_pos = fruit.position
	var peak_pos = start_pos + Vector2(0, -30)

	tween.tween_property(fruit, "position", peak_pos, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(fruit, "position", start_pos, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)

	# Esperar rebote y luego destruir la caja
	await tween.finished
	queue_free()
