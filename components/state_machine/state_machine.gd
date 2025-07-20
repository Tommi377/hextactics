class_name StateMachine
extends RefCounted

signal state_changed(new_state: State)

var current_state: State

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	if new_state:
		new_state.enter()
	
	current_state = new_state
	state_changed.emit(current_state)
