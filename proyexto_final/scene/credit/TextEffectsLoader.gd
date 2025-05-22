extends Node
class_name TextEffectsLoader

func register_all_effects(target: RichTextLabel) -> void:
	target.custom_effects.clear()
	target.custom_effects.append(GlitchEffect.new())
	target.custom_effects.append(WaveEffect.new())
	target.custom_effects.append(ShakeEffect.new())
	target.custom_effects.append(TypewriterEffect.new())
	target.custom_effects.append(FireEffect.new()) 
	target.custom_effects.append(FadeTimedEffect.new()) 
