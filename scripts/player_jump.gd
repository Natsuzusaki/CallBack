extends PlayerState

@export var idle_state: PlayerState
@export var run_state: PlayerState
@export var call_state: PlayerState

func enter() -> void:
	super.enter()
	parent.collision.position.y = -4

func exit() -> void:
	super.exit()
	parent.collision.position.y = 0

func process_input(event: InputEvent) -> PlayerState:
	if Input.is_action_pressed("call"):
		return call_state
	if Input.is_action_pressed("action") and (not parent.carrying and parent.in_range):
		parent.carrying = not parent.carrying
	elif Input.is_action_pressed("action") and parent.carrying:
		parent.carrying = not parent.carrying
		#Hardest shit ever mygod (code below - text warning)
		#Spawning new crates after they got snapped to oblivion
		var crate_spawn
		if parent.body_type == 1:
			crate_spawn = parent.box.instantiate()
		elif parent.body_type == 2:
			crate_spawn = parent.box2.instantiate()
		get_tree().get_current_scene().find_child("Crates").add_child(crate_spawn)
		var direction = 1 if parent.static_direction == 1 else -1
		crate_spawn.position = parent.position + Vector2(0, -15)
		#Adding force; Throwing the shit
		var throw_force = Vector2(300 * direction, -200)
		crate_spawn.apply_torque(100000 * direction)
		crate_spawn.apply_impulse(throw_force)
		#Assigning new crates to player
		crate_spawn.player = parent  
		crate_spawn.emitter = parent
	return null

func process_physics(delta: float) -> PlayerState:
	if not parent.is_on_floor():
		parent.velocity.y += parent.gravity() * delta

	parent.direction = Input.get_axis("left", "right")
	parent.velocity.x = parent.direction * move_speed
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> PlayerState:
	if parent.is_on_floor():
		if Input.get_axis("left", "right"):
			return run_state
		else:
			return idle_state

	if parent.carrying:
		parent.body_sprite.play("carry")
		parent.hair_sprite.play("carry")
		parent.off_hand_sprite.play("carry")
		parent.player_debug.text = "JumpCarry"
	else:
		enter()
		parent.player_debug.text = "Jumping"

	if parent.direction > 0:
		parent.static_direction = 1
		parent.body_sprite.flip_h = false
		parent.hair_sprite.flip_h = false
		parent.off_hand_sprite.flip_h = false
	elif parent.direction < 0:
		parent.static_direction = -1
		parent.body_sprite.flip_h = true
		parent.hair_sprite.flip_h = true
		parent.off_hand_sprite.flip_h = true
	return null
