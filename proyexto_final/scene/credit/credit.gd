extends CanvasLayer

@onready var rich_text: RichTextLabel = $Control/PanelContainer/RichTextLabel

func _ready() -> void:
	var loader = TextEffectsLoader.new()
	add_child(loader)
	await get_tree().process_frame

	# Register effects BEFORE enabling bbcode and parsing
	loader.register_all_effects(rich_text)


	# Load and parse the text file
	var file = FileAccess.open("res://scene/credit/credits_text.txt", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		rich_text.clear()
		rich_text.parse_bbcode(content)
