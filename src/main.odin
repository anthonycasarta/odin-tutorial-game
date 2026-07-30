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
	defer {
		level_save("assets/levels/level.json", &game.level)
		level_destroy(&game.level)
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		game_update(&game, rl.GetFrameTime())

		rl.BeginMode2D(game.camera.view)

		player_draw(&game.player)
		level_draw(&game.level)
		level_editor_update(&game.level_editor, &game.level, &game.camera)

		rl.EndMode2D()
		rl.EndDrawing()

		free_all(context.temp_allocator)

	}

}
