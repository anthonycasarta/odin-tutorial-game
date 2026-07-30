package odin_tutorial_game

import "core:encoding/json"
import "core:fmt"
import "core:os"
import rl "vendor:raylib"

Level :: struct {
	platforms: [dynamic]Platform,
	bounds:    rl.Rectangle,
	origin:    rl.Vector2,
}

platform_collider :: proc(platform: Platform) -> rl.Rectangle {
	return {platform.position.x, platform.position.y, platform.width, platform.height}
}


level_draw :: proc(level: ^Level) {
	for platform in level.platforms {

		rl.DrawRectangleRec(platform_collider(platform), rl.RED)
	}
	rl.DrawRectangleLinesEx(level.bounds, f32(1), rl.YELLOW)


}

level_add_platform_at :: proc(level: ^Level, position: rl.Vector2) {
	append(&level.platforms, Platform{position = position, width = 96, height = 16})

}

level_remove_platform_at :: proc(level: ^Level, position: rl.Vector2) {
	for platform, index in level.platforms {
		if rl.CheckCollisionPointRec(position, platform_collider(platform)) {
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
			append(&level.platforms, Platform{position = {-20, 20}})
		}
	} else {
		append(&level.platforms, Platform{position = {-20, 20}})

	}

}

level_destroy :: proc(level: ^Level) {
	delete(level.platforms)

}
