@tool
class_name DialogItem
extends Node

@export var npc_info : NpcResource

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	check_npc_data()
	

func check_npc_data() -> void:
	if npc_info == null:
		var p = self
		var _checking = true
		
		while  _checking == true:
			p = p.get_parent()
			if p:
				if p is Npc and p.npc_resoure:
					npc_info = p.npc_resoure
					_checking = false
			else:
				_checking = false
