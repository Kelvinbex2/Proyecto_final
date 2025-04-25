extends Control

@onready var lbl_audio_name: Label = $HBoxContainer/lblAudioName
@onready var lbl_audio_number: Label = $HBoxContainer/lblAudioNumber
@onready var h_slider: HSlider = $HBoxContainer/HSlider
@export_enum("Master","Music","Sfx") var bus_name : String

var index_bus : int = 0

func _ready() -> void:
	h_slider.value_changed.connect(on_val_changed)
	get_bus_name_index()
	load_data()
	set_name_label()
	set_slider_value()
	

func load_data () -> void:
	match bus_name:
		"Master":
			on_val_changed(SettingDataContainer.get_master_volume())
		"Music":
			on_val_changed(SettingDataContainer.get_music_volume())
		"Sfx":
			on_val_changed(SettingDataContainer.get_sfx_volume())
	
	
func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(index_bus))
	set_audio_label()
	
	
func set_name_label()-> void:
	lbl_audio_name.text = str(bus_name) + " Volume"
	
func set_audio_label()-> void:
	lbl_audio_number.text = str(int(h_slider.value * 100)) + "%"


func get_bus_name_index()-> void:
	index_bus = AudioServer.get_bus_index(bus_name)

func on_val_changed(val : float) -> void:
	AudioServer.set_bus_volume_db(index_bus, linear_to_db(val))
	set_audio_label()

	match index_bus:
		0:
			SettingSignalBus.emit_on_master_sound_set(val)
		1:
			SettingSignalBus.emit_on_music_sound_set(val)
		2:
			SettingSignalBus.emit_on_sfx_sound_set(val)
