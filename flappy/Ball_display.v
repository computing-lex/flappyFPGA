`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Alexis Tjarks
// 
// Create Date:     19:54:01 11/06/2012 
// Design Name: 
// Module Name:     flappybird 
// Project Name:    
// Target Devices:  
// Tool versions: 
// Description:     Final project for CEC 330
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created (vga_stripes_top)
//          1.0  - Rebuilt for use in flappy bird
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
// Main module for ball display handling
module flappybird(
    input CLK,             // System clock
    input [4:0] BTNS,      // Input buttons
    input [15:0] SW,       // Input switches
    output VGA_HS,         // VGA horizontal sync
    output VGA_VS,         // VGA vertical sync
    output [3:0] VGA_R,    // VGA red channel
    output [3:0] VGA_G,    // VGA green channel
    output [3:0] VGA_B,    // VGA blue channel
    output [15:0] LED,      // LED outputs
    output [7:0] AN, CA
);

    wire vidon;                  // Video on signal
    wire [9:0] h_counter, v_counter; // Horizontal and vertical counters
    wire [9:0] ballX, ballY; // Ball position coordinates
    
    // L = Lower
    wire [9:0] wallXL;
    wire [9:0] wallYL;
    wire [9:0] wallBaseXL;
    wire [9:0] wallBaseYL;
    
    // U = Upper
    wire [9:0] wallXU;
    wire [9:0] wallYU;
    wire [9:0] wallBaseXU;
    wire [9:0] wallBaseYU;

    reg [1:0] count; // Counter for system clock division

    // Clock division for VGA timing
    always @(posedge CLK) begin
        count <= count + 1;
        //LED <= SW; // Reflect switch state on LEDs
    end

    // Module for moving the ball
    Ball_mover mover (
        .clk(CLK),
        .BTNS(BTNS),
        .h_counter(h_counter),
        .v_counter(v_counter),
        .wallX(wallXL),
        .wallYL(wallYL),
        .wallYU(wallYU),
        .ballX(ballX),
        .ballY(ballY),
        .status(LED)
    );
    
    wallMover lowerWall (
        .h_counter(h_counter),
        .v_counter(v_counter),
        .isUpper(0),
        .clk(CLK),
        .vidon(vidon),
        .status(LED),
        .rst(BTNS[0]),
        .wallX(wallXL),
        .wallY(wallYL),
        .wallBaseX(wallBaseXL),
        .wallBaseY(wallBaseYL)
    );
    
    wallMover upperWall (
        .h_counter(h_counter),
        .v_counter(v_counter),
        .isUpper(1),
        .clk(CLK),
        .vidon(vidon),
        .status(LED),
        .rst(BTNS[0]),
        .wallX(wallXU),
        .wallY(wallYU),
        .wallBaseX(wallBaseXU),
        .wallBaseY(wallBaseYU)
    );

    // Module for ball rendering
    renderer render (
        .clk(CLK),
        .vidon(vidon),
        .status(LED),
        .h_counter(h_counter),
        .v_counter(v_counter),
        // Ball
        .ballX(ballX),
        .ballY(ballY),
        // Upper
        .wallXU(wallXU),
        .wallYU(200),
        .wallBaseXU(wallBaseXU),
        .wallBaseYU(wallBaseYU),
        // Lower
        .wallXL(wallXL),
        .wallYL(wallYL),
        .wallBaseXL(wallBaseXL),
        .wallBaseYL(wallBaseYL),
        
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
    
    sevenx8 scoreDisp (
        .CLK(CLK),
        .disp_value(LED[15:8]),
        .AN(AN),
        .CA(CA)
    );

endmodule

