#+feature dynamic-literals
package odin_tutorial_game

import rl "vendor:raylib"


main :: proc() {
	memory_allocator()

	rl.InitWindow(1280, 720, "Odin Tutorial Game")
	defer rl.CloseWindow()
	rl.SetWindowPosition(200, 200)
	rl.SetWindowState({.WINDOW_RESIZABLE})
	rl.SetTargetFPS(500)

	game := game_init()
	defer game_destroy(&game)

	for !rl.WindowShouldClose() && !game.player.is_dead {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLUE)
		game_update(&game, rl.GetFrameTime())
		game_draw(&game)

		rl.EndDrawing()
		free_all(context.temp_allocator)

	}

}
