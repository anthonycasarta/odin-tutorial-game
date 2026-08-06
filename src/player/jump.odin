package player

jump_enter :: proc(player: ^Player) {
	player.velocity.y = -300
}

jump_exit :: proc(player: ^Player) {
	player.velocity.y = 0
}

jump_update :: proc(player: ^Player) {}

jump_transition :: proc(player: ^Player) -> Player_State {
	if player.velocity.y >= 0 {
		return Player_State.Idle
	}
	return Player_State.Jump
}
