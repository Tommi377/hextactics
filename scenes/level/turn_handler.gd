class_name TurnHandler
extends Node

@export var timer: Timer

var turn_queue: Array[BattleUnit]

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
func add_unit(unit: BattleUnit):
	turn_queue.push_back(unit)
	
func _on_timer_timeout() -> void:
	var unit = turn_queue.pop_front()
	if not unit:
		return

	unit.tick()
	add_unit(unit)
