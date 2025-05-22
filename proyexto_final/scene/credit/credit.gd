extends CanvasLayer

@onready var rich_text: RichTextLabel = $Control/PanelContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var texture_rect: TextureRect = $TextureRect
@onready var panel_container := $Control/PanelContainer

var credits_loaded := false

func _ready() -> void:
	texture_rect.z_index = -1
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	audio.play()
	animation_player.play("pop_out")

	
	var screen_height = get_viewport().get_visible_rect().size.y
	panel_container.position.y = screen_height

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

		
		await get_tree().process_frame
		await get_tree().process_frame

	
		print("Texto size Y:", rich_text.size.y)

		var target_y = -panel_container.size.y  
		var tween = create_tween()
		tween.tween_property(panel_container, "position:y", target_y, 20.0)

		await get_tree().create_timer(20.0).timeout
		get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")
