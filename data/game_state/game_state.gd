class_name GameState extends Resource

enum Phase {
	PREPARATION,
	BATTLE
}

@export var current_phase: Phase:
	set(value):
		current_phase = value
		emit_changed()
