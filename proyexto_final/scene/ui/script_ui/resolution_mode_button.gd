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
	
	if SettingDataContainer.loaded_data != {}:
		load_data()
	else:
		SettingSignalBus.load_settings_data.connect(func(_data): load_data()) 


func load_data()-> void:
	on_resolution_selected(SettingDataContainer.get_resolution_index())
	option_button.select(SettingDataContainer.get_resolution_index())
	
func add_resolution_item()-> void:
	for resolution in RESOLU_DIC:
		option_button.add_item(resolution)
		
func on_resolution_selected(index : int) -> void:
	SettingSignalBus.emit_on_resolution_selected(index)
	DisplayServer.window_set_size(RESOLU_DIC.values()[index])
	
