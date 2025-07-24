class_name EndCombatButton
extends Button

@export var game_state: GameState

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	if game_state.current_phase == GameState.Phase.PREPARATION:
		return
	
	game_state.current_phase = GameState.Phase.PREPARATION
