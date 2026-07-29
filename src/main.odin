package odin_tutorial_game

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Tutorial Game")

	player_position := rl.Vector2{640, 320}
	player_velocity: rl.Vector2
	is_player_grounded: bool

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		// Gravity
		player_velocity.y += 2000 * rl.GetFrameTime()

		// Movement
		if rl.IsKeyDown(.A) {
			player_velocity.x = -400
		} else if rl.IsKeyDown(.D) {
			player_velocity.x = 400
		} else {
			player_velocity.x = 0
		}

		// Jump
		if is_player_grounded && rl.IsKeyDown(.SPACE) {
			player_velocity.y = -600
			is_player_grounded = false
		}

		player_position += player_velocity * rl.GetFrameTime()

		ground_level := f32(rl.GetScreenHeight()) - 64
		if player_position.y > ground_level {
			player_position.y = ground_level
			is_player_grounded = true
		}


		// Camera
		camera := rl.Camera2D {
			zoom   = 1,
			offset = {f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
			target = player_position,
		}

		rl.BeginMode2D(camera)

		// Player
		rl.DrawRectangleV(player_position, {64, 64}, rl.ORANGE)

		rl.EndMode2D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
