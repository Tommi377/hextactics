class_name AutoAttackState
extends State

var actor_unit: BattleUnit
var target: BattleUnit

func _init(new_actor: Node, current_target: BattleUnit) -> void:
	actor = new_actor
	actor_unit = actor as BattleUnit
	target = current_target

func tick() -> void:
	actor_unit.animation_player.play("attack")
	print("%s should perform attacks!" % actor_unit.name)
