extends CharacterBody2D

@onready var ani_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_handler: InputHandler = $InputHandler
@onready var movement_handler: MovementHandler = $MovementHandler
@onready var jump_handler: JumpHandler = $JumpHandler
@onready var flip_handler: FlipHandler = $FlipHandler

@export_category("World variables")
@export var gravity = 600

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	movement_handler.handle_movement(self,input_handler.handle_movement_input(),delta)
	jump_handler.handle_jump(self,input_handler.handle_jump_input())
	move_and_slide()

	flip_handler.handle_flip(self)
	handle_animation()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_animation() -> void:
	if not is_on_floor():
		ani_player.play("jump")
	elif velocity.x != 0:
		ani_player.play("run")
	else:
		ani_player.play("idle")
