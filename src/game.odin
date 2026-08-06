package odin_tutorial_game

import lvl "level"
import p "player"
import rl "vendor:raylib"

level_paths := [?]string{"assets/levels/level_01.json"}


Game :: struct {
	player:              p.Player,
	level:               lvl.Level,
	current_level_index: int,
	camera:              Game_Camera,
	level_editor:        Level_Editor,
}

player_state_text :: proc(state: p.Player_State) -> cstring {
	switch state {
	case .Grounded:
		return "Grounded"
	case .Aerial:
		return "Aerial"
	case .Idle:
		return "Idle"
	case .Run:
		return "Run"
	case .Jump:
		return "Jump"
	case .Fall:
		return "Fall"
	case:
		return "Unknown"
	}
}

game_init :: proc() -> Game {
	level: lvl.Level
	lvl.level_load("assets/levels/level_01.json", &level)
	return Game {
		player = p.player_init(),
		level = level,
		current_level_index = 0,
		level_editor = Level_Editor{enabled = false},
	}
}

game_destroy :: proc(game: ^Game) {
	lvl.level_save(level_paths[game.current_level_index], &game.level)
	lvl.level_destroy(&game.level)

}


game_level_change :: proc(game: ^Game, level_index: int) {
	if level_index < 0 || level_index >= len(level_paths) {
		return
	}

	game_destroy(game)

	level_path := level_paths[level_index]
	lvl.level_load(level_path, &game.level)
	game.current_level_index = level_index

}

game_draw :: proc(game: ^Game) {
	rl.BeginMode2D(game.camera.view)

	p.player_draw(&game.player)
	lvl.level_draw(&game.level)

	level_editor_update(&game.level_editor, &game.level, &game.camera)

	state_stack_length := len(game.player.state) - 1
	player_state := game.player.state[state_stack_length]
	state_text := player_state_text(player_state)
	font_size := i32(20)
	text_width := rl.MeasureText(state_text, font_size)


	rl.EndMode2D()

	rl.DrawText(state_text, (rl.GetScreenWidth() - text_width) / 2, 10, font_size, rl.YELLOW)

}

game_update :: proc(game: ^Game, delta_time: f32) {
	p.player_update(&game.player, &game.level, delta_time)
	camera_update(&game.player, &game.camera, &game.level)
}
