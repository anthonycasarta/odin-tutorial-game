package odin_tutorial_game

import rl "vendor:raylib"

Game_Camera :: struct {
	view:         rl.Camera2D,
	follow_speed: f32,
	shake:        f32,
}

camera_update :: proc(player: ^Player, camera: ^Game_Camera) {
	screen_width := f32(rl.GetScreenWidth())
	screen_height := f32(rl.GetScreenHeight())
	pixel_window_height := f32(180)

	camera.view.zoom = screen_height / pixel_window_height
	camera.view.offset = {screen_width / 2, screen_height * 0.85}
	camera.view.target.x = player.position.x

}
