class_name Settings
extends Control

@onready var tab_container: TabContainer = $TabContainer

signal exit_opt_menu

func _process(delta: float) -> void:
	opt_menu()
	
func change_tab(tab : int) -> void:
	tab_container.set_current_tab(tab)  # ← corrección aquí

func opt_menu() -> void:
	if Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("ui_right"):
		if tab_container.current_tab >= tab_container.get_tab_count() - 1:
			change_tab(0)
			return
		var next_tab = tab_container.current_tab + 1
		change_tab(next_tab)

	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("ui_left"):
		if tab_container.current_tab == 0:
			change_tab(tab_container.get_tab_count() - 1)  # ← corrección aquí
			return
		var prev_tab = tab_container.current_tab - 1
		change_tab(prev_tab)

	if Input.is_action_just_pressed("ui_cancel"):
		exit_opt_menu.emit()
