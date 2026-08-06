package player

import rl "vendor:raylib"

run_enter :: proc(player: ^Player) {
	player.velocity.y = 0
}
run_exit :: proc(player: ^Player) {}
run_update :: proc(player: ^Player) {}
run_transition :: proc(player: ^Player) -> Player_State {
	if player.velocity.x <= 0.01 {
		return Player_State.Idle
	}
	if rl.IsKeyPressed(.SPACE) {
		return Player_State.Jump
	}
	return Player_State.Run
}
