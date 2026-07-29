package odin_tutorial_game

import rl "vendor:raylib"

PIXEL_WINDOW_HEIGHT :: 720

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Tutorial Game")
	rl.SetWindowPosition(200, 200)
	rl.SetWindowState({.WINDOW_RESIZABLE})

	player_position := rl.Vector2{640, 320}
	player_width := f32(32)
	player_height := f32(32)
	player_rotation: f32
	player_velocity: rl.Vector2

	player := rl.Rectangle{player_position.x, player_position.y, player_width, player_height}
	player_origin := rl.Vector2{player_width / 2, player_height}
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
		if is_player_grounded && rl.IsKeyPressed(.SPACE) {
			player_velocity.y = -600
			is_player_grounded = false
		}

		player_position += player_velocity * rl.GetFrameTime()

		// Ground check
		ground_level := f32(rl.GetScreenHeight()) - player_height
		if player_position.y > ground_level {
			player_position.y = ground_level
			is_player_grounded = true
		}
		// Sync player position
		player.x = player_position.x
		player.y = player_position.y

		screen_height := f32(rl.GetScreenHeight())

		// Camera
		camera := rl.Camera2D {
			zoom   = screen_height / PIXEL_WINDOW_HEIGHT,
			offset = {f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
			target = player_position,
		}

		rl.BeginMode2D(camera)

		// Player
		rl.DrawRectanglePro(player, player_origin, player_rotation, rl.ORANGE)
		rl.DrawCircleV(rl.Vector2{player.x, player.y}, 5, rl.BLUE)
		rl.EndMode2D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
