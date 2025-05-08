class_name InventoryData
extends Resource

@export var slots : Array[SlotData]

func add_item (item: ItemData, count : int = 1) -> bool:
	for j in slots:
		if j:
			if j.item_data == item:
				j.quantity +=count
				return true
	
	for i in slots.size():
		if slots[i] ==null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = count
			slots[i] = new
			return true
		
	return false
