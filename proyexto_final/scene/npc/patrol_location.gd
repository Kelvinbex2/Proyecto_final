@tool
class_name PatrolLocation extends Node2D
signal transform_changed

@onready var label: Label = $Sprite2D/Label
@onready var sprite: Sprite2D = $Sprite2D
@onready var label_2: Label = $Sprite2D/Label2
@onready var line: Line2D = $Sprite2D/Line2D

@export var wait_time : float = 0.0 :
	set(val):
		wait_time = val
		_update_wait_time_label()

var target_position : Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	set_notify_transform(true)
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		transform_changed.emit()

func _ready() -> void:
	target_position = global_position
	_update_wait_time_label()
	
	if Engine.is_editor_hint():
		return
	sprite.queue_free()
	
	

func update_label(_s : String) -> void:
	label.text = _s
	

func update_line (next : Vector2) -> void:
	var linea : Line2D = line
	linea.points[1] = next - position
	
func _update_wait_time_label() -> void:
	if Engine.is_editor_hint():
		label_2.text = "wait: " + str(snapped(wait_time, 0.1) ) + "s"
		
