extends Node
class_name MultiplayerManagers


var peer := ENetMultiplayerPeer.new()
signal multiplayer_ready

func host_game(port := 8888):
	if multiplayer.multiplayer_peer != null:
		print("❌ Ya hay una conexión activa.")
		return

	var result = peer.create_server(port)
	if result != OK:
		print("❌ Error al iniciar el servidor:", result)
		return

	multiplayer.multiplayer_peer = peer
	print("🌐 Host iniciado en el puerto", port)
	emit_signal("multiplayer_ready")

func join_game(ip := "localhost", port := 8888):
	if multiplayer.multiplayer_peer != null:
		print("❌ Ya estás conectado a un servidor.")
		return

	var result = peer.create_client(ip, port)
	if result != OK:
		print("❌ Error al intentar conectarse:", result)
		return

	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_connected, CONNECT_ONE_SHOT)

func _on_connected():
	print("✅ Cliente conectado")
	emit_signal("multiplayer_ready")


func reset_multiplayer():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		print("🔄 Conexión de multiplayer reiniciada.")
