extends Node

signal on_window_mode_selected(index : int)
signal on_resolution_selected(index : int)
signal on_master_sound_set(float : int)
signal on_music_sound_set(float : int)
signal on_sfx_sound_set(float : int)

signal set_settings_dictionary(setting: Dictionary)

func emit_set_settings_dictionary(setting: Dictionary) -> void:
	set_settings_dictionary.emit(setting)

func emit_on_window_mode_selected(index : int) -> void:
	on_window_mode_selected.emit(index)


func emit_on_resolution_selected(index : int) -> void:
	on_resolution_selected.emit(index)


func emit_on_master_sound_set(index : float) -> void:
	on_master_sound_set.emit(index)


func emit_on_music_sound_set(index : float) -> void:
	on_music_sound_set.emit(index)


func emit_on_sfx_sound_set(index : float) -> void:
	on_sfx_sound_set.emit(index)
