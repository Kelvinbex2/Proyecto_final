@tool
class_name NpcWander
extends NpcBehaviour

const DIRECTIONS = [Vector2.RIGHT,Vector2.LEFT]
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var wander_range  = 2 : set = _set_wander_range
@export var wander_speed =30.0
@export var  wander_duration =1.0
@export var idle_duration = 1.0

var original_pos : Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	super()
	collision_shape.queue_free()
	original_pos = npc.global_position

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if abs(global_position.distance_to(original_pos)) > wander_range * 32:
		npc.velocity *=-1
		npc.direction *=-1
		npc.update_direction(global_position + npc.direction)
		npc.update_animation()

func start() -> void:
	#Idle
	if npc.do_behaviour ==false:
		return
	
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	await  get_tree().create_timer(randf() * idle_duration + idle_duration).timeout
	
	# Walk
	npc.state = "walk"
	var _dir : Vector2 = DIRECTIONS[randi_range(0,1)]
	npc.direction = _dir
	npc.velocity = wander_speed * _dir
	npc.update_direction(global_position + _dir)
	npc.update_animation()
	await  get_tree().create_timer(randf() * wander_duration + wander_duration).timeout
	
	
	#repeat
	
	if npc.do_behaviour == false:
		return
	start()

func _set_wander_range(val: int) -> void:
	wander_range = val
	if collision_shape and collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = val * 32.0
