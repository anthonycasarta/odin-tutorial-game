package player

Player_State :: enum {
	Idle,
	Run,
	Jump,
}

State_Functions :: struct {
	enter:      proc(player: ^Player),
	exit:       proc(player: ^Player),
	update:     proc(player: ^Player),
	transition: proc(player: ^Player) -> Player_State,
}
