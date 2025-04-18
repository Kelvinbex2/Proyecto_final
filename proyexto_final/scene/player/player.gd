extends CharacterBody2D

@export_category("Player Variables")
@export var move_speed = 5000
@export var jump_speed = 300
@onready var ani_player: AnimatedSprite2D = $AnimatedSprite2D

@export_category("World variables")
@export var gravity = 600

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement(delta)
	handle_jump()
	move_and_slide()

	handle_flip()
	handle_animation()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_movement_input() -> float:
	return Input.get_axis("move_left", "move_right")

func handle_jump_input() -> bool:
	return Input.is_action_just_pressed("jump_up")

func handle_movement(delta: float) -> void:
	velocity.x = 0
	var input_axis = handle_movement_input()

	if input_axis < 0:
		velocity.x = -move_speed * delta
	elif input_axis > 0:
		velocity.x = move_speed * delta

func handle_jump() -> void:
	if handle_jump_input() and is_on_floor():
		velocity.y = -jump_speed

func handle_flip() -> void:
	if velocity.x < 0:
		ani_player.flip_h = true
	elif velocity.x > 0:
		ani_player.flip_h = false

func handle_animation() -> void:
	if not is_on_floor():
		ani_player.play("jump")
	elif velocity.x != 0:
		ani_player.play("run")
	else:
		ani_player.play("idle")
