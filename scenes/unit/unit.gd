@tool
class_name Unit extends Area2D

@export var stats: UnitStats : set = set_stat
@export var default_z_index := 1

@onready var sprite: Sprite2D = %Sprite
@onready var health_bar: ProgressBar = %HealthBar
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)

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
	
	outline_highlighter.highlight()
	z_index = default_z_index + 1


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
		
	outline_highlighter.clear_highlight()
	z_index = default_z_index

func _on_drag_started() -> void:
	pass
	
func _on_drag_canceled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)

func reset_after_dragging(starting_position: Vector2) -> void:
	global_position = starting_position
