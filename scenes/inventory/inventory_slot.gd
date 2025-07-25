class_name InventorySlot
extends Panel

const MY_SCENE = preload("res://scenes/inventory/inventory_slot/inventory_slot.tscn")

const MAT_SLOT_DEFAULT = preload("res://scenes/inventory/inventory_slot/slot_default.tres")
const MAT_SLOT_HOVER = preload("res://scenes/inventory/inventory_slot/slot_hover.tres")

enum States {DEFAULT, TAKEN, FREE}

var coordinate: Vector2i
var is_hovering := false
var state := States.DEFAULT
var item_stored: Node = null

static func create_instance(parent: Node, coordinate: Vector2i) -> InventorySlot:
	var inventorySlot := MY_SCENE.instantiate()
	parent.add_child(inventorySlot)
	inventorySlot.coordinate = coordinate
	
	return inventorySlot


func hover() -> void:
	is_hovering = true
	add_theme_stylebox_override('panel', MAT_SLOT_HOVER)


func unhover() -> void:
	is_hovering = false
	add_theme_stylebox_override('panel', MAT_SLOT_DEFAULT)
