extends CanvasLayer

@onready var rich_text: RichTextLabel = $Control/PanelContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $Control/AudioStreamPlayer

var credits_loaded := false

func _ready() -> void:
	audio.play()
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
		credits_loaded = true  
		
		await get_tree().create_timer(20.0).timeout
		get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")
