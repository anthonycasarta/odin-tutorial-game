package odin_tutorial_game

import lvl "level"
import p "player"
import rl "vendor:raylib"

Game_Camera :: struct {
	view:         rl.Camera2D,
	follow_speed: f32,
	shake:        f32,
}

camera_update :: proc(player: ^p.Player, camera: ^Game_Camera, level: ^lvl.Level) {
	screen_width := f32(rl.GetScreenWidth())
	screen_height := f32(rl.GetScreenHeight())
	pixel_window_height := f32(180)

	camera.view.zoom = screen_height / pixel_window_height
	camera.view.offset = {screen_width / 2, screen_height * 0.85}

	visible_distance_left := camera.view.offset.x / camera.view.zoom
	visible_distance_right := (screen_width - camera.view.offset.x) / camera.view.zoom
	camera.view.target.x = clamp(
		player.position.x,
		level.bounds.x + visible_distance_left,
		(level.bounds.x + level.bounds.width) - visible_distance_right,
	)
}
