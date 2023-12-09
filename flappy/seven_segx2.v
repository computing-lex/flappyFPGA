`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 12:48:03 PM
// Design Name: 
// Module Name: seven_segx2
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


module sevenx2(
    input CLK,
    input [7:0] disp_value,
    output reg [7:0] AN,
    output [7:0] CA
);

    reg [32:0] counter;
    reg [3:0] value;

    always @(posedge CLK) begin
        counter <= counter + 1;
        if (counter[16] == 1) begin
            value <= disp_value[3:0];
            AN <= 8'b11111110;
        end else begin
            value <= disp_value[7:4];
            AN <= 8'b11111101;
        end
    end

    sev_seg sev_segment (
        .CLK(CLK),
        .CA(CA),
        .VALUE(value)
    );

endmodule

module sev_seg(
    input CLK,
    input [3:0] VALUE,
    output reg [7:0] CA
);

    always @(posedge CLK) begin
        case (VALUE)
            4'h0: CA <= 8'b11000000;
            4'h1: CA <= 8'b11111001;
            4'h2: CA <= 8'b10100100; 
            4'h3: CA <= 8'b10110000;
            4'h4: CA <= 8'b10011001; 
            4'h5: CA <= 8'b10010010; 
            4'h6: CA <= 8'b10000010; 
            4'h7: CA <= 8'b11111000; 
            4'h8: CA <= 8'b10000000;
            4'h9: CA <= 8'b10010000; 
            4'hA: CA <= 8'b10001000; 
            4'hB: CA <= 8'b10000011; 
            4'hC: CA <= 8'b11000110; 
            4'hD: CA <= 8'b10100001; 
            4'hE: CA <= 8'b10000110; 
            4'hF: CA <= 8'b10001110;
            default: CA <= 8'b11111111; // Handle invalid input gracefully
        endcase
    end    
endmodule