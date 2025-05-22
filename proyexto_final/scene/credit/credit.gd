extends CanvasLayer

@onready var rich_text: RichTextLabel = $Control/PanelContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var tween := create_tween()
@onready var texture_rect: TextureRect = $TextureRect

var credits_loaded := false

func _ready() -> void:
	texture_rect.z_index = -1
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	audio.play()
	animation_player.play("pop_out")
	tween.tween_property($Control/PanelContainer, "position:y", -500, 20.0)

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
