class_name GameState
extends Node

@onready var state_timer: Timer = $StateTimer
@export var upgrade_menu: PackedScene = null
var upgrade_menu_exits : bool = false

enum {
	ActiveState,
	UpgradeState,
}
var current_stae = ActiveState


func _ready() -> void:
	state_timer.timeout.connect(on_active_state_end)


func _process(delta: float) -> void:
	match  current_stae:
		ActiveState:
			get_tree().paused=false
		
		UpgradeState:
			run_upgrade_state()
			

func run_upgrade_state()->void:
	if get_tree().paused == false:
		get_tree().paused=true	
	
	if upgrade_menu_exits == true:
		return

	var new_upgrade_menu = upgrade_menu.instantiate() as UpgradeMenu
	var ui_container = NodeExtensions.get_ui_container()
	
	if ui_container == null:
		return
		
	ui_container.add_child(new_upgrade_menu)
	new_upgrade_menu.exit_btn_pressed.connect(on_upgrade_state_end)
	upgrade_menu_exits =true

func on_active_state_end()->void:
	current_stae=UpgradeState
	

func on_upgrade_state_end() -> void:
	current_stae = ActiveState
