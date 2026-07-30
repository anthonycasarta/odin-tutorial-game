package odin_tutorial_game

import rl "vendor:raylib"

Platform :: struct {
	type:     string,
	position: rl.Vector2,
	height:   f32,
	width:    f32,
}
