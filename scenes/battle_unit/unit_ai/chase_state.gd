class_name ChaseState
extends State

signal target_reached(target: BattleUnit)

var actor_unit: BattleUnit
var target: BattleUnit
var tween: Tween

func enter() -> void:
	actor_unit = actor as BattleUnit
	_set_target(actor_unit.stats.team)

func _set_target(team: UnitStats.Team) -> void:
	if team == UnitStats.Team.PLAYER:
		target = actor_unit.get_tree().get_nodes_in_group("enemy_units").pick_random()
	else:
		target = actor_unit.get_tree().get_nodes_in_group("player_units").pick_random()


func tick() -> void:
	if tween and tween.is_running():
		await tween.finished
		
	if not target:
		_set_target(actor_unit.stats.team)
		if not target:
			return
			
	if _has_target_in_range():
		_end_chase()
		return
	
	var next_tile = UnitNavigation.get_next_position(actor_unit.coordinate, target.coordinate)
	if next_tile == null:
		return
	
	actor_unit.action_move.emit(next_tile)
	
	tween = actor_unit.create_tween()
	tween.tween_callback(actor_unit.animation_player.play.bind("move"))
	tween.tween_property(
		actor_unit,
		"global_position",
		actor_unit.game_area.get_global_from_tile(next_tile),
		0.25
	)
	tween.finished.connect(tween.kill)


func _end_chase() -> void:
	target_reached.emit(target)

func _has_target_in_range() -> bool:
	return HexUtility.hex_cell_distance(actor_unit.coordinate, target.coordinate) <= 1
