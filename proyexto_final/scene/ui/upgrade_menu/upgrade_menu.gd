class_name UpgradeMenu
extends Control

@onready var button: Button = $MarginContainer/VBoxContainer/Button

signal exit_btn_pressed

func _ready() -> void:
	button.button_down.connect(on_exit_button_down)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_exit_button_down() ->void:
	exit_btn_pressed.emit()
	queue_free()
	
