extends RichTextEffect
class_name ShakeEffect

var rng = RandomNumberGenerator.new()

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	rng.randomize()

	var rate = 30.0
	var level = 5.0
	if "rate" in char_fx.env:
		rate = float(char_fx.env["rate"])
	if "level" in char_fx.env:
		level = float(char_fx.env["level"])

	char_fx.offset.x += rng.randf_range(-level, level)
	char_fx.offset.y += rng.randf_range(-level, level)
	return true

func _get_bbcode() -> String:
	return "shake"
