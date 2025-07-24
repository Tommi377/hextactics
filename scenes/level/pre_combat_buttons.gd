class_name PreCombatButtons
extends HBoxContainer

func _ready() -> void:
	SignalBus.combat.fight_start.connect(_on_combat_fight_start)
	SignalBus.combat.fight_cleanup.connect(_on_combat_fight_cleanup)

func _on_combat_fight_start() -> void:
	self.visible = false

func _on_combat_fight_cleanup() -> void:
	self.visible = true
