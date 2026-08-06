package player

state_functions := [Player_State]State_Functions {
	.Grounded = {
		has_parent = false,
		has_initial_child = true,
		parent = Player_State.Grounded,
		initial_child = Player_State.Idle,
		enter = grounded_enter,
		exit = grounded_exit,
		update = grounded_update,
		transition = grounded_transition,
	},
	.Aerial = {
		has_parent = false,
		has_initial_child = true,
		parent = Player_State.Aerial,
		initial_child = Player_State.Fall,
		enter = aerial_enter,
		exit = aerial_exit,
		update = aerial_update,
		transition = aerial_transition,
	},
	.Idle = {
		has_parent = true,
		has_initial_child = false,
		parent = Player_State.Grounded,
		initial_child = Player_State.Idle,
		enter = idle_enter,
		exit = idle_exit,
		update = idle_update,
		transition = idle_transition,
	},
	.Run = {
		has_parent = true,
		has_initial_child = false,
		parent = Player_State.Grounded,
		initial_child = Player_State.Run,
		enter = run_enter,
		exit = run_exit,
		update = run_update,
		transition = run_transition,
	},
	.Jump = {
		has_parent = true,
		has_initial_child = false,
		parent = Player_State.Aerial,
		initial_child = Player_State.Jump,
		enter = jump_enter,
		exit = jump_exit,
		update = jump_update,
		transition = jump_transition,
	},
	.Fall = {
		has_parent = true,
		has_initial_child = false,
		parent = Player_State.Aerial,
		initial_child = Player_State.Fall,
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
	current_parent_state_functions := state_functions[current_parent_state]

	current_state_functions.update(player)
	current_parent_state_functions.update(player)


	for state in player.state {
		new_state := state_functions[state].transition(player)
		parent_state := state_functions[state].parent
		new_parent_state := state_functions[new_state].parent

		if state != new_state {
			state_machine_transition(player, state, parent_state, new_state, new_parent_state)
		}
	}


}

state_machine_transition :: proc(
	player: ^Player,
	current_state: Player_State,
	current_parent_state: Player_State,
	next_state: Player_State,
	next_parent_state: Player_State,
) {
	current_state_functions := state_functions[current_state]
	current_initial_child_state := current_state_functions.initial_child


	if current_state_functions.has_parent == false {
		current_state_functions.exit(player)
		pop(&player.state)
		current_state_functions = state_functions[player.state[len(player.state) - 1]]
		// current_initial_child_state = current_state_functions.initial_child
	}

	current_state_functions.exit(player)
	pop(&player.state)
	append(&player.state, next_state)
	current_state_functions = state_functions[player.state[len(player.state) - 1]]
	current_state_functions.enter(player)

	if current_state_functions.has_initial_child != false {
		current_initial_child_state = current_state_functions.initial_child
		append(&player.state, current_initial_child_state)
		current_state_functions = state_functions[player.state[len(player.state) - 1]]
		current_state_functions.enter(player)
	}
}
