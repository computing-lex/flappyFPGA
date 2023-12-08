`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:33 11/06/2012 
// Design Name: 
// Module Name:    vga_stripes 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
// Module for rendering the ball on the screen
module ball2(
    input clk,
    input vidon,
    input [9:0] h_counter,
    input [9:0] v_counter,
    input [9:0] ballX,
    input [9:0] ballY,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

    parameter BALL_XSIZE = 20;  // Ball width
    parameter BALL_YSIZE = 20;  // Ball height
    parameter SKYBOUND = 450;
    
    wire [9:0] wallX;
    wire [9:0] wallY;
    wire [9:0] wallBaseX;
    wire [9:0] wallBaseY;
    
    wallMover baseWall (
        .h_counter(h_counter),
        .v_counter(v_counter),
        .isTop(0),
        .clk(clk),
        .vidon(vidon),
        .wallX(wallX),
        .wallY(wallY),
        .wallBaseX(wallBaseX),
        .wallBaseY(wallBaseY)
    );

    // Logic for ball rendering
    always @(posedge clk) begin
        if (vidon) begin
            
            // Player
            if (h_counter > ballX && v_counter > ballY && h_counter < ballX + BALL_XSIZE && v_counter < ballY + BALL_YSIZE) begin
                red <= 15;
                blue <= 0;
                green <= 15;
            
            // Walls
            end else if (   
                   h_counter > wallX 
                && v_counter > wallY 
                && h_counter < wallX + wallBaseX 
                && v_counter < wallBaseY) 
                    begin
                red <= 9;
                blue <= 0;
                green <= 6;
                
            // Background
            end else begin
                
                // Draw ground
                if (v_counter > SKYBOUND) begin
                    red <= 1;
                    blue <= 2;
                    green <= 15;
                
                // Draw sky    
                end else begin
                    red <= 6;
                    blue <= 15;
                    green <= 7;
                end
            end
        end else begin
            red <= 0;
            green <= 0;
            blue <= 0;
        end
    end
endmodule

