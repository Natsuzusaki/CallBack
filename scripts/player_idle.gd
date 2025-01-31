extends PlayerState

@export var run_state: PlayerState
@export var jump_state: PlayerState

func enter() -> void:
	super.enter()
	parent.debug.text = "idle"

func process_input(event: InputEvent) -> PlayerState:
	if Input.is_action_pressed("carry") and not parent.stay:
		parent.carry()
	if Input.get_axis("left", "right") and not parent.stay:
		return run_state
	if Input.is_action_pressed("jump") and parent.is_on_floor() and not parent.stay:
		parent.jump_variable_timer.start()
		parent.jump()
		return jump_state
	return null

func process_physics(delta: float) -> PlayerState:
	if not parent.is_on_floor():
		parent.velocity.y += parent.gravity() * delta
		parent.velocity.x = 0
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> PlayerState:
	if parent.jump_buffered and parent.is_on_floor():
		parent.jump_variable_timer.start()
		parent.jump()
	return null
