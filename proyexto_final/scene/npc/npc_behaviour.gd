@icon("res://Assets/character/npc/icon/npc_behavior.svg")
class_name NpcBehaviour 
extends Node2D


var npc : Npc

func _ready() -> void:
	var parent = get_parent()
	if parent is Npc:
		npc = parent as Npc
		
