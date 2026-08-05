package player

import rl "vendor:raylib"

idle_enter :: proc(player: ^Player) {
	player.velocity.x = 0
}

idle_exit :: proc(player: ^Player) {
	player.velocity.x = 0
}

idle_update :: proc(player: ^Player) {
	// Play animation
}

idle_transition :: proc(player: ^Player) -> Player_State {
	if player.velocity.x > 0 {
		return Player_State.Run
	}
	if rl.IsKeyPressed(.SPACE) {
		return Player_State.Jump
	}
	return Player_State.Idle
}
