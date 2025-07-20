class_name State
extends RefCounted

var actor: Node

func _init(new_actor: Node) -> void:
	actor = new_actor

func tick() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass
