`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:01 11/06/2012 
// Design Name: 
// Module Name:    vga_stripes_top 
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
// Main module for ball display handling
module ball_display(
    input CLK,             // System clock
    input [4:0] BTNS,      // Input buttons
    input [15:0] SW,       // Input switches
    output VGA_HS,         // VGA horizontal sync
    output VGA_VS,         // VGA vertical sync
    output [3:0] VGA_R,    // VGA red channel
    output [3:0] VGA_G,    // VGA green channel
    output [3:0] VGA_B,    // VGA blue channel
    output reg [15:0] LED  // LED outputs
);

    wire vidon;                  // Video on signal
    wire [9:0] h_counter, v_counter; // Horizontal and vertical counters
    wire [9:0] ballX, ballY; // Ball position coordinates

    reg [1:0] count; // Counter for system clock division

    // Clock division for VGA timing
    always @(posedge CLK) begin
        count <= count + 1;
        LED <= SW; // Reflect switch state on LEDs
    end

    // Module for moving the ball
    Ball_mover mover (
        .clk(CLK),
        .BTNS(BTNS),
        .h_counter(h_counter),
        .v_counter(v_counter),
        .ballX(ballX),
        .ballY(ballY)
    );

    // Module for ball rendering
    ball2 renderer (
        .clk(CLK),
        .vidon(vidon),
        .h_counter(h_counter),
        .v_counter(v_counter),
        .ballX(ballX),
        .ballY(ballY),
        .red(VGA_R),
        .green(VGA_G),
        .blue(VGA_B)
    );

    // VGA signal generation
    vga_640_480 vga_gen (
        .clk(count[1]), 
        .clr(0), 
        .hsync(VGA_HS), 
        .vsync(VGA_VS), 
        .h_counter(h_counter), 
        .v_counter(v_counter), 
        .vidon(vidon)
    );

endmodule

