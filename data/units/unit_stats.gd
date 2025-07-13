class_name UnitStats extends Resource

@export var name: String

@export_category("Data")
@export var health := 5

@export_category("Visuals")
@export var sprite_atlas: Vector2i

func _to_string() -> String:
	return name
