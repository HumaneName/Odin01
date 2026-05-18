package assets

import rl "vendor:raylib"
import "core:fmt"

// Variables
    player_pos: rl.Vector2
    player_vel: rl.Vector2
    player_jumps: f16
    player_maxJumps: f16
    player_grounded: bool
    player_flip: bool
    player_run_texture: rl.Texture2D
    play_run_num_frames: int
    player_run_frame_timer: f32
    player_run_current_frame: int
    player_run_frame_length: f32
    player_gravity: f32
    player_debug: bool

// Sets variables
playerStart :: proc() {
    player_gravity = 2000
    player_pos = rl.Vector2 { 400, 300 }
    player_vel = rl.Vector2 {}
    player_jumps = 0
    player_maxJumps = 2
    player_grounded = false
    player_flip = false
    player_run_texture = rl.LoadTexture("assets/images/cat_run.png")
    play_run_num_frames = 4
    player_run_frame_timer = 0.0
    player_run_current_frame = 0
    player_run_frame_length = 0.1
    player_debug = false

    fmt.println("Player is received.")
}

// Game loop
player :: proc() {
    playerControls()
    playerPhys()
    playerDraw()
    playerDebug()    
}

// Prints player info
playerDebug :: proc() {
    if player_debug {
        text := fmt.ctprint("Pos X: ", f16(player_pos.x))
        text2 := fmt.ctprint("Pos Y: ", f16(player_pos.y))
        rl.DrawText(text, 10, 10, 20, rl.BLACK)
        rl.DrawText(text2, 10, 35, 20, rl.BLACK)
    }
}

playerControls :: proc() {
    if (player_grounded || player_jumps < player_maxJumps) && rl.IsKeyPressed(.SPACE) {
        player_vel.y = -600
        player_grounded = false
        player_jumps += 1
    }

    if rl.IsKeyDown(.A) {
            player_vel.x = -400
            player_flip = true
        } else if rl.IsKeyDown(.D) {
            player_vel.x = 400
            player_flip = false
        } else {
            player_vel.x = 0
    }

    if rl.IsKeyPressed(.R) {
        playerStart()
    }

    if rl.IsKeyPressed(.J) {
        if !player_debug {
            player_debug = true
        } else {
            player_debug = false
        }
    }
}

playerDraw :: proc() {
    player_run_width := f32(player_run_texture.width)
    player_run_height := f32(player_run_texture.height)

    player_run_frame_timer += rl.GetFrameTime()

    if player_run_frame_timer > player_run_frame_length {
        player_run_current_frame += 1
        player_run_frame_timer = 0

        if player_run_current_frame == play_run_num_frames {
            player_run_current_frame = 0
        }
    }

    draw_player_source := rl.Rectangle {
        x = f32(player_run_current_frame) * player_run_width / f32(play_run_num_frames),
        y = 0,
        width = player_run_width / f32(play_run_num_frames),
        height = player_run_height,
    }

    if player_flip {
        draw_player_source.width = -draw_player_source.width
    }

    draw_player_dest := rl.Rectangle {
        x = player_pos.x,
        y = player_pos.y,
        width = player_run_width * 4 / f32(play_run_num_frames),
        height = player_run_height * 4
    }

    rl.DrawTexturePro(player_run_texture, draw_player_source, draw_player_dest, 0, 0, rl.WHITE)
}

playerPhys :: proc() {
    player_vel.y += player_gravity * rl.GetFrameTime()     // gravity
    player_pos += player_vel * rl.GetFrameTime()           // adds both X & Y velocities to player's position.

    if player_pos.y > f32(rl.GetScreenHeight()) - 64 {
        player_pos.y = f32(rl.GetScreenHeight()) - 64 
        player_grounded = true
        player_jumps = 0
    }
}