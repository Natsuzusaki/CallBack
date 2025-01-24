extends PlayerState

@export var idle_state: PlayerState
@export var run_state: PlayerState
@export var jump_state: PlayerState
var animation_time := 0.0
var default_time := 0.7

func enter() -> void:
	super.enter()
	shout()
	animation_time = default_time
func exit() -> void:
	parent.call_player.current_animation = "RESET"

func process_frame(delta: float) -> PlayerState:
	animation_time -= delta
	if animation_time <= 0:
		return idle_state
	return null
func process_physics(delta: float) -> PlayerState:
	parent.velocity.y += parent.gravity() * delta
	parent.velocity.x = 0
	parent.move_and_slide()
	return null

func shout() -> void:
	parent. call_label.text = "move()"
	parent.call_player.current_animation = "call_text"
	parent.call_player.active = true
	pass
