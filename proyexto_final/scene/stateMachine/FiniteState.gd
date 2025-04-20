class_name FiniteState
extends Node

@export var current_state : State = null

func _ready() -> void:
	change_state(current_state)
	
func change_state(new_state: State) -> void:
		if current_state is State:
			current_state.exit_state()
		
		new_state.enter_state()
		current_state = new_state
		
