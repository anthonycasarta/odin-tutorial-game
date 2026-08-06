
package player

grounded_enter :: proc(player: ^Player) {

	player.velocity.y = 0
}
grounded_exit :: proc(player: ^Player) {}
grounded_update :: proc(player: ^Player) {

}
grounded_transition :: proc(player: ^Player) -> Player_State {
	if !player.is_grounded {
		return Player_State.Aerial
	}
	return Player_State.Grounded
}
