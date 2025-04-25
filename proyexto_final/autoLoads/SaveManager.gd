extends Node

const SETTINGS_SAVE_PATH : String = "user://SettingsData.save"

var settings_data_dic : Dictionary ={}



func _ready() -> void:
	SettingSignalBus.set_settings_dictionary.connect(on_Setting_save)
	SettingSignalBus.request_reload_settings.connect(load_setting_date)
	load_setting_date()
	
	

func on_Setting_save(data: Dictionary) -> void:
	var save_setting_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH,FileAccess.WRITE, "123456")
	var json_data_string = JSON.stringify(data)
	
	save_setting_data_file.store_line(json_data_string)


func load_setting_date() -> void :
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		return
		
	var save_setting_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH,FileAccess.READ,"123456")
	var loaded_data :Dictionary = {}
	
	
	while save_setting_data_file.get_position() < save_setting_data_file.get_length():
		var json_String = save_setting_data_file.get_line()
		var json = JSON.new()
		var _parsed_result = json.parse(json_String)
		
		loaded_data = json.get_data()
		
		SettingSignalBus.emit_load_settings_data(loaded_data)
		loaded_data ={}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
