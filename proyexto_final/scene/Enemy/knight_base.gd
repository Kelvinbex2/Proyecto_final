extends CharacterBody2D

#region handlers
@onready var flip_handler: FlipHandler = $FlipHandler
@onready var gravity_handler: GravityHandler = $GravityHandler
@onready var movement_handler: MovementHandler = $MovementHandler
@onready var ai_handler: AIHandler = $AIHandler
@onready var death_handler: DeathHandler = $DeathHandler
@onready var drop_handler: DropHandler = $DropHandler
@onready var health_handler: HealthHandler = $HealthHandler
@onready var hurt_box: HurtBox = $HurtBox
@onready var hit_box_handler: HitBoxHandler = $HitBoxHandler
#endregion

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea



var is_attacking: bool = false
var is_player_in_range: bool = false

func _ready() -> void:
	hurt_box.area_entered.connect(on_player_hit)
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)

func _physics_process(delta: float) -> void:
	if not is_attacking:
		gravity_handler.apply_gravity(self, delta)
		ai_handler.handle_state(self, delta)
		move_and_slide()
		flip_handler.handle_flip(self)

func on_player_hit(area: Area2D) -> void:
	drop_handler.add_coin(1)

func _on_detection_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = true

		# Forzar dirección para flip visual
		if body.global_position.x < global_position.x:
			velocity.x = -1  # izquierda
		else:
			velocity.x = 1   # derecha

		# Ejecutar flip visual usando mi sistema actual
		flip_handler.handle_flip(self)

		if not is_attacking:
			attack_loop()


func _on_detection_area_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = false

func attack_loop() -> void:
	is_attacking = true

	while is_player_in_range:
		print("👊 Atacando jugador")
		animatedSprite2D.play("hit")
		await animatedSprite2D.animation_finished

		# Si el jugador se ha ido durante la animación
		if not is_player_in_range:
			break

		await get_tree().create_timer(1.0).timeout

		# Si el jugador se ha ido durante el tiempo de espera
		if not is_player_in_range:
			break

	# Fin del ataque
	animatedSprite2D.play("walk")
	is_attacking = false
