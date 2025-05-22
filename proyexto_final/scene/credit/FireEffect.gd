extends RichTextEffect
class_name FireEffect

var rng = RandomNumberGenerator.new()

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t = char_fx.elapsed_time
	var sin_wave = sin(t * 10.0 + char_fx.absolute_index)
	char_fx.offset.y -= abs(sin_wave * 2.0)
	char_fx.color = Color(1.0, rng.randf_range(0.3, 0.7), 0.0)  # Fire orange
	return true


func _get_bbcode() -> String:
	return "fire"
