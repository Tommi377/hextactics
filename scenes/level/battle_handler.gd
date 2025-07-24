class_name BattleHandler extends Node

signal player_won
signal enemy_won

@export var game_state: GameState
@export var game_area: PlayArea
@export var normal_unit_grid: UnitGrid
@export var battle_unit_grid: UnitGrid
@export var turn_handler: TurnHandler

const ENEMY_POSITIONS := [
	Vector2i(0, 0),
]
const ENEMY = preload("res://data/units/enemy.tres")

func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)
	
func _clean_up_fight() -> void:
	get_tree().call_group("player_units", "queue_free")
	get_tree().call_group("enemy_units", "queue_free")
	get_tree().call_group("units", "show")
	SignalBus.combat.fight_cleanup.emit()
	
func _prepare_fight() -> void:
	get_tree().call_group("units", "hide")
	
	for unit_coord: Vector2 in normal_unit_grid.get_all_occupied():
		var unit: Unit = normal_unit_grid.get_unit(unit_coord)
		var new_unit := BattleUnit.instantiate(game_area, battle_unit_grid)
		new_unit.add_to_group("player_units")
		new_unit.stats = unit.stats.duplicate()
		new_unit.stats.team = UnitStats.Team.PLAYER
		_setup_battle_unit(unit_coord, new_unit)
		
	for unit_coord: Vector2 in ENEMY_POSITIONS:
		var new_unit := BattleUnit.instantiate(game_area, battle_unit_grid)
		new_unit.add_to_group("enemy_units")
		new_unit.stats = ENEMY.duplicate()
		new_unit.stats.team = UnitStats.Team.ENEMY
		_setup_battle_unit(unit_coord, new_unit)
	
	SignalBus.combat.fight_start.emit()
	
func _setup_battle_unit(unit_coord: Vector2i, new_unit: BattleUnit) -> void:
	new_unit.global_position = game_area.get_global_from_tile(unit_coord)

	new_unit.action_move.connect(_on_battle_unit_action_move.bind(new_unit))
	new_unit.action_die.connect(_on_battle_unit_action_die.bind(new_unit))
	new_unit.tree_exited.connect(_on_battle_unit_tree_exited)
	

	battle_unit_grid.add_unit(unit_coord, new_unit)
	turn_handler.add_unit(new_unit)
	
func _on_battle_unit_action_die(unit: BattleUnit) -> void:
	unit.queue_free()
	
func _on_battle_unit_tree_exited() -> void:
	if not is_inside_tree() or game_state.current_phase == GameState.Phase.PREPARATION:
		return
		
	if get_tree().get_node_count_in_group("enemy_units") == 0:
		SignalBus.combat.fight_end.emit(UnitStats.Team.PLAYER)
	elif get_tree().get_node_count_in_group("player_units") == 0:
		SignalBus.combat.fight_end.emit(UnitStats.Team.ENEMY)
	
func _on_battle_unit_action_move(target: Vector2i, unit: BattleUnit) -> void:
	battle_unit_grid.remove_unit(unit.coordinate)
	battle_unit_grid.add_unit(target, unit)
	return

func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clean_up_fight()
		GameState.Phase.BATTLE:
			_prepare_fight()
	pass
