package odin_tutorial_game

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Tutorial Game")

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
