class_name Contador
extends Control

@onready var label: Label = $HBoxContainer/Label
var frutas = 0



func actualizar(fruta: int):
	label.text = str(fruta)


func add_frutas():
	frutas += 1
	actualizar(frutas)
