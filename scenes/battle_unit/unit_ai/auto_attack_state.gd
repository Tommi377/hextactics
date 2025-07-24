class_name AutoAttackState
extends State

signal unable_to_attack

var actor_unit: BattleUnit
var target: BattleUnit

func _init(new_actor: Node, current_target: BattleUnit) -> void:
	actor = new_actor
	actor_unit = actor as BattleUnit
	target = current_target

func tick() -> void:
	if not target or target.dead or not _has_target_in_range():
		unable_to_attack.emit()
		return
	
	target.take_damage(1)
	actor_unit.animation_player.play("attack")
	

func _has_target_in_range() -> bool:
	return HexUtility.hex_cell_distance(actor_unit.coordinate, target.coordinate) <= 1
