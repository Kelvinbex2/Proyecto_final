@tool
extends NpcBehaviour
const COLORS = [Color(1,0,0), Color(1,1,0),Color(0,1,0),Color(0,1,1),Color(0,0,1),Color(1,0,1),]

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
	
	if Engine.is_editor_hint():
		if patrol_location.size() > 0:
			for j in patrol_location.size():
				var _p = patrol_location[j] as PatrolLocation
				
				if not _p.transform_changed.is_connected(gather_patrol_location):
					_p.transform_changed.connect(gather_patrol_location)
					
				_p.update_label(str(j))
				_p.modulate = _get_color(j)
				
				var _next : PatrolLocation
				if j < patrol_location.size() -1 :
					_next = patrol_location[j + 1]
				else :
					_next = patrol_location[0]
					_p.update_line(_next.position)


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



func _get_color(i : int)-> Color:
	var color_count : int = COLORS.size()
	while  i > color_count -1:
		i -= color_count
	return COLORS[i]
