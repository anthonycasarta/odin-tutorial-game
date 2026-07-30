package odin_tutorial_game

import "core:math"
import rl "vendor:raylib"

grid_size := f32(8)

Level_Editor :: struct {
	enabled: bool,
}

get_snapped_position :: proc(world_coordinate: rl.Vector2) -> rl.Vector2 {
	return {
		math.floor(world_coordinate.x / grid_size) * grid_size,
		math.floor(world_coordinate.y / grid_size) * grid_size,
	}
}

level_editor_update :: proc(level_editor: ^Level_Editor, level: ^Level, camera: ^Game_Camera) {
	if rl.IsKeyPressed(.F2) {
		level_editor.enabled = !level_editor.enabled
	}

	if level_editor.enabled {
		mouse_position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera.view)
		snapped_position := get_snapped_position(mouse_position)

		rl.DrawRectangleV(snapped_position, {96, 16}, rl.WHITE)

		if rl.IsMouseButtonPressed(.LEFT) {
			level_add_platform_at(level, snapped_position)
		}
		if rl.IsMouseButtonPressed(.RIGHT) {
			level_remove_platform_at(level, snapped_position)
		}
	}

}
