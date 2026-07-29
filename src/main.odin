#+feature dynamic-literals
package odin_tutorial_game

import rl "vendor:raylib"

PIXEL_WINDOW_HEIGHT :: 180
PLAYER_SPEED :: 100

Level :: struct {
	platforms: [dynamic]rl.Vector2,
}

platform_collider :: proc(position: rl.Vector2) -> rl.Rectangle {
	return {position.x, position.y, 96, 16}
}

main :: proc() {
	rl.InitWindow(1280, 720, "Odin Tutorial Game")
	rl.SetWindowPosition(200, 200)
	rl.SetWindowState({.WINDOW_RESIZABLE})

	rl.SetTargetFPS(500)

	player_position: rl.Vector2
	player_width := f32(8)
	player_height := f32(8)
	player_rotation: f32
	player_velocity: rl.Vector2

	player := rl.Rectangle{player_position.x, player_position.y, player_width, player_height}
	player_origin := rl.Vector2{player_width / 2, player_height}
	is_player_grounded: bool

	level := Level {
		platforms = {{-20, 20}, {90, -10}, {90, -50}},
	}

	is_in_editing_mode := false
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		// Gravity
		player_velocity.y += 1000 * rl.GetFrameTime()

		// Movement
		if rl.IsKeyDown(.A) {
			player_velocity.x = -PLAYER_SPEED
		} else if rl.IsKeyDown(.D) {
			player_velocity.x = PLAYER_SPEED
		} else {
			player_velocity.x = 0
		}

		// Jump
		if is_player_grounded && rl.IsKeyPressed(.SPACE) {
			player_velocity.y = -300
		}

		player_position += player_velocity * rl.GetFrameTime()

		// Ground check
		player_ground_collider := rl.Rectangle {
			player_position.x - player_width / 4,
			player_position.y - player_height / 4,
			player_width / 2,
			player_height / 4,
		}

		is_player_grounded = false
		for platform in level.platforms {

			if rl.CheckCollisionRecs(player_ground_collider, platform_collider(platform)) &&
			   player_velocity.y > 0 {
				player_velocity.y = 0
				player_position.y = platform.y
				is_player_grounded = true
			}
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

		// Player ground collider
		rl.DrawRectangleRec(player_ground_collider, rl.GREEN)

		// Player origin
		rl.DrawCircleV(rl.Vector2{player.x, player.y}, player_width / 4, rl.BLUE)

		// Platform
		for platform in level.platforms {

			rl.DrawRectangleRec(platform_collider(platform), rl.RED)
		}

		if rl.IsKeyPressed(.F2) {
			is_in_editing_mode = !is_in_editing_mode
		}

		if is_in_editing_mode {
			mouse_position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)

			rl.DrawRectangleV(mouse_position, {96, 16}, rl.WHITE)

			if rl.IsMouseButtonPressed(.LEFT) {
				append(&level.platforms, mouse_position)
			}
			if rl.IsMouseButtonPressed(.RIGHT) {
				for position, index in level.platforms {
					if rl.CheckCollisionPointRec(mouse_position, platform_collider(position)) {
						unordered_remove(&level.platforms, index)
						break
					}
				}
			}
		}
		rl.EndMode2D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
