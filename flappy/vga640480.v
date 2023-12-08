
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 13:06:35 11/21/2010
// Design Name:
// Module Name: vga_640_480
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
// VGA signal generation module for 640x480 resolution
// VGA signal generation module for 640x480 resolution
// VGA signal generation module for 640x480 resolution
module vga_640_480(
    input wire clk,
    input wire clr,
    output reg hsync,
    output reg vsync,
    output reg [9:0] h_counter,
    output reg [9:0] v_counter,
    output reg vidon
);

    parameter HPIXELS = 800; // Total horizontal pixels
    parameter VLINES = 521;  // Total vertical lines
    parameter HBP = 144;     // Horizontal back porch
    parameter HFP = 784;     // Horizontal front porch
    parameter VBP = 31;      // Vertical back porch
    parameter VFP = 511;     // Vertical front porch
    reg vsenable;            // Enable for vertical counter

    // Horizontal sync counter
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            h_counter <= 0;
        end else begin
            if (h_counter == HPIXELS - 1) begin
                h_counter <= 0;
                vsenable <= 1; // Enable vertical counter
            end else begin
                h_counter <= h_counter + 1;
                vsenable <= 0;
            end
        end
    end

    // Horizontal sync pulse logic
    always @(*) begin
        hsync = (h_counter < 128) ? 0 : 1;
    end

    // Vertical sync counter
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            v_counter <= 0;
        end else if (vsenable) begin
            if (v_counter == VLINES - 1) begin
                v_counter <= 0;
            end else begin
                v_counter <= v_counter + 1;
            end
        end
    end

    // Vertical sync pulse logic
    always @(*) begin
        vsync = (v_counter < 2) ? 0 : 1;
    end

    // Video on logic
    always @(*) begin
        vidon = (h_counter < HFP) && (h_counter > HBP) && (v_counter < VFP) && (v_counter > VBP);
    end

endmodule



