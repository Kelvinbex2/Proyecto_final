extends Node

const SETTINGS_SAVE_PATH : String = "user://SettingsData.save"

var settings_data_dic : Dictionary ={}



func _ready() -> void:
	SettingSignalBus.set_settings_dictionary.connect(on_Setting_save)
	

func on_Setting_save(data: Dictionary) -> void:
	var save_setting_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH,FileAccess.WRITE, "123456")
	var json_data_string = JSON.stringify(data)
	
	save_setting_data_file.store_line(json_data_string)
