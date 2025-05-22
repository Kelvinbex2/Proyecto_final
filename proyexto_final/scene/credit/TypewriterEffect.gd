extends RichTextEffect
class_name TypewriterEffect

@export var delay := 0.05

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if char_fx.elapsed_time < char_fx.relative_index * delay:
		char_fx.visible = false
	else:
		char_fx.visible = true
	return true


func _get_bbcode() -> String:
	return "typewriter"
