extends PlayerState

@export var idle_state: PlayerState
@export var run_state: PlayerState
@export var jump_state: PlayerState

func enter() -> void:
	super.enter()
	parent.collision.position.y = -4
	parent.debug.text = "fall"

func exit() -> void:
	parent.collision.position.y = 0

func process_input(event: InputEvent) -> PlayerState:
	if Input.is_action_pressed("carry"):
		parent.carry()
	if Input.is_action_pressed("jump"):
		if not parent.is_on_floor():
			if not parent.jump_buffered:
				parent.jump_buffered = true
				parent.jump_buffer_timer.start()
	return null

func process_physics(delta: float) -> PlayerState:
	if not parent.is_on_floor():
		parent.velocity.y += parent.gravity() * delta
	parent.move(delta, move_speed)
	return null

func process_frame(delta: float) -> PlayerState:
	if parent.is_on_floor():
		if Input.get_axis("left", "right"):
			return run_state
		return idle_state
	return null
