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

	level: Level
	level_load("assets/levels/level.json", &level)
	defer {
		level_save("assets/levels/level.json", &level)
		level_destroy(&level)
	}

	player := player_init()
	camera: Game_Camera
	level_editor := Level_Editor {
		enabled = false,
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		player_update(&player, &level, rl.GetFrameTime())
		camera_update(&player, &camera)

		rl.BeginMode2D(camera.view)

		player_draw(&player)
		level_draw(&level)
		level_editor_update(&level_editor, &level, &camera)

		rl.EndMode2D()
		rl.EndDrawing()

		free_all(context.temp_allocator)

	}

}
