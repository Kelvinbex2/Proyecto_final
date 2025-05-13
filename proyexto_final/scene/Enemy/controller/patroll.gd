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

var can_attack := true
var is_attacking := false
var has_already_attacked := false

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
	if body.is_in_group("Player") and not has_already_attacked:
		has_already_attacked = true
		play_hit_animation()

func _on_detection_area_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		has_already_attacked = false

func play_hit_animation() -> void:
	if not can_attack:
		return

	can_attack = false
	is_attacking = true

	print("Reproduciendo animación de ataque")
	animatedSprite2D.play("hit")

	await animatedSprite2D.animation_finished

	is_attacking = false
	can_attack = true

	# Opcional: volver a "run" o "idle"
	animatedSprite2D.play("idle")
