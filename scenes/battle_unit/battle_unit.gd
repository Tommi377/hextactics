class_name BattleUnit
extends Area2D

signal action_move(new_tile: Vector2i)

const my_scene: PackedScene = preload("res://scenes/battle_unit/battle_unit.tscn")

@export var stats: UnitStats : set = set_stat
@export var DEFAULT_Z_INDEX := 1

@onready var unit_ai: UnitAI = %UnitAI

@onready var sprite: Sprite2D = %Sprite
@onready var health_bar: ProgressBar = %HealthBar
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var coordinate = null
var game_area: PlayArea
var battle_unit_grid: UnitGrid

static func instantiate(game_area: PlayArea, unit_grid: UnitGrid) -> BattleUnit:
	var battle_unit := my_scene.instantiate()
	battle_unit.game_area = game_area
	battle_unit.battle_unit_grid = unit_grid
	unit_grid.add_child(battle_unit)
	return battle_unit

func set_stat(value: UnitStats) -> void:
	stats = value
	
	if not stats or not is_instance_valid(sprite):
		return
		
	stats.reset_health()
		
	sprite.region_rect.position = Vector2(value.sprite_atlas) * 32
	collision_layer = stats.team + 1
	health_bar.stats = stats

func tick() -> void:
	unit_ai.tick()
	
func set_coordinate(value: Vector2) -> void:
	coordinate = value
