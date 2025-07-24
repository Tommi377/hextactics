# class_name SignalBus
extends Node

var combat = Combat.new()

class Combat:
	signal fight_start
	signal fight_end(winner: UnitStats.Team)
	signal fight_cleanup
