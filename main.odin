package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

import "core:c"

Gravity :: struct { 
x: f32,
y: f32,
}

Position :: struct {
x: f32,
y: f32,
}

Velocity :: struct {
x: f32,
y: f32,
}

Ball :: struct {
radius: f32,
pos: Position,
vel: Velocity,
}

width: f32 = 720.0
height: f32 = 720.0
title: cstring = ""

simMinWidth: f32 = 20.0
cScale: f32 = min(width, height) / simMinWidth
simWidth := width / cScale
simHeight := height / cScale

timeStep: f32 = 1.0 / 60.0

cX :: proc(pos: Position) -> f32 {
return pos.x * cScale;
}

cY :: proc(pos: Position) -> f32 {
return height - pos.y * cScale;
}

simulate :: proc (ball: ^Ball, gravity: Gravity) {

ball.vel.x += gravity.x * timeStep
ball.vel.y += gravity.y * timeStep
ball.pos.x += ball.vel.x * timeStep
ball.pos.y += ball.vel.y * timeStep

if (ball.pos.x < 0.0)
{
ball.pos.x = 0.0
ball.vel.x = -ball.vel.x
}

if (ball.pos.x > simWidth)
{
ball.pos.x = simWidth
ball.vel.x = -ball.vel.x
}

if (ball.pos.y < 0.0) 
{
ball.pos.y = 0.0
ball.vel.y = -ball.vel.y
}

}

main :: proc() {

gravity := Gravity {
0.0,
-10.0,
}

ball := Ball {
0.2,
{0.2, 0.2},
{10.0, 15.0},
}

rl.InitWindow(cast(i32)width, cast(i32)height, title)

rl.SetTargetFPS(60);

// rl.ToggleFullscreen()

for (!rl.WindowShouldClose())
{

rl.ClearBackground(rl.WHITE)

rl.BeginDrawing()

    /*
    
    arc (x, y, r, start, end, anticlockwise)

    CanvasRenderingContext2D.arc (x, y, r, start, end, anticlockwise)

    defines a piece of a circle. 
    The center of this circle is (x,y), the radius is r. 
    The start and end point of the arc are given as angles in radians. 
    The optional boolean anticlockwise parameter defines if the arcs are measured counterclockwise (value true) or clockwise (value false, wich is the default).
    A call of arc() is part of a path declaration, the actual drawing is done with a call of stroke(), drawing a piece of the circle line, or fill(), which draws a section of the circle disk.


    */

    // rl.DrawCircle(ball.pos.x, ball.pos.y, ball.radius, rl.RED)

    simulate(&ball, gravity)

    rl.DrawCircle(cast(i32)cX(ball.pos), cast(i32)cY(ball.pos), cast(f32) cScale * ball.radius, rl.RED)

rl.EndDrawing()

}

rl.CloseWindow()

}