package game

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1280,720,"My first game.")

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}