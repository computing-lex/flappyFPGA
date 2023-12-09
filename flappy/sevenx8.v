`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ERAU DB CEC 330
// Engineer: Alexis Tjarks
// 
// Create Date: 09/28/2023 05:22:12 PM
// Design Name: 
// Module Name: sevenx8
// Project Name: Generic Modules
// Target Devices: XC7A100TCSG324
// Description: 
//		Expecting a 100 MHz clock or similar, for the brightness.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sevenx8(
    input CLK,
    input [15:0] disp_value,
    output reg [7:0] AN,
    output [7:0] CA
);

    reg [32:0] counter;
    reg [3:0] value;

    always @(posedge CLK) begin
        counter <= counter + 1;
        
        case (counter[18:17])
           0 : begin
                value <= disp_value [3:0];
                AN <= 8'b11111110;
                end
           1 : begin
               value <= disp_value [7:4];
               AN <= 8'b11111101;
               end
           2 : begin
               value <= disp_value [11:8];
               AN <= 8'b11111011;
               end
           3 : begin
               value <= disp_value [15:12];
               AN <= 8'b11110111;
               end        
        endcase
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