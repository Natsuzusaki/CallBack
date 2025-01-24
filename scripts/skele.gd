extends CharacterBody2D

@onready var emitter = %Player
@onready var hp: Label = $HP
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var in_ranged := false
var random := 0

func _ready() -> void:
	print(in_ranged)
	random = randi_range(-100, 100)
	emitter.killzone.connect(_killzone)

func _process(delta: float) -> void:
	hp.text = "var:" + str(random)
	if emitter.global_var == random and in_ranged:
		queue_free()

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()

func _killzone() -> void:
	in_ranged = not in_ranged
