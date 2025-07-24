class_name UnitStats extends Resource

enum Team {PLAYER, ENEMY}

signal health_reached_zero

@export var name: String

@export_category("Data")
@export var max_health := 5

@export_category("Visuals")
@export var sprite_atlas: Vector2i

@export_category("Battle")
@export var team: Team
@export var attack_damage: int
@export var attack_speed: int

var health: int :
	set = _set_health

func take_damage(damage: int) -> void:
	health -= damage

func reset_health() -> void:
	health = max_health

func _set_health(value: int) -> void:
	health = value
	emit_changed()
	
	if health <= 0:
		health = 0
		health_reached_zero.emit()

func _to_string() -> String:
	return name
