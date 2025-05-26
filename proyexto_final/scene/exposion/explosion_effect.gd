extends StaticBody2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var explosion_audio: AudioStreamPlayer2D = $explosion_audio


var boss: Node = null
var exploded: bool = false

func _ready():
	var bosses = get_tree().get_nodes_in_group("Boss")
	if bosses.size() > 0:
		boss = bosses[0]
	else:
		print("❌ No se encontró ningún nodo en el grupo 'Boss'.")

func _process(_delta):
	if exploded or boss == null:
		return

	if boss.has_node("Handlers/HealthHandler"):
		var health = boss.get_node("Handlers/HealthHandler")
		if health.is_dead:
			explode()

func explode():
	exploded = true
	print("💥 El muro explota porque el jefe ha muerto.")

	particles.emitting = true
	sprite.visible = false
	collider.disabled = true

	if explosion_audio:
		explosion_audio.play()

	
	SignalBus.emit_signal("on_camera_shake", 0.5)  

	await get_tree().create_timer(1.5).timeout
	queue_free()
