class_name Patrol
extends CharacterBody2D
@onready var ai_handler: AIHandler = $AIHandler
@onready var movement_handler: MovementHandler = $MovementHandler
@onready var flip_handler: FlipHandler = $FlipHandler
@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity_handler: GravityHandler = $GravityHandler
@onready var hurt_box: HurtBox = $HurtBox
@onready var drop_handler: DropHandler = $Drop_handler
@onready var detection_area: Area2D = $DetectionArea
var can_attack := true
var is_attacking := false
var animation_task = null
var has_already_attacked := false



func _ready() -> void:
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	hurt_box.area_entered.connect(on_player_hit)
	
func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self,delta)
	ai_handler.handle_state(self,delta)
	
	move_and_slide()
	
	flip_handler.handle_flip(self)
	

func on_player_hit(area: Area2D)-> void:
	drop_handler.add_coin(1)

func _on_detection_area_entered(body: Node) -> void:
	if body.is_in_group("Player") and not has_already_attacked:
		print("Jugador detectado")
		has_already_attacked = true  
		play_hit_animation()



func _on_detection_area_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Jugador se fue")
		has_already_attacked = false  


func play_hit_animation() -> void:
	if not can_attack:
		return

	can_attack = false
	print("Reproduciendo animación 'hit'")
	animatedSprite2D.play("hit")

	await animatedSprite2D.animation_finished
	animatedSprite2D.play("run")

	await get_tree().create_timer(0.5).timeout
	can_attack = true


func play_death_animation() -> void:
	print("💀 Reproduciendo animación 'die'")
	animatedSprite2D.play("die")

	await animatedSprite2D.animation_finished
	queue_free()
