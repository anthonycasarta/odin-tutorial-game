package player

aerial_enter :: proc(player: ^Player) {}
aerial_exit :: proc(player: ^Player) {}
aerial_update :: proc(player: ^Player) {}
aerial_transition :: proc(player: ^Player) -> Player_State {
	return Player_State.Aerial
}
