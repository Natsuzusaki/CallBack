extends RigidBody2D

@onready var player = null
@onready var emitter: CharacterBody2D = null

@onready var question = null
@onready var Q_emitter: Node2D = null
var in_range := 0 # 0-false, 1-true, 2-queue_freed

func _ready() -> void:
	if not player:
		player = get_tree().get_current_scene().find_child("Player")
	if not question:
		question = get_tree().get_current_scene()
	if player and not emitter:
		emitter = player
	if question and not Q_emitter:
		Q_emitter = question
	if emitter:
		emitter.crate_in_ranged.connect(_in_ranged)
		emitter.on_interact.connect(_on_interact)
	if Q_emitter:
		Q_emitter.in_area.connect(_in_area)

func _on_interact() -> void:
	if emitter.active_crate == self:
		in_range = 2
		queue_free()

func _in_ranged() -> void:
	#if in_range == 1 and emitter.active_crate == self:
		#%CratePrompt.visible = false
		#in_range = 0
	#elif in_range == 0 and emitter.active_crate == self:
		#%CratePrompt.visible = true
		#in_range = 1
	#elif in_range == 2:
		pass

func _in_area() -> void:
	if Q_emitter.active_crate == self:
		queue_free()
