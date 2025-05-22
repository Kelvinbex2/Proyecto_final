extends CanvasLayer

@onready var rich_text: RichTextLabel = $Control/PanelContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var credits_loaded := false

func _ready() -> void:
	
	animation_player.play("pop_out")

	var loader = TextEffectsLoader.new()
	add_child(loader)
	await get_tree().process_frame

	loader.register_all_effects(rich_text)

	var file = FileAccess.open("res://scene/credit/credits_text.txt", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		rich_text.clear()
		rich_text.parse_bbcode(content)
		credits_loaded = true  # ✅ Marcamos que ya está listo

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "pop_out" and credits_loaded:
		rich_text.visible = true
