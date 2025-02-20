extends Camera2D

@onready var player: CharacterBody2D = null
@onready var console: Area2D = null
@export var zoom_out: float
@export var zoom_in: float
var interact := false
var zoom_speed := 1

func _ready() -> void:
	zoom = Vector2(2, 2)
	if not player:
		player = get_tree().get_current_scene().find_child("Player")

func _process(delta: float) -> void:
	if not interact:
		if zoom >= Vector2(zoom_out, zoom_out):
			zoom = lerp(zoom, zoom * Vector2(-1, -1), zoom_speed * delta)
		global_position = player.global_position
	else:
		if zoom <= Vector2(zoom_in, zoom_in):
			zoom = lerp(zoom, zoom * Vector2(2.5, 2.5), zoom_speed * delta)

func stay() -> void:
	global_position = console.global_position
func back() -> void:
	interact = false
	console = null
