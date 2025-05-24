class_name GameState
extends Node
@onready var state_timer: Timer = $StateTimer
@export var upgrade_menu: PackedScene = null
@export var level_1: PackedScene = null
@export var level_2: PackedScene = null
var level_stage := 1  
var current_level_scene: PackedScene = null  



var upgrade_menu_exists: bool = false
var level_exists: bool = false

enum {
	ActiveState,
	UpgradeState,
}
var current_state = ActiveState

func _ready() -> void:
	if multiplayer.is_server():
		add_player(multiplayer.get_unique_id())

	multiplayer.peer_connected.connect(_on_peer_connected)
	state_timer.timeout.connect(on_active_state_end)
	SignalBus.emit_on_game_state_manager_ready(self)
	SignalBus.on_portal_triggered.connect(_on_portal_triggered)

	load_level()  # Cargamos solo el primer nivel al iniciar

	
	

func _process(delta: float) -> void:
	match current_state:
		ActiveState:
			get_tree().paused = false
		UpgradeState:
			run_upgrade_state()

func run_upgrade_state() -> void:
	if not get_tree().paused:
		get_tree().paused = true

	if upgrade_menu_exists:
		return

	var new_upgrade_menu = upgrade_menu.instantiate() as UpgradeMenu
	var ui_container = NodeExtensions.get_ui_container()
	if ui_container == null:
		return

	ui_container.add_child(new_upgrade_menu)
	new_upgrade_menu.exit_btn_pressed.connect(on_upgrade_state_end)
	upgrade_menu_exists = true
	
	MusicManager.fade_out(1.0)

func on_active_state_end() -> void:
	current_state = UpgradeState

func load_level() -> void:
	var level_container: Node2D = NodeExtensions.get_level_container()
	if level_container == null:
		return

	# Elimina el nivel anterior si existe
	if level_container.get_child_count() > 0:
		var existing_level = level_container.get_child(0)
		if existing_level:
			existing_level.queue_free()

	await get_tree().process_frame  # Esperamos un frame para que se elimine correctamente

	SignalBus.emit_on_level_changed()

	var new_level: Node = null

	match level_stage:
		1:
			current_level_scene = level_1
			new_level = level_1.instantiate()
			level_stage = 2
		2:
			current_level_scene = level_2
			new_level = level_2.instantiate()
			level_stage = -1  # Ya no hay más niveles

	if new_level:
		level_container.add_child(new_level)
		MusicManager.play_music()
		print("✔ Nivel cargado:", new_level.name)
	else:
		print("⚠ No hay más niveles que cargar.")


		
	

func on_upgrade_state_end() -> void:
	upgrade_menu_exists = false
	current_state = ActiveState
	MusicManager.fade_in(0.0, 1.0)
	#load_level()
	##get_tree().reload_current_scene()

func _on_portal_triggered() -> void:
	load_level()


func restart_level() -> void:
	var level_container: Node2D = NodeExtensions.get_level_container()
	if level_container == null:
		return

	# Elimina el nivel actual
	if level_container.get_child_count() > 0:
		var existing_level = level_container.get_child(0)
		if existing_level:
			existing_level.queue_free()

	await get_tree().process_frame
	SignalBus.emit_on_level_changed()



	if current_level_scene != null:
		var new_level = current_level_scene.instantiate()
		level_container.add_child(new_level)
		print("🔁 Nivel reiniciado:", new_level.name)
	else:
		print("⚠ No se pudo reiniciar el nivel.")


func _on_peer_connected(peer_id):
	add_player(peer_id)

func add_player(peer_id: int):
	var player = preload("res://scene/player/player.tscn").instantiate()
	player.name = "Player_%s" % peer_id
	player.set_multiplayer_authority(peer_id)
	NodeExtensions.get_entity_container().add_child(player)
