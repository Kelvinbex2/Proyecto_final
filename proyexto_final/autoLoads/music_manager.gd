extends Node
@onready var music_player: AudioStreamPlayer = $MusicPlayer

func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	if music_player.playing:
		music_player.stop()

func set_volume_db(volume: float):
	music_player.volume_db = volume

func fade_out(duration := 1.0):
	var tween := create_tween()
	tween.tween_property(music_player, "volume_db", -80, duration)

func fade_in(volume := 0, duration := 1.0):
	music_player.volume_db = -80
	music_player.play()
	var tween := create_tween()
	tween.tween_property(music_player, "volume_db", volume, duration)
