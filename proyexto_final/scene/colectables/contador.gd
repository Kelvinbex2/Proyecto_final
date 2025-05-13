class_name Contador
extends Control

@onready var label: Label = $HBoxContainer/Label
var frutas = 0

func _ready():
	SignalBus.on_fruta_recogida.connect(actualizar)

func actualizar(nueva_cantidad: int):
	frutas = nueva_cantidad
	label.text = str(frutas)
