package player

run_enter :: proc(player: ^Player) {}
run_exit :: proc(player: ^Player) {}
run_update :: proc(player: ^Player) {}
run_transition :: proc(player: ^Player) -> Player_State {
	return Player_State.Run
}
