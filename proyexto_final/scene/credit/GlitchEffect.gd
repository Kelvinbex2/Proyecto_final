extends RichTextEffect
class_name GlitchEffect

var rng = RandomNumberGenerator.new()

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	rng.randomize()
	
	
	char_fx.offset.x += rng.randf_range(-1.5, 1.5)
	char_fx.offset.y += rng.randf_range(-2.0, 2.0)

	
	char_fx.color = Color(
		1.0,
		rng.randf_range(0.6, 1.0),
		rng.randf_range(0.6, 1.0)
	)

	return true 


func _get_bbcode() -> String:
	return "glitch"
