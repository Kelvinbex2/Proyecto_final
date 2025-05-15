class_name Contador
extends Control

@onready var label: Label = $HBoxContainer/Label


func _ready():
	SignalBus.on_fruta_recogida.connect(actualizar)

func actualizar(nueva_cantidad: int):
	label.text = str(nueva_cantidad)
