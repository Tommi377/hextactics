class_name PlayerStats extends Resource

@export_range(0, 99) var gold: int : set = set_gold
@export_range(0, 99) var xp: int : set = set_xp

func set_gold(new_value: int) -> void:
	gold = new_value
	emit_changed()
	
func set_xp(new_value: int) -> void:
	xp = new_value
	emit_changed()
