package odin_tutorial_game

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Tutorial Game")

	player_position := rl.Vector2{640, 320}
	player_velocity: rl.Vector2

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
		if rl.IsKeyDown(.SPACE) {
			player_velocity.y = -600
		}

		player_position += player_velocity * rl.GetFrameTime()

		ground_level := f32(rl.GetScreenHeight()) - 64
		if player_position.y > ground_level {
			player_position.y = ground_level
		}

		// Player
		rl.DrawRectangleV(player_position, {64, 64}, rl.ORANGE)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
