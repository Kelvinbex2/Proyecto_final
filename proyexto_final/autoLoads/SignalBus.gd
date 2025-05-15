extends Node

signal on_collectable_collected(value : int)
signal on_coin_counter_update(value: int)
signal on_player_ready(player: Player)
signal on_hit(val : int)
signal on_enemy_death
signal on_game_state_manager_ready(GS:GameState)
signal on_player_entered_dead_zone
signal on_upgrade_purchased(upgrade:BaseUpgrade)
signal on_player_attack(player: Player)
signal on_player_die
signal on_level_changed
signal interact_pressed
signal on_portal_triggered
signal on_fruta_recogida(nueva_cantidad: int)
var game_state_manager: GameState = null


	
func get_game_state_manager() -> GameState:
	return game_state_manager
	
func emit_on_fruta_recogida(nueva_cantidad: int) -> void:
	on_fruta_recogida.emit(nueva_cantidad)


func emit_on_portal_triggered()-> void:
	on_portal_triggered.emit()

func emit_interact_pressed()-> void:
	interact_pressed.emit()


func emit_on_level_changed()-> void:
	on_level_changed.emit()
	
func emit_on_player_die()-> void:
	on_player_die.emit()
	
func emit_on_player_attack(player: Player) -> void:
	on_player_attack.emit(player)


func emit_on_player_entered_dead_zone() -> void:
	on_player_entered_dead_zone.emit()


func emit_on_upgrade_purchased(upgrade:BaseUpgrade)->void:
	on_upgrade_purchased.emit(upgrade)
	
func emit_on_game_state_manager_ready(GS:GameState) -> void:
	game_state_manager = GS
	on_game_state_manager_ready.emit(GS)
	
func emit_on_enemy_death()->void:
	on_enemy_death.emit()
	
	
func emit_on_collectable_collected(value : int) -> void:
	on_collectable_collected.emit(value)
	
func emit_on_coin_counter_update(value:int)-> void:
	on_coin_counter_update.emit(value)

func emit_on_player_ready(player: Player) -> void:
	on_player_ready.emit(player)
	
func  emit_on_hit(val : int) -> void:
		on_hit.emit(val)
