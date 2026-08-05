package player

jump_enter :: proc(player: ^Player) {}
jump_exit :: proc(player: ^Player) {}
jump_update :: proc(player: ^Player) {}
jump_transition :: proc(player: ^Player) -> Player_State {
	return Player_State.Jump
}
