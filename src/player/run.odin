package player

run_enter :: proc(player: ^Player) {}
run_exit :: proc(player: ^Player) {}
run_update :: proc(player: ^Player) {}
run_transition :: proc(player: ^Player) -> Player_State {
	if player.velocity.x <= 0.01 {
		return Player_State.Idle
	}
	if player.velocity.y > 0 {
		return Player_State.Run
	}
	return Player_State.Run
}
