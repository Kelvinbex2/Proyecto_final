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



var is_attacking: bool = false
var is_player_in_range: bool = false
var is_dying: bool = false


func _ready() -> void:
	hurt_box.area_entered.connect(on_player_hit)

	

func _physics_process(delta: float) -> void:
	if is_attacking or health_handler.is_dead or is_dying:
		return

	gravity_handler.apply_gravity(self, delta)
	ai_handler.handle_state(self, delta)
	move_and_slide()
	flip_handler.handle_flip(self)
	

func on_player_hit(area: Area2D) -> void:
	drop_handler.add_coin(1)



	
	
