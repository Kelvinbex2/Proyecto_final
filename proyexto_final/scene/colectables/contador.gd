class_name Contador
extends Control

@onready var label: Label = $HBoxContainer/Label
var frutas = 0



func actualizar(frutas: int):
	print("🖊️ Label.text = ", frutas)
	label.text = str(frutas)


func add_frutas():
	frutas += 1
	actualizar(frutas)
