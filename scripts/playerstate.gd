extends Node
class_name PlayerState

@export var animation_name: String
@export var move_speed: float

var parent: Player

func enter() -> void:
	parent.body_sprite.play(animation_name)
	parent.hair_sprite.play(animation_name)
	parent.off_hand_sprite.play(animation_name)
func exit() -> void:
	pass

func process_frame(delta: float) -> PlayerState:
	return null
func process_physics(delta: float) -> PlayerState:
	return null
func process_input(event: InputEvent) -> PlayerState:
	return null
