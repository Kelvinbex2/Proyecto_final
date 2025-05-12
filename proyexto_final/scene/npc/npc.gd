@tool
@icon("res://Assets/character/npc/icon/npc.svg")
class_name Npc 
extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal behaviour_enabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"

@export var npc_resoure : NpcResource : set = _set_npc_resource



func _ready() -> void:
	setup_npc()
	if Engine.is_editor_hint():
		return
	
	
func setup_npc() -> void:
	if npc_resoure:
		if animated_sprite:
			animated_sprite.frames = npc_resoure.sprite_frames

func _set_npc_resource(_npc: NpcResource) -> void:
	npc_resoure = _npc
	setup_npc()
	
