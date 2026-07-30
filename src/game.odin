package odin_tutorial_game

Game :: struct {
	player:       Player,
	level:        Level,
	camera:       Game_Camera,
	level_editor: Level_Editor,
}

game_init :: proc() -> Game {
	level: Level
	level_load("assets/levels/level.json", &level)

	return Game {
		player = player_init(),
		level = level,
		level_editor = Level_Editor{enabled = false},
	}

}

game_update :: proc(game: ^Game, delta_time: f32) {
	player_update(&game.player, &game.level, delta_time)
	camera_update(&game.player, &game.camera)

}
