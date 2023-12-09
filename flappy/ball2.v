`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:33 11/06/2012 
// Design Name: 
// Module Name:    renderer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created (vga_stripes)
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module renderer(
    input clk,
    input vidon,
    input [9:0] h_counter,
    input [9:0] v_counter,
    input [9:0] ballX, ballY,
    input [9:0] wallXL,wallXU, wallBaseXL, wallBaseXU,
    input [9:0] wallYL, wallYU, wallBaseYL, wallBaseYU,
    input [15:0] status,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

    parameter BALL_XSIZE = 20;  // Ball width
    parameter BALL_YSIZE = 20;  // Ball height
    parameter SKYBOUND = 450;

    // Logic for ball rendering
    always @(posedge clk) begin
        if (vidon) begin
            
            // Player
            if (h_counter > ballX && v_counter > ballY && h_counter < ballX + BALL_XSIZE && v_counter < ballY + BALL_YSIZE) begin
                if (status[1] == 1 || status[0] == 1) begin
                    red <= 15;
                    blue <= 0;
                    green <= 0;
                end else begin
                    red <= 15;
                    blue <= 0;
                    green <= 15;
                end
            
            // Lower walls
            end else if (   
                   h_counter > wallXL 
                && v_counter > wallYL 
                && h_counter < wallXL + wallBaseXL 
                && v_counter < wallBaseYL) begin
                red <= 9;
                blue <= 0;
                green <= 6;
                
            // Upper walls - Order Y checked is flipped
            end else if (   
                   h_counter > wallXU 
                && v_counter > 0 
                && h_counter < wallXU + wallBaseXU  
                && v_counter < 185
                ) begin
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

