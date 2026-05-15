package game

import rl "vendor:raylib"
import "core:fmt"
import "assets"

main :: proc() {
    rl.InitWindow(1280,720,"My first game.")
    assets.playerStart()

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground({110,184,168,255})

        assets.player()

        rl.EndDrawing()
    }

    rl.CloseWindow()
}