package odin_tutorial_game

import rl "vendor:raylib"

Level_Editor :: struct {
	enabled: bool,
}

level_editor_update :: proc(level_editor: ^Level_Editor, level: ^Level, camera: ^Game_Camera) {
	if rl.IsKeyPressed(.F2) {
		level_editor.enabled = !level_editor.enabled
	}

	if level_editor.enabled {
		mouse_position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera.view)

		rl.DrawRectangleV(mouse_position, {96, 16}, rl.WHITE)

		if rl.IsMouseButtonPressed(.LEFT) {
			level_add_platform_at(level, mouse_position)
		}
		if rl.IsMouseButtonPressed(.RIGHT) {
			level_remove_platform_at(level, mouse_position)
		}
	}

}
