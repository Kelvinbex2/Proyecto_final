extends RichTextEffect
class_name WaveEffect

var bbcode: String = "wave"
func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var amp = 20.0
	var freq = 4.0
	if "amp" in char_fx.env:
		amp = float(char_fx.env["amp"])
	if "freq" in char_fx.env:
		freq = float(char_fx.env["freq"])

	char_fx.offset.y += sin(char_fx.elapsed_time * freq + char_fx.relative_index * 0.5) * amp
	return true

func _get_bbcode() -> String:
	return "wave"
