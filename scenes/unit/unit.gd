@tool
class_name Unit extends Area2D

@export var stats: UnitStats : set = set_stat

@onready var sprite: Sprite2D = %Sprite
@onready var health_bar: ProgressBar = %HealthBar
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

const DEFAULT_Z_INDEX := 1

var is_hovered = false

func set_stat(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
		
	if not is_node_ready():
		await ready
		
	sprite.region_rect.position = Vector2(value.sprite_atlas) * 32


func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
	
	is_hovered = true
	outline_highlighter.highlight()
	z_index = DEFAULT_Z_INDEX + 1


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
		
	is_hovered = false
	outline_highlighter.clear_highlight()
	z_index = DEFAULT_Z_INDEX
