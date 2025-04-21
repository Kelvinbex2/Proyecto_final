class_name Patrol
extends CharacterBody2D
@onready var ai_handler: AIHandler = $AIHandler
@onready var movement_handler: MovementHandler = $MovementHandler
@onready var flip_handler: FlipHandler = $FlipHandler
@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity_handler: GravityHandler = $GravityHandler
@onready var hurt_box: HurtBox = $HurtBox
@onready var drop_handler: DropHandler = $Drop_handler

func _ready() -> void:
	hurt_box.area_entered.connect(on_player_hit)
	
func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self,delta)
	ai_handler.handle_state(self,delta)
	
	move_and_slide()
	
	flip_handler.handle_flip(self)
	

func on_player_hit(area: Area2D)-> void:
	drop_handler.add_coin(1)
