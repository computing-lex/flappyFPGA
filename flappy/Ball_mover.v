`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2021 03:32:27 PM
// Design Name: 
// Module Name: Ball_bouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// STATUS: 
//      [0]: ground collision
//      [1]: wall collision
// 
//////////////////////////////////////////////////////////////////////////////////


// Module for controlling the movement of the ball
module Ball_mover(
    input clk,                  // Clock input
    input [4:0] BTNS,           // Button inputs
    input [9:0] h_counter,      // Horizontal counter
    input [9:0] v_counter,      // Vertical counter
    input [9:0] wallX,          // Wall horizontal position
    input [9:0] wallYL,         // Wall lower bound
    input [9:0] wallYU,         // Wall upper bound
    output reg [9:0] ballX = 450,  // Initial X position of the ball
    output reg [9:0] ballY = 400,  // Initial Y position of the ball
    output reg [15:0] status
);
    // Speed at which the player falls
    reg [15:0] verticalSpeed = 0;
    reg [9:0] oldBallX;
    reg [9:0] oldWallX;
    
    // Timer settings
    reg [3:0] timeMult = 7;
    reg [31:0] currentTime = 0;
    
    // Jump settings
    reg [3:0] jumpHeight = 5;
    reg [3:0] gravity = 1;
    
    // How long the player increases height
    reg [3:0] jumpTimer = 0;
    reg [3:0] jumpLength = 2;
    
    reg [9:0] groundHeight = 450;
    
    
    // Logic for moving the ball
    always @(posedge clk) begin
        if (h_counter == 0 && v_counter == 0) begin
            // Ball moving
            if (BTNS[0] == 0) begin
            
                // Ground collision
                if (ballY + 20 >= groundHeight) begin
                    ballY <= groundHeight - 20;
                    verticalSpeed <= 0;
                    status[0] <= 1;
                    
                // Sky collision
//                end else if (ballY < 10) begin
//                    verticalSpeed <= 0;
                    
                // Wall collision
                end else if (
                       ballX + 20 > wallX 
                    && ballX < wallX + 40 
                    && ballY + 20 > wallYL ) begin
                    
                    status[1] <= 1;
                    verticalSpeed <= 0;
                // Top wall collision
                end else if (
                       ballX + 20 > wallX 
                    && ballX < wallX + 40
                    && ballY < 185 ) begin
                    
                    status[1] <= 1;
                    verticalSpeed <= 0;
                    
                // Update position every nth frame
                end else if (currentTime == 0 && status[1] == 0) begin
                    
                    // If jumping
                    if (jumpTimer < jumpLength) begin
                        verticalSpeed <= verticalSpeed - jumpHeight;
                        jumpTimer <= jumpTimer + 1;
                    // Otherwise fall
                    end else verticalSpeed <= verticalSpeed + gravity;
                    
                    // Always update position
                    ballY <= ballY + verticalSpeed;
                end
                
                if (BTNS[1] == 1) begin
                    jumpTimer <= 0;
                end
            // Position reset
            end else begin
                ballY <= 200;
                verticalSpeed <= 0;
                status <= 0;
            end
            
            if (ballX == wallX && oldBallX < oldWallX) begin
                status[15:8] <= status[15:8] + 1;
            end
            
            oldBallX <= ballX;
            oldWallX <= wallX;
            
            // Increment time
            if (currentTime < timeMult) begin
                currentTime <= currentTime + 1;
            end else currentTime <= 0;
        end    
    end
endmodule

module wallMover (
    input [9:0] h_counter,
    input [9:0] v_counter,
    input isUpper,
    input clk,
    input vidon,
    input rst,
    input [15:0] status,
    output reg [9:0] wallX,     // Defines position of wall on screen
    output reg [9:0] wallY,     // Height of wall
    output reg [9:0] wallBaseX, // Adds to wallX
    output reg [9:0] wallBaseY  // Snap pipe to floor/ceiling
    );
    
    reg [7:0] counter;
    reg [15:0] oldStatus;
    
    reg [15:0] currentTime;
    reg [15:0] timeMult = 7;
    reg [3:0] horizontalSpeed = 5;
    
    reg [9:0] wallMinY = 370;
    
    initial begin
        wallBaseX = 40;     // Walls are always 40 px wide
        wallX = 800;        // Begin offscreen
        
        wallBaseY = 550;    // Snap to bottom
        wallY = 370;        // Starting position of bottom wall
        
        if (isUpper != 0) begin
            wallBaseY <= 0;     // Snap to top
            wallY <= 200;       // Lowest point of wall
            wallMinY <= 200;    // Minimum height of wall
        end
    end
    
    always @(posedge clk) begin
        if (rst == 1) begin
            wallBaseX = 40;     // Walls are always 40 px wide
            wallX = 800;        // Begin offscreen
        
            wallBaseY = 550;    // Snap to bottom
            wallY = 370;        // Starting position of bottom wall
        
            horizontalSpeed <= 5;
        end
        
        if (status[1:0] == 0) begin
            // Only update at the beginning of a frame
            if (h_counter == 0 && v_counter == 0) begin
                // Update wall position
                if (currentTime == 0) begin
                    // Always update position
                    wallX <= wallX - horizontalSpeed;
                end
                
                // Reset position and generate new height
                if (wallX < 20) begin 
                    wallX <= 800;
                    wallY <= wallMinY + (counter[1:0] * 15);
                end
                
                // Update speed
                if (currentTime < timeMult) begin
                        currentTime <= currentTime + 1;
                end else currentTime <= 0;
            end
        end
        
        // Speed up depending on score
        if (status[10] == 1 && oldStatus[10] == 0) horizontalSpeed <= horizontalSpeed + 5;        
        oldStatus <= status;
        
        counter <= counter + 1;
        if (counter == 7) counter <= 0;
        
    end
endmodule
