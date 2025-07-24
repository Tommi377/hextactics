class_name UnitAI
extends Node

@export var debug_label: Label
@export var actor: BattleUnit

var state_machine: StateMachine

func _ready() -> void:
	state_machine = StateMachine.new()
	state_machine.state_changed.connect(_on_state_machine_state_changed)
	_start_chasing()

func tick() -> void:
	if state_machine.current_state:
		state_machine.current_state.tick()

func _start_chasing() -> void:
	var chase_state := ChaseState.new(actor)
	chase_state.target_reached.connect(_on_chase_state_target_reached, CONNECT_ONE_SHOT)
	state_machine.change_state(chase_state)
	
func _on_chase_state_target_reached(target: BattleUnit) -> void:
	var aa_state := AutoAttackState.new(actor, target)
	state_machine.change_state(aa_state)
	state_machine.current_state.tick()
	
func _on_state_machine_state_changed(new_state: State):
	if not debug_label:
		return
	debug_label.text = new_state.get_script().get_global_name().trim_suffix("State")
