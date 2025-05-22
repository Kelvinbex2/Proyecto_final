extends RichTextEffect
class_name FadeTimedEffect
var bbcode: String = "timedfade"
@export var fade_in_time := 2.0  # seconds to fade in
@export var visible_duration := 56.0  # seconds fully visible
@export var fade_out_time := 2.0  # seconds to fade out

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t := char_fx.elapsed_time
	var total_duration := fade_in_time + visible_duration + fade_out_time

	if t < fade_in_time:
		# Fade in
		var alpha := t / fade_in_time
		char_fx.color.a = clamp(alpha, 0.0, 1.0)
	elif t < fade_in_time + visible_duration:
		# Fully visible
		char_fx.color.a = 1.0
	elif t < total_duration:
		# Fade out
		var out_t := t - fade_in_time - visible_duration
		var alpha := 1.0 - (out_t / fade_out_time)
		char_fx.color.a = clamp(alpha, 0.0, 1.0)
	else:
		# After full cycle: hide
		char_fx.visible = false

	return true

func _get_bbcode() -> String:
	return "timedfade"
