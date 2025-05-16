@tool
@icon("res://Assets/character/npc/icon/npc.svg")
class_name Npc 
extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal behaviour_enabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "side"
var do_behaviour : bool = true

@export var npc_resoure : NpcResource : set = _set_npc_resource



func _ready() -> void:
	setup_npc()
	if Engine.is_editor_hint():
		return
	
	gather_interactables()
	behaviour_enabled.emit()
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	
	

func gather_interactables() -> void:
	for i in get_children():
		if i is DialogInterraction:
			i.player_interacted.connect(_on_player_interacted)
			i.finished.connect(_on_interaction_finished)




func _on_player_interacted() -> void:
	update_direction(Player.global_position)
	state = "idle"
	velocity = Vector2.ZERO
	update_animation()
	do_behaviour = false
	
	
func _on_interaction_finished() -> void:
	state = "idle"
	update_animation()
	do_behaviour = true
	behaviour_enabled.emit()
	
func update_animation() -> void:
	animated_sprite.play(state  )

func update_direction(target : Vector2) -> void:
	direction = global_position.direction_to(target)
	update_animation()
	if direction_name == "side" and direction.x > 0:
		animated_sprite.flip_h = true
	else :
		animated_sprite.flip_h = false
	
	
func update_direction_name() -> void:
	var hold =0.50
	if direction.y < -hold:
		direction_name = "up"
	elif  direction.y > hold:
		direction_name = "down"
	elif direction.x > hold || direction.x < -hold:
		direction_name = "side"
	
	
func setup_npc() -> void:
	if npc_resoure:
		if animated_sprite:
			animated_sprite.frames = npc_resoure.sprite_frames

func _set_npc_resource(_npc: NpcResource) -> void:
	npc_resoure = _npc
	setup_npc()
	
