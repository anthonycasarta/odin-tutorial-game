package odin_tutorial_game

import rl "vendor:raylib"

level_paths := [?]string{"assets/levels/level_01.json"}


Game :: struct {
	player:              Player,
	level:               Level,
	current_level_index: int,
	camera:              Game_Camera,
	level_editor:        Level_Editor,
}

game_init :: proc() -> Game {
	level: Level
	level_load("assets/levels/level_01.json", &level)
	return Game {
		player = player_init(),
		level = level,
		current_level_index = 0,
		level_editor = Level_Editor{enabled = false},
	}
}

game_destroy :: proc(game: ^Game) {
	level_save(level_paths[game.current_level_index], &game.level)
	level_destroy(&game.level)

}


game_level_change :: proc(game: ^Game, level_index: int) {
	if level_index < 0 || level_index >= len(level_paths) {
		return
	}

	game_destroy(game)

	level_path := level_paths[level_index]
	level_load(level_path, &game.level)
	game.current_level_index = level_index

}

game_draw :: proc(game: ^Game) {
	rl.BeginMode2D(game.camera.view)

	player_draw(&game.player)
	level_draw(&game.level)

	level_editor_update(&game.level_editor, &game.level, &game.camera)

	rl.EndMode2D()
}

game_update :: proc(game: ^Game, delta_time: f32) {
	player_update(&game.player, &game.level, delta_time)
	camera_update(&game.player, &game.camera, &game.level)
}
