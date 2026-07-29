package odin_tutorial_game

import "core:encoding/json"
import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Level :: struct {
	platforms: [dynamic]rl.Vector2,
}

platform_collider :: proc(position: rl.Vector2) -> rl.Rectangle {
	return {position.x, position.y, 96, 16}
}


level_draw :: proc(level: ^Level) {
	for platform in level.platforms {

		rl.DrawRectangleRec(platform_collider(platform), rl.RED)
	}

}

level_add_platform_at :: proc(level: ^Level, position: rl.Vector2) {
	append(&level.platforms, position)

}

level_remove_platform_at :: proc(level: ^Level, position: rl.Vector2) {
	for platform_position, index in level.platforms {
		if rl.CheckCollisionPointRec(position, platform_collider(platform_position)) {
			unordered_remove(&level.platforms, index)
			break
		}
	}

}

level_save :: proc(file_path: string, level: ^Level) {

	if level_data, error := json.marshal(level^, allocator = context.temp_allocator);
	   error == nil {
		if error := os.write_entire_file(file_path, level_data); error != nil {
			fmt.eprintf("Failed to save level to %s: %v\n", file_path, error)

		}
	}
	free_all(context.temp_allocator)


}

level_load :: proc(file_path: string, level: ^Level) {
	if level_data, err := os.read_entire_file(file_path, context.temp_allocator); err == nil {
		if json.unmarshal(level_data, level) != nil {
			append(&level.platforms, rl.Vector2{-20, 20})
		}
	} else {
		append(&level.platforms, rl.Vector2{-20, 20})

	}

}

level_destroy :: proc(level: ^Level) {
	delete(level.platforms)

}
