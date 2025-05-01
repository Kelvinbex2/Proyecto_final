extends Area2D

@export var dialogue_scene: PackedScene
@export var main_menu_scene_path: String = "res://scene/ui/main_menu.tscn"

var has_been_asked := false

var dialogue_instance: Node = null
var player_in_area: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if has_been_asked:
		return

	if body.is_in_group("Player"):
		player_in_area = body
		if dialogue_instance == null:
			show_dialogue()
			has_been_asked = true


func _on_body_exited(body: Node) -> void:
	if body == player_in_area:
		player_in_area = null
		# Opcional: hide_dialogue()

func show_dialogue() -> void:
	if not dialogue_scene:
		print("Error: Escena de diálogo no asignada en ", name)
		return

	dialogue_instance = dialogue_scene.instantiate()
	get_tree().root.add_child(dialogue_instance)

	get_tree().paused = true  # Pause everything...

	
	if player_in_area and player_in_area.has_method("freeze"):
		player_in_area.freeze()

	var yes_button: Button = dialogue_instance.find_child("btnSi", true, false)
	var no_button: Button = dialogue_instance.find_child("btnNo", true, false)
	
	if yes_button:
		if not yes_button.pressed.is_connected(_on_yes_pressed):
			yes_button.pressed.connect(_on_yes_pressed, CONNECT_ONE_SHOT)
	else:
		print("Error: No se encontró 'btnSi' en la escena de diálogo.")

	if no_button:
		if not no_button.pressed.is_connected(_on_no_pressed):
			no_button.pressed.connect(_on_no_pressed, CONNECT_ONE_SHOT)
	else:
		print("Error: No se encontró 'btnNo' en la escena de diálogo.")


func hide_dialogue() -> void:
	if dialogue_instance:
		get_tree().paused = false  
		dialogue_instance.queue_free()
		dialogue_instance = null

func _on_yes_pressed() -> void:
	print("Jugador eligió SÍ")
	get_tree().paused = false
	hide_dialogue()
	if player_in_area and player_in_area.has_method("unfreeze"):
		player_in_area.unfreeze()

func _on_no_pressed() -> void:
	print("Jugador eligió NO")
	get_tree().paused = false
	hide_dialogue()
	if player_in_area and player_in_area.has_method("unfreeze"):
		player_in_area.unfreeze()
	call_deferred("_change_to_main_menu")


func _change_to_main_menu() -> void:
	var error = get_tree().change_scene_to_file(main_menu_scene_path)
	if error != OK:
		print("Error al cargar el menú principal: ", error, " ruta: ", main_menu_scene_path)
