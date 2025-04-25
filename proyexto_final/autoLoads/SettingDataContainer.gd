extends Node

var window_mode_index = 0
var resolutionindex = 0
var master_volume = 0
var music_volume = 0
var sfx_volume = 0



func _ready() -> void:
	handle_signals()
	create_storage_dictionary()

func on_window_mode_selected(index : int) -> void:
	window_mode_index = index

func on_resolution_selected(index:int) -> void:
	resolutionindex=index


func on_master_sound_set(index:int) -> void:
	master_volume = index

func on_music_sound_set(index:int) -> void:
	music_volume = index

func on_sfx_sound_set(index:int) -> void:
	sfx_volume = index
	

func create_storage_dictionary() -> Dictionary:
	var settings_container_dic : Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolutionindex": resolutionindex,
		"master_volume": master_volume,
		"music_volume":music_volume,
		"sfx_volume" : sfx_volume,
		"move_left" : InputMap.action_get_events("move_left"),
		"move_right" : InputMap.action_get_events("move_right"),
		"jump" : InputMap.action_get_events("jump_up")
	}
	
	return settings_container_dic
	
	
func handle_signals() -> void:
	SettingSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingSignalBus.on_master_sound_set.connect(on_master_sound_set)
	SettingSignalBus.on_music_sound_set.connect(on_music_sound_set)
	SettingSignalBus.on_sfx_sound_set.connect(on_sfx_sound_set)
	
	
