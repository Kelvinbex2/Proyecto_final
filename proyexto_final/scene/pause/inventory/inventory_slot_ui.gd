class_name InventorySlotUI
extends Button

var slot_data : SlotData : set = set_slot_data
@onready var texture_rec: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rec.texture = null
	label.text = ""
	
	

func set_slot_data(value :SlotData)-> void:
	slot_data = value
	if slot_data == null:
		return
	
	texture_rec.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)
