package player

aerial_enter :: proc(player: ^Player) {}
aerial_exit :: proc(player: ^Player) {}
aerial_update :: proc(player: ^Player) {

}
aerial_transition :: proc(player: ^Player) -> Player_State {
	if player.is_grounded {
		return Player_State.Grounded
	}
	return Player_State.Aerial
}
