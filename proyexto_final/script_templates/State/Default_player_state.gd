extends _BASE_

func _ready() -> void:
	set_physics_process(false)
	
func enter_state() ->void:
	set_physics_process(true)
	

func exit_state() ->void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	pass
