extends Node
@onready var DEFAUKT_SETTINGS : DefaultSettingResource = preload("res://scene/resources/settingFolder/DefaultSettings.tres")
@onready var keyBind_resource : PlayerKeyBindResource = preload("res://scene/resources/settingFolder/PlayerKeyBindDefault.tres")
var window_mode_index = 0
var resolution_index = 0
var master_volume = 0
var music_volume = 0
var sfx_volume = 0
var loaded_data : Dictionary = {}



func _ready() -> void:
	handle_signals()
	create_storage_dictionary()


func create_storage_dictionary() -> Dictionary:
	var settings_container_dic : Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index": resolution_index,
		"master_volume": master_volume,
		"music_volume":music_volume,
		"sfx_volume" : sfx_volume,
		"keybinds" : creat_keybind_dictionary()
		
	}
	
	return settings_container_dic

func creat_keybind_dictionary() -> Dictionary:
	var keybinds_container = {
		keyBind_resource.MOVE_LEFT : keyBind_resource.move_left_key,
		keyBind_resource.MOVE_RIGHT : keyBind_resource.move_right_key,
		keyBind_resource.JUMP : keyBind_resource.jump_key
		
	}
	
	
	return keybinds_container
	
	
	
func get_window_mode_index()-> int:
	if loaded_data =={}:
		return DEFAUKT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	
	return window_mode_index
	
func get_resolution_index()-> int:
	if loaded_data =={}:
		return DEFAUKT_SETTINGS.DEFAULT_RESOLUTION_MODE_INDEX
	
	return resolution_index
	

func get_master_volume() -> float:
	if loaded_data =={}:
		return DEFAUKT_SETTINGS.DEFAULT_MASTER_VOLUME
	return master_volume
	
	
func get_music_volume() -> float:
	if loaded_data =={}:
		return DEFAUKT_SETTINGS.DEFAULT_MUSIC_VOLUME
	
	return music_volume
	
	
func get_sfx_volume() -> float:
	if loaded_data =={}:
		return DEFAUKT_SETTINGS.DEFAULT_SFX_VOLUME
	
	return sfx_volume

func  get_keybind(action:String) :
	if !loaded_data.has("keybinds"):
		match action:
			keyBind_resource.MOVE_LEFT:
				return keyBind_resource.DEFAULT_MOVE_LEFT_KEY
			keyBind_resource.MOVE_RIGHT:
				return keyBind_resource.DEFAULT_MOVE_RIGHT_KEY
			keyBind_resource.JUMP:
				return keyBind_resource.DEFAULT_JUMP_KEY
	else:
		match action:
			keyBind_resource.MOVE_LEFT:
				return keyBind_resource.move_left_key
			keyBind_resource.MOVE_RIGHT:
				return keyBind_resource.move_right_key
			keyBind_resource.JUMP:
				return keyBind_resource.jump_key
	

func on_window_mode_selected(index : int) -> void:
	window_mode_index = index

func on_resolution_selected(index:int) -> void:
	resolution_index=index


func on_master_sound_set(index:float) -> void:
	master_volume = index

func on_music_sound_set(index:float) -> void:
	music_volume = index

func on_sfx_sound_set(index:float) -> void:
	sfx_volume = index


func set_keybind(action : String, event ) -> void:
	match action:
		keyBind_resource.MOVE_LEFT:
			keyBind_resource.move_left_key = event
		keyBind_resource.MOVE_RIGHT:
			keyBind_resource.move_right_key = event
		keyBind_resource.JUMP:
			keyBind_resource.jump_key = event
		
	
	
	
	
func on_keybinds_loaded(data: Dictionary) -> void:
	var loaded_move_left = InputEventKey.new()
	var loaded_move_right = InputEventKey.new()
	var loaded_jump = InputEventKey.new()
	
	loaded_move_left.set_physical_keycode(int(data.move_left))
	loaded_move_right.set_physical_keycode(int(data.move_right))
	loaded_jump.set_physical_keycode(int(data.jump_up))
	
	keyBind_resource.move_left_key = loaded_move_left
	keyBind_resource.move_right_key = loaded_move_right
	keyBind_resource.jump_key = loaded_jump
	
	
func on_setting_data_loaded(data:Dictionary) -> void:
	loaded_data = data
	on_window_mode_selected(loaded_data.window_mode_index)
	on_resolution_selected(loaded_data.resolution_index)
	on_master_sound_set(loaded_data.master_volume)
	on_music_sound_set(loaded_data.music_volume)
	on_sfx_sound_set(loaded_data.sfx_volume)
	on_keybinds_loaded(loaded_data.keybinds)


	
func handle_signals() -> void:
	SettingSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingSignalBus.on_master_sound_set.connect(on_master_sound_set)
	SettingSignalBus.on_music_sound_set.connect(on_music_sound_set)
	SettingSignalBus.on_sfx_sound_set.connect(on_sfx_sound_set)
	SettingSignalBus.load_settings_data.connect(on_setting_data_loaded)
	
