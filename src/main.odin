#+feature dynamic-literals
package odin_tutorial_game

import "core:encoding/json"
import "core:os"
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
	memory_allocator()

	rl.InitWindow(1280, 720, "Odin Tutorial Game")
	defer rl.CloseWindow()

	rl.SetWindowPosition(200, 200)
	rl.SetWindowState({.WINDOW_RESIZABLE})

	rl.SetTargetFPS(500)

	player := player_init()

	level: Level

	if level_data, err := os.read_entire_file("assets/levels/level.json", context.temp_allocator);
	   err == nil {
		if json.unmarshal(level_data, &level) != nil {
			append(&level.platforms, rl.Vector2{-20, 20})
		}
	} else {
		append(&level.platforms, rl.Vector2{-20, 20})

	}

	defer {
		if level_data, error := json.marshal(level, allocator = context.temp_allocator);
		   error == nil {
			_ = os.write_entire_file("assets/levels/level.json", level_data)
		}
		free_all(context.temp_allocator)
		delete(level.platforms)
	}
	is_in_editing_mode := false
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		player_update(&player, &level, rl.GetFrameTime())

		screen_height := f32(rl.GetScreenHeight())

		// Camera
		camera := rl.Camera2D {
			zoom   = screen_height / PIXEL_WINDOW_HEIGHT,
			offset = {f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
			target = player.position,
		}

		rl.BeginMode2D(camera)

		player_draw(&player)
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

		free_all(context.temp_allocator)

	}

}
