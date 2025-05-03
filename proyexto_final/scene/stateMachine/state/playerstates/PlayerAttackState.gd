class_name PlayerAttackState
extends BasePlayerState

signal enter_idle_state

@export var hit_box_handler: HitBoxHandler = null

var attack_duration := 0.4  

func _ready() -> void:
	hit_box_handler.area_entered.connect(on_attack_hit)
	set_physics_process(false)

func enter_state() -> void:
	set_physics_process(true)
	
	hit_box_handler.collision_shape_2d.disabled = false
	player.animatedSprite2D.play("attack")
	await get_tree().create_timer(attack_duration).timeout

	hit_box_handler.collision_shape_2d.set_deferred("disabled", true)
	enter_idle_state.emit()

func exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	
	player.movement_handler.handle_movement(player, player.input_handler.handle_movement_input(), delta)

func on_attack_hit(area: Area2D) -> void:
	if not area is HurtBox:
		return

	var health = area.get_parent().get_node_or_null("HealthHandler")
	if health:
		health.damage(2)
