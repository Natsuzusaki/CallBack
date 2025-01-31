extends Area2D

@onready var object = preload("res://scenes/object.tscn")
@onready var text: Label = $Text
@onready var player: CharacterBody2D = null
var current_obj := 0
var previous_obj := 0

signal in_area()

func _ready() -> void:
	player = get_tree().get_current_scene().find_child("Player")

func _on_body_entered(body: Node2D) -> void:
	if current_obj:
		#print("Instance: prev: " + str(previous_obj) + " curr: " + str(current_obj))
		var object_spawn = object.instantiate()
		object_spawn.initialize(current_obj)
		get_tree().get_current_scene().find_child("Objects").add_child(object_spawn)
		object_spawn.position = position + Vector2(0, -30)
		var throw_force = Vector2(100 * player.static_direction, -100)
		object_spawn.apply_torque(300000 * player.static_direction)
		object_spawn.apply_impulse(throw_force)
	
	body.pass_value.connect(_pass_value)
	emit_signal("in_area", body)

func _on_body_exited(body: Node2D) -> void:
	pass

func _pass_value(value: int) -> void:
	previous_obj = current_obj
	current_obj = value
	if not previous_obj:
		previous_obj = current_obj
	text.text = str(current_obj)
	#print("Passing: prev: " + str(previous_obj) + " curr: " + str(current_obj))
