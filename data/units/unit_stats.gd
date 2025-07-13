class_name UnitStats extends Resource

@export var name: String

@export_category("Data")
@export var health := 5

@export_category("Visuals")
@export var sprite: Texture2D

func _to_string() -> String:
	return name
