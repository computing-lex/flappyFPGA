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
// 
//////////////////////////////////////////////////////////////////////////////////


// Module for controlling the movement of the ball
module Ball_mover(
    input clk,                  // Clock input
    input [4:0] BTNS,           // Button inputs
    input [9:0] h_counter,      // Horizontal counter
    input [9:0] v_counter,      // Vertical counter
    output reg [9:0] ballX = 600,  // Initial X position of the ball
    output reg [9:0] ballY = 400   // Initial Y position of the ball
);
    // Speed at which the player falls
    reg [15:0] verticalSpeed = 0;
    
    // Timer settings
    reg [3:0] timeMult = 7;
    reg [31:0] currentTime = 0;
    
    // Jump settings
    reg [3:0] jumpHeight = 3;
    reg [3:0] gravity = 1;
    
    // How long the player increases height
    reg [3:0] jumpTimer = 0;
    reg [3:0] jumpLength = 4;
    
    
    // Logic for moving the ball
    always @(posedge clk) begin
        if (h_counter == 0 && v_counter == 0) begin
            // Ball moving
            if (BTNS[0] == 0) begin
                if (ballY > 490) begin
                    ballY <= 490;
                    verticalSpeed <= 0;
                end else if (ballY < 10) begin
                    verticalSpeed <= 0;
                    
                // Update position every nth frame
                end else if (currentTime == 0) begin
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
            end
            
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
    input isTop,                // Decide if the module is handling the top pipe or the bottom pipe
    input clk,
    input vidon,
    output reg [9:0] wallX,     // Defines position of wall on screen
    output reg [9:0] wallY,     // Height of wall
    output reg [9:0] wallBaseX, // Adds to wallX
    output reg [9:0] wallBaseY  // Snap pipe to floor/ceiling
    );
    
    reg [15:0] currentTime;
    reg [15:0] timeMult = 5;
    reg [3:0] horizontalSpeed = 1;
    
    reg [9:0] wallMinY;
    
    initial begin
        wallBaseX = 40; // Walls are always 40 px wide
        wallX = 800;    // Begin offscreen
        wallBaseY = 550; // Snap to bottom
        wallY = 370;
        
//        if (isTop == 1) begin
//            wallBaseY = 0;   // Snap to top    
//        end else begin
//            wallBaseY = 550; // Snap to bottom
//            wallY = 430;
//            //wallMinY = 400;
//        end
    end
    
    always @(posedge clk) begin
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
                //wallY <= wallMinY + (currentTime * 2);
            end
            
            // Update speed
            if (currentTime < timeMult) begin
                    currentTime <= currentTime + 1;
            end else currentTime <= 0;
        end
    end
endmodule
