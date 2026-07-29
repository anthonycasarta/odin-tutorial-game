package odin_tutorial_game

import rl "vendor:raylib"

Player :: struct {
	position:        rl.Vector2,
	velocity:        rl.Vector2,
	speed:           f32,
	width:           f32,
	height:          f32,
	rotation:        f32,
	rectangle:       rl.Rectangle,
	origin:          rl.Vector2,
	ground_collider: rl.Rectangle,
	is_grounded:     bool,
}

player_init :: proc() -> Player {
	position: rl.Vector2
	speed := f32(100)
	width := f32(8)
	height := f32(8)

	return Player {
		position = position,
		speed = speed,
		width = width,
		height = height,
		rectangle = {position.x, position.y, width, height},
		origin = {width / 2, height},
	}
}

player_draw :: proc(player: ^Player) {
	// Player
	rl.DrawRectanglePro(player.rectangle, player.origin, player.rotation, rl.ORANGE)

	// Player ground collider
	rl.DrawRectangleRec(player.ground_collider, rl.GREEN)

	// Player origin
	rl.DrawCircleV(player.position, player.width / 4, rl.BLUE)

}

player_update :: proc(player: ^Player, level: ^Level, delta_time: f32) {
	// Gravity
	player.velocity.y += 1000 * delta_time

	// Movement
	if rl.IsKeyDown(.A) {
		player.velocity.x = -player.speed
	} else if rl.IsKeyDown(.D) {
		player.velocity.x = player.speed
	} else {
		player.velocity.x = 0
	}

	// Jump
	if player.is_grounded && rl.IsKeyPressed(.SPACE) {
		player.velocity.y = -300
	}

	player.position += player.velocity * delta_time

	// Ground check
	player.ground_collider = rl.Rectangle {
		player.position.x - player.width / 4,
		player.position.y - player.height / 4,
		player.width / 2,
		player.height / 4,
	}

	player.is_grounded = false
	for platform in level.platforms {

		if rl.CheckCollisionRecs(player.ground_collider, platform_collider(platform)) &&
		   player.velocity.y > 0 {
			player.velocity.y = 0
			player.position.y = platform.y
			player.is_grounded = true
		}
	}
	// Sync player position
	player.rectangle = {player.position.x, player.position.y, player.width, player.height}
}
