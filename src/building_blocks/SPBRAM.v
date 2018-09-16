`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan
// 
// Create Date: 12/27/2017 03:11:39 PM
// Design Name: 
// Module Name: SPBRAM
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


module SPBRAM (clk, we, en, addr, data_in, data_out);
    parameter WIDTH = 16;
    parameter DEPTH = 1024;
    
    input clk;
    input we;
    input en;
    input [$clog2(DEPTH)-1:0] addr;
    input [WIDTH-1:0] data_in;
    output [WIDTH-1:0] data_out;
    
    reg[WIDTH-1:0] RAM [DEPTH-1:0];
    reg[WIDTH-1:0] data_out;
    
    always @(posedge clk)
    begin
        if (en)
        begin
            if (we)
            begin
                RAM[addr] <= data_in;
                data_out <= data_in;
            end
        else
            data_out <= RAM[addr];
        end
    end
endmodule
