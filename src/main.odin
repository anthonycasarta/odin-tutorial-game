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

	player := player_init()
	camera: Game_Camera

	level: Level
	level_load("assets/levels/level.json", &level)
	defer {
		level_save("assets/levels/level.json", &level)
		level_destroy(&level)
	}


	is_in_editing_mode := false
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		player_update(&player, &level, rl.GetFrameTime())
		camera_update(&player, &camera)

		rl.BeginMode2D(camera.view)

		player_draw(&player)
		level_draw(&level)

		if rl.IsKeyPressed(.F2) {
			is_in_editing_mode = !is_in_editing_mode
		}

		if is_in_editing_mode {
			mouse_position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera.view)

			rl.DrawRectangleV(mouse_position, {96, 16}, rl.WHITE)

			if rl.IsMouseButtonPressed(.LEFT) {
				level_add_platform_at(&level, mouse_position)
			}
			if rl.IsMouseButtonPressed(.RIGHT) {
				level_remove_platform_at(&level, mouse_position)
			}
		}
		rl.EndMode2D()
		rl.EndDrawing()

		free_all(context.temp_allocator)

	}

}
