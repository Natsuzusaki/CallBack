extends Node2D

@export var console: Area2D
@onready var instance_time: Timer = $InstanceTime
@onready var int_object = preload("res://scenes/int_object.tscn")
@onready var str_object = preload("res://scenes/str_object.tscn")
@onready var bool_object = preload("res://scenes/bool_object.tscn")
@onready var float_object = preload("res://scenes/float_object.tscn")
var type := 0 #0-integer, 1-string, 2-boolean, 3-float

func _ready() -> void:
	console.print_value.connect(_print_value)
func _print_value(value, array_value) -> void:
	if array_value.size() > 1:
		var loops = array_value.size()
		for loop in loops:
			spawn_object(array_value[loop])
			instance_time.start()
			await instance_time.timeout
	else:
		spawn_object(value)

func spawn_object(value) -> void:
	var object_spawn
	if value is String:
		print('s')
		object_spawn = str_object.instantiate()
	elif value is float:
		print('f')
		object_spawn = float_object.instantiate()
		object_spawn.apply_impulse(Vector2(0, 50))
	elif value is int:
		print('i')
		object_spawn = int_object.instantiate()
	elif value is bool:
		print('b')
		object_spawn = bool_object.instantiate()
	else:
		return
	object_spawn.initialize(value)
	get_tree().get_current_scene().find_child("Objects").add_child(object_spawn)
	object_spawn.position = position + Vector2(0, 10)
