extends Control
@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const WINDOW_MODE_SELECT : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]



func _ready() -> void:
	add_window_mode_item()
	option_button.item_selected.connect(on_window_mode_selected)
	
	if SettingDataContainer.loaded_data != {}:
		load_data()
	else:
		SettingSignalBus.load_settings_data.connect(func(_data): load_data()) 

func  load_data() -> void:
	on_window_mode_selected(SettingDataContainer.get_window_mode_index())
	option_button.select(SettingDataContainer.get_window_mode_index())

func add_window_mode_item()-> void:
	for mode in WINDOW_MODE_SELECT:
		option_button.add_item(mode)
		
		
func  on_window_mode_selected(index: int) -> void:
	SettingSignalBus.emit_on_window_mode_selected(index)
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
