extends Control
@onready var label: Label = $HBoxContainer/Label


func actualizar(frutas : int):
	label.text = str(frutas)
