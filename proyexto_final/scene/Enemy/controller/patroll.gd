class_name Patrol
extends CharacterBody2D
@onready var ai_handler: AIHandler = $AIHandler
@onready var movement_handler: MovementHandler = $MovementHandler
@onready var flip_handler: FlipHandler = $FlipHandler
@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity_handler: GravityHandler = $GravityHandler

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self,delta)
	ai_handler.handle_state(self,delta)
	
	move_and_slide()
	
	flip_handler.handle_flip(self)
