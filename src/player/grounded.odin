
package player

grounded_enter :: proc(player: ^Player) {}
grounded_exit :: proc(player: ^Player) {}
grounded_update :: proc(player: ^Player) {}
grounded_transition :: proc(player: ^Player) -> Player_State {
	return Player_State.Grounded
}
