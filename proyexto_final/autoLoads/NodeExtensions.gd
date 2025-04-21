extends Node

const ENTITY_CONTAINER : String = "entity_container"
const LEVEL_CONTAINER :String ="level_container"
const MANAGER : String = "manager"
const CAMERA_CONTAINER :String = "camera_container"
const UI_CONTAINER : String ="ui_container"


func get_entity_container() -> Node:
	return get_tree().get_first_node_in_group(ENTITY_CONTAINER)

func get_level_container() -> Node:
	return get_tree().get_first_node_in_group(LEVEL_CONTAINER)
	
func get_manager() -> Node:
	return get_tree().get_first_node_in_group(MANAGER)
	
func get_camera_container() -> Node:
	return get_tree().get_first_node_in_group(CAMERA_CONTAINER)
	
func get_ui_container() -> Node:
	return get_tree().get_first_node_in_group(UI_CONTAINER)
