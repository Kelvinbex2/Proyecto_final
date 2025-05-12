@icon("res://Assets/character/npc/icon/npc.svg")
class_name Npc 
extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal behaviour_enabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"

@export var npc_resoure : NpcResource



func _ready() -> void:
	setup_npc()
	
	
func setup_npc() -> void:
	if npc_resoure:
		animated_sprite.frames = npc_resoure.sprite_frames
