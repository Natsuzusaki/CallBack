extends Node2D

@onready var gate: Label = $Function/Gate
@onready var make_scene_collision_1: CollisionShape2D = $MakeThisAScene/MakeSceneCollision1
@onready var gate_2: StaticBody2D = $Gate2
@onready var function: Area2D = $Function/MakeThisAScene
@onready var player: Player = %Player

var box: PackedScene = load("res://scenes/crate.tscn")
var box2: PackedScene = load("res://scenes/crate2.tscn")
var active_crate: Node
var current_crate := 0
var previous_crate := 0 #0-null, 1-crate, 2-defect
var move := false
var calling := false
var animation_time := 0.0
var default_time := 2.2

signal in_area()

func _on_make_this_a_scene_body_entered(body: Node2D) -> void:
	current_crate = 1
	if body.is_in_group("PickUp") and active_crate:
		active_crate = body
		var crate_spawn
		if previous_crate == 1:
			crate_spawn = box.instantiate()
			previous_crate = 1
		elif previous_crate == 2:
			crate_spawn = box2.instantiate()
		get_tree().get_current_scene().find_child("Crates").add_child(crate_spawn)
		var throw_force = Vector2(100 * player.static_direction, -100)
		crate_spawn.position = Vector2(504, 110)
		crate_spawn.apply_torque(100000)
		crate_spawn.apply_impulse(throw_force)
		in_area.emit()
		gate.text = "gate.position.y = 60"
		previous_crate = current_crate
		
	elif body.is_in_group("PickUp"):
		current_crate = 1
		previous_crate = 1
		gate.text = "gate.position.y = 60"
		active_crate = body
		in_area.emit()
		move = true
	
	if body.is_in_group("Defect") and active_crate:
		current_crate = 2
		active_crate = body
		var crate_spawn
		if previous_crate == 1:
			crate_spawn = box.instantiate()
		elif previous_crate == 2:
			crate_spawn = box2.instantiate()
		get_tree().get_current_scene().find_child("Crates").add_child(crate_spawn)
		var throw_force = Vector2(100 * player.static_direction, -100)
		crate_spawn.position = Vector2(504, 110)
		crate_spawn.apply_torque(100000)
		crate_spawn.apply_impulse(throw_force)
		in_area.emit()
		gate.text = "gate.position.y = 5"
		previous_crate = current_crate
		
	elif body.is_in_group("Defect"):
		current_crate = 2
		previous_crate = 2
		gate.text = "gate.position.y = 5"
		active_crate = body
		in_area.emit()
		move = true

func _process(delta: float) -> void:
	var limit := 0
	if move and calling:
		animation_time -= delta
		if current_crate == 1:
			limit = -66
			if gate_2.position.y > limit:
				gate_2.position.y -= 1
			elif gate_2.position.y < limit:
				gate_2.position.y += 1
			elif gate_2.position.y == limit:
				pass
		elif current_crate == 2:
			limit = 55
			if gate_2.position.y > limit:
				gate_2.position.y -= 1
			elif gate_2.position.y < limit:
				gate_2.position.y += 1
			elif gate_2.position.y == limit:
				pass
	elif calling:
		animation_time -= delta
	if animation_time <= 0:
		calling = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("call"):
		animation_time = default_time
		calling = true
