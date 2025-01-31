extends RigidBody2D

@onready var text_value: Label = $TextValue
@onready var Scollision: CollisionShape2D = $SCollision
@onready var Dcollision: CollisionShape2D = $DCollision
@onready var player: CharacterBody2D = null
@onready var slot: Area2D = null
var value := 0
var is_carried := false

signal pass_value()

func _ready() -> void:
	value = randi_range(1,15) if not value else value
	if value < 10:
		Scollision.disabled = false
		Dcollision.disabled = true
	elif value > 9:
		Scollision.disabled = true
		Dcollision.disabled = false
	if not player or not slot:
		slot = get_tree().get_current_scene().find_child("PickUp_Slot")
		player = get_tree().get_current_scene().find_child("Player")
	if player:
		player.on_interact.connect(_on_interact)
	if slot:
		slot.in_area.connect(_in_area)
	text_value.text = str(value)

func _on_interact() -> void:
	if player.current_object == self:
		is_carried = player.is_carrying
		if is_carried:
			freeze = true
		if not is_carried:
			freeze = false
			apply_torque(200000 * player.static_direction)
			apply_impulse(Vector2(5000 * player.static_direction, -2000))

func _in_area(body: Node2D) -> void:
	if body == self:
		await emit_signal("pass_value", value)
		queue_free()

func _process(delta: float) -> void:
	#print(global_position) #WHATT?!?!?!?!?
	if is_carried:
		global_position += Vector2.ZERO
		global_position = player.global_position + Vector2(0, -15)

func initialize(new_value: int) -> void:
	value = new_value
