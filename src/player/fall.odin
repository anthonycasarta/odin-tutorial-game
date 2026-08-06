package player

fall_enter :: proc(player: ^Player) {}
fall_exit :: proc(player: ^Player) {}
fall_update :: proc(player: ^Player) {}
fall_transition :: proc(player: ^Player) -> Player_State {
	return Player_State.Fall
}
