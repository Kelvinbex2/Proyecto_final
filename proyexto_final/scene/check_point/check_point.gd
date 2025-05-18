extends Area2D
@onready var respawn: Marker2D = $Respawn

var check_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_manager =get_parent().get_node("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		check_manager.last_location = respawn.global_position
