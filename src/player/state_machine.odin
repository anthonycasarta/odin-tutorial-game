package player

state_functions := [Player_State]State_Functions {
	.Idle = {
		enter = idle_enter,
		exit = idle_exit,
		update = idle_update,
		transition = idle_transition,
	},
	.Run = {enter = run_enter, exit = run_exit, update = run_update, transition = run_transition},
	.Jump = {
		enter = jump_enter,
		exit = jump_exit,
		update = jump_update,
		transition = jump_transition,
	},
}

state_machine_init :: proc() -> Player_State {
	initial_state := Player_State.Idle

	return initial_state
}

state_machine_update :: proc(player: ^Player) {
	current_state := player.state
	current_state_functions := state_functions[current_state]

	next_state := current_state_functions.transition(player)

	if current_state == next_state {
		return
	}

	current_state_functions.exit(player)
	player.state = next_state
}
