class_name BattleUnit extends Area2D

@export var stats: UnitStats : set = set_stat
@export var DEFAULT_Z_INDEX := 1

@onready var sprite: Sprite2D = %Sprite
@onready var health_bar: ProgressBar = %HealthBar

func set_stat(value: UnitStats) -> void:
	stats = value
	
	if not stats or not is_instance_valid(sprite):
		return
		
	sprite.region_rect.position = Vector2(value.sprite_atlas) * 32
	collision_layer = stats.team + 1
