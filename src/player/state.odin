package player

Player_State :: enum {
	Idle,
	Run,
	Jump,
	Fall,
	Grounded,
	Aerial,
}

State_Functions :: struct {
	has_parent:        bool,
	has_initial_child: bool,
	parent:            Player_State,
	initial_child:     Player_State,
	enter:             proc(player: ^Player),
	exit:              proc(player: ^Player),
	update:            proc(player: ^Player),
	transition:        proc(player: ^Player) -> Player_State,
}
