@tool
class_name TreasureChest
extends Node2D
@export var item_data : ItemData : set = _set_item_data
@export var quantity: int = 1 : set = _set_quantity
var is_open = false
@onready var sprite: Sprite2D = $ItemCol
@onready var label: Label = $ItemCol/Label
@onready var interact_area: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var item: ItemPickup = null



func _ready() -> void:
	_update_textute()
	_update_label()
	
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exit)


func player_interact() -> void:
	if is_open == true:
		return
	is_open = true
	animation_player.play("open_chest")
	
	if item_data and quantity > 0:
		item.INVENTORY_DATA.add_item(item_data,quantity)
	else :
		printerr("No items in chest")
		push_error("No items in chest")

func _on_area_entered (_a:Area2D) -> void:
	GlobalStat.interact_pressed.connect(player_interact)
	
	
	

func _on_area_exit (_a:Area2D) -> void:
	GlobalStat.interact_pressed.disconnect(player_interact)
	
	
	


	
func _set_item_data(val : ItemData) -> void:
	item_data = val	
	_update_textute()
	


func _set_quantity(val:int) -> void:
	quantity = val
	_update_label()
	

func _update_textute() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texture
		
func _update_label() -> void:
	if label:
		if quantity <=1:
			label.text = ""
		else:
			label.text = "x" + str(quantity)
