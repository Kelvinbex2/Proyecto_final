class_name InventorySlotUI
extends Button

var slot_data : SlotData : set = set_slot_data
@onready var texture_rec: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rec.texture = null
	label.text = ""
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	pressed.connect(item_pressed)
	
	

func set_slot_data(value :SlotData)-> void:
	slot_data = value
	if slot_data == null:
		return
	
	texture_rec.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)


func item_focused () -> void:
	if slot_data != null and slot_data.item_data != null:
		var pause_menu = find_parent("PauseMenu") as PauseMenu
		if pause_menu:
			pause_menu.update_item_description(slot_data.item_data.description)

func item_unfocused () -> void:
	var pause_menu = find_parent("PauseMenu") as PauseMenu
	if pause_menu:
		pause_menu.update_item_description("")


func item_pressed() -> void:
	if slot_data and slot_data.item_data:
		var pause_menu = find_parent("PauseMenu") as PauseMenu

		var health_handler: HealthHandler = null
		if pause_menu and pause_menu.player_ref:
			var handler_container = pause_menu.player_ref.get_node("HandlerContainer")
			if handler_container:
				health_handler = handler_container.get_node("HealthHandler")

		var used = slot_data.item_data.use(health_handler, pause_menu)
		if used == false:
			return

		slot_data.quantity -= 1
		label.text = str(slot_data.quantity)
