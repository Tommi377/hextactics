class_name UnitStats extends Resource

enum Team {PLAYER, ENEMY}

@export var name: String

@export_category("Data")
@export var health := 5

@export_category("Visuals")
@export var sprite_atlas: Vector2i

@export_category("Battle")
@export var team: Team

func _to_string() -> String:
	return name
