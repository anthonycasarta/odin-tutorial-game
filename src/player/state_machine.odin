package player


state_machine_init :: proc() -> Player_State {
	initial_state := Player_State.Idle

	return initial_state
}

state_machine_update :: proc(player: ^Player) {
	state_machine_transition(player)
}

state_machine_transition :: proc(player: ^Player) {
}
