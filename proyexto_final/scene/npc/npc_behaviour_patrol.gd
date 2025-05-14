@tool
extends NpcBehaviour

@export var walk_speed : float =30.0

var patrol_location : Array[PatrolLocation]
var current_location_index = 0
var target : PatrolLocation


func _ready() -> void:
	gather_patrol_location()
	
	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_location)
		child_order_changed.connect(gather_patrol_location)
	
	super()
	if patrol_location.size() ==0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_location[0]

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if npc.global_position.distance_to(target.target_position) < 1:
		start()

		
		
func gather_patrol_location(_n : Node = null) -> void:
	patrol_location =[]
	for i in get_children():
		if i is PatrolLocation:
			patrol_location.append(i)


func start() -> void:
	if npc.do_behaviour == false or patrol_location.size() < 2:
		return
		
	#idle
	npc.global_position = target.target_position
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	var wait_time : float = target.wait_time
	current_location_index +=1
	
	if  current_location_index >= patrol_location.size():
		current_location_index =0
		
	target = patrol_location[current_location_index]
	await  get_tree().create_timer(wait_time).timeout
	
	if npc.do_behaviour == false:
		return
	
	#walk
	npc.state = "walk"
	var _dir = global_position.direction_to(target.target_position)
	npc.direction = _dir
	npc.velocity = walk_speed * _dir
	npc.update_direction(target.target_position)
	npc.update_animation()
