class_name AfterCombatButtons
extends HBoxContainer

func _ready() -> void:
	SignalBus.combat.fight_end.connect(_on_combat_fight_end.unbind(1))
	SignalBus.combat.fight_cleanup.connect(_on_combat_fight_cleanup)

func _on_combat_fight_end() -> void:
	self.visible = true

func _on_combat_fight_cleanup() -> void:
	self.visible = false
