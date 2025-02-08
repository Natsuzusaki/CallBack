extends Node2D

@export var console_connect: Node2D
@onready var object = preload("res://scenes/object.tscn")

func _ready() -> void:
	console_connect.print_value.connect(_print_value)

func _print_value(value) -> void:
	var object_spawn = object.instantiate()
	object_spawn.initialize(value)
	get_tree().get_current_scene().find_child("Objects").add_child(object_spawn)
	object_spawn.position = position + Vector2(0, 10)
