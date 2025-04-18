class_name Player
extends CharacterBody2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_handler: InputHandler = $InputHandler
@onready var movement_handler: MovementHandler = $MovementHandler
@onready var jump_handler: JumpHandler = $JumpHandler
@onready var flip_handler: FlipHandler = $FlipHandler
@onready var gravity_handler: GravityHandler = $GravityHandler


func _ready() -> void:
	SignalBus.emit_on_player_ready(self)

func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self,delta)
	movement_handler.handle_movement(self,input_handler.handle_movement_input(),delta)
	jump_handler.handle_jump(self,input_handler.handle_jump_input())
	move_and_slide()

	flip_handler.handle_flip(self)
	handle_animation()

func handle_animation() -> void:
	if not is_on_floor():
		animatedSprite2D.play("jump")
	elif velocity.x != 0:
		animatedSprite2D.play("run")
	else:
		animatedSprite2D.play("idle")
