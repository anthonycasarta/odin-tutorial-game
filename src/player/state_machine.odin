package player

state_functions := [Player_State]State_Functions {
	.Grounded = {
		parent = nil,
		initial_child = Player_State.Idle,
		enter = grounded_enter,
		exit = grounded_exit,
		update = grounded_update,
		transition = grounded_transition,
	},
	.Aerial = {
		parent = nil,
		initial_child = Player_State.Fall,
		enter = aerial_enter,
		exit = aerial_exit,
		update = aerial_update,
		transition = aerial_transition,
	},
	.Idle = {
		parent = Player_State.Grounded,
		initial_child = nil,
		enter = idle_enter,
		exit = idle_exit,
		update = idle_update,
		transition = idle_transition,
	},
	.Run = {
		parent = Player_State.Grounded,
		initial_child = nil,
		enter = run_enter,
		exit = run_exit,
		update = run_update,
		transition = run_transition,
	},
	.Jump = {
		parent = Player_State.Grounded,
		initial_child = nil,
		enter = jump_enter,
		exit = jump_exit,
		update = jump_update,
		transition = jump_transition,
	},
	.Fall = {
		parent = Player_State.Aerial,
		initial_child = nil,
		enter = fall_enter,
		exit = fall_exit,
		update = fall_update,
		transition = fall_transition,
	},
}

state_stack: [dynamic]Player_State

state_machine_init :: proc() -> [dynamic]Player_State {
	initial_state := Player_State.Idle
	initial_parent_state := state_functions[initial_state].parent

	append(&state_stack, initial_parent_state)
	append(&state_stack, initial_state)

	return state_stack
}

state_machine_update :: proc(player: ^Player) {
	state_stack_length := len(player.state) - 1
	current_state := player.state[state_stack_length]
	current_state_functions := state_functions[current_state]
	current_parent_state := current_state_functions.parent
	current_initial_child_state := current_state_functions.initial_child

	next_state := current_state_functions.transition(player)
	next_parent_state := state_functions[next_state].parent

	if current_state == next_state || current_parent_state != next_parent_state {
		return
	}

	if current_parent_state == nil {
		current_state_functions.exit(player)
		pop(&state_stack)
		current_state_functions = state_functions[player.state[len(player.state) - 1]]
		current_initial_child_state = current_state_functions.initial_child
	}

	current_state_functions.exit(player)
	pop(&state_stack)
	append(&state_stack, next_state)
	current_state_functions = state_functions[player.state[len(player.state) - 1]]
	current_state_functions.enter(player)

	if current_initial_child_state != nil {
		append(&state_stack, current_initial_child_state)
		current_state_functions = state_functions[player.state[len(player.state) - 1]]
		current_state_functions.enter(player)
	}
}
