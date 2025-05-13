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

func _ready() -> void:
	hurt_box.area_entered.connect(on_player_hit)
	
func _physics_process(delta: float) -> void:
	gravity_handler.apply_gravity(self,delta)
	ai_handler.handle_state(self,delta)
	
	move_and_slide()
	
	flip_handler.handle_flip(self)


func on_player_hit(area: Area2D)-> void:
	drop_handler.add_coin(1)
