extends Control

const RESOLU_DIC : Dictionary = {
	"1152 x 648": Vector2i(1152,648),
	"1280 x 720": Vector2i(1280,720),
	"1680×1050": Vector2i(1680,1050),
	"1920 x 1080": Vector2i(1920,1080)
}
@onready var option_button: OptionButton = $HBoxContainer/OptionButton

func _ready() -> void:
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_item()

func add_resolution_item()-> void:
	for resolution in RESOLU_DIC:
		option_button.add_item(resolution)
		
func on_resolution_selected(index : int) -> void	:
	DisplayServer.window_set_size(RESOLU_DIC.values()[index])
	
