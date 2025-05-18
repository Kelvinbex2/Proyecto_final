extends CharacterBody2D
#region handlers
@onready var ai_handler: AIHandler = $handlers/AIHandler
@onready var flip_handler: FlipHandler = $handlers/FlipHandler
@onready var gravity_handler: GravityHandler = $handlers/GravityHandler
@onready var movement_handler: MovementHandler = $handlers/MovementHandler
@onready var death_handler: DeathHandler = $handlers/DeathHandler
@onready var drop_handler: DropHandler = $handlers/DropHandler
@onready var health_handler: HealthHandler = $handlers/HealthHandler
@onready var hurt_box: HurtBox = $handlers/HurtBox
@onready var hit_box_handler: HitBoxHandler = $handlers/HitBoxHandler
#endregion
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea



var is_attacking: bool = false
var is_player_in_range: bool = false
var is_dying: bool = false
var blood = load("res://scene/effect/blood_effect.tscn")


func _ready() -> void:
	hurt_box.area_entered.connect(on_player_hit)
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)

	

func _physics_process(delta: float) -> void:
	if is_attacking or health_handler.is_dead or is_dying:
		return

	gravity_handler.apply_gravity(self, delta)
	ai_handler.handle_state(self, delta)
	move_and_slide()
	flip_handler.handle_flip(self)
	

func on_player_hit(area: Area2D) -> void:
	drop_handler.add_coin(1)

func _on_detection_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = true

		if body.global_position.x < global_position.x:
			velocity.x = -1
		else:
			velocity.x = 1

		flip_handler.handle_flip(self)

		if not is_attacking and not is_dying:
			attack_loop()

func _on_detection_area_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = false

func attack_loop() -> void:
	if is_attacking or health_handler.is_dead or is_dying:
		return
		
	is_attacking = true

	while is_player_in_range and not health_handler.is_dead and not is_dying:
		print("👊 Atacando jugador")
		hit_box_handler.collision_shape_2d.set_deferred("disabled", false)
		animated.play("hit")
		await animated.animation_finished
		hit_box_handler.collision_shape_2d.set_deferred("disabled", true)

		if not is_player_in_range or health_handler.is_dead:
			break

		await get_tree().create_timer(1.0).timeout

	is_attacking = false
	if not health_handler.is_dead and not is_dying:
		animated.play("walk")

func play_death_animation() -> void:
	print("💀 Reproduciendo animación 'die'")
	is_dying = true
	is_attacking = false
	animated.play("die")
	await animated.animation_finished
	queue_free()


	
	
