extends CharacterBody2D
class_name Player

@onready var body_sprite: AnimatedSprite2D = $BodySprite
@onready var off_hand_sprite: AnimatedSprite2D = $OffHandSprite
@onready var hair_sprite: AnimatedSprite2D = $HairSprite
@onready var collision: CollisionShape2D = $CollisionShape
@onready var player_debug: Label = $Player_Debug
@onready var globalvar_label: Label = $global_var
@onready var call_label: Label = $Control/call
@onready var call_player: AnimationPlayer = $Control/call/CallPlayer
@onready var pick_up_collision: CollisionShape2D = $PickUp_Area/PickUp_Collision
@onready var state_machine: Node = $StateMachine

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_velocity: float = ((2.0 * jump_height)/ jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height)/ (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height)/ (jump_time_to_descent * jump_time_to_descent)) * -1.0

var box: PackedScene = load("res://scenes/crate.tscn")
var box2: PackedScene = load("res://scenes/crate2.tscn")
var body_type := 0 #0-null, 1-crate, 2-defect
var active_crate: Node
var global_var := 0

var in_range := false
var wait_carry := 0.0 # wait for box to be queue freed
var carrying := false # true if carrying ofc
var default_coyote_time := 0.08 # changable
var coyote_time := 0.0 # called
var static_direction := 1 #left -1, right 1
var direction := 0 #left -1, center 0 ,right 1

signal killzone()
signal crate_in_ranged()
signal on_interact()

func _ready() -> void:
	state_machine.init(self)

func _process(delta: float) -> void:
	globalvar_label.text = "var:" + str(global_var)

	if carrying:
		pick_up_collision.disabled = true
		on_interact.emit()
	elif not carrying:
		pick_up_collision.disabled = false

	state_machine.process_frame(delta)
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("minus"):
		global_var += 1
	elif Input.is_action_pressed("add"):
		global_var -= 1

	state_machine.process_input(event)

func gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("PickUp"):
		body_type = 1
		active_crate = body
	elif body.is_in_group("Defect"):
		body_type = 2
		active_crate = body
	else:
		body_type = 0
	in_range = true
	crate_in_ranged.emit()
func _on_pick_up_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("PickUp") and active_crate == body:
		crate_in_ranged.emit()
	elif body.is_in_group("Defect") and active_crate == body:
		crate_in_ranged.emit()
	in_range = false
	active_crate = null

func _on_killzone_body_entered(body: Node2D) -> void:
	killzone.emit()
func _on_killzone_body_exited(body: Node2D) -> void:
	killzone.emit()
