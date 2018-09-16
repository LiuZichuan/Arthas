`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 11:15:51 PM
// Design Name: Arthas
// Module Name: AC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Accumulator
// 
// Dependencies: 
// 
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AC(
    // inputs
    clk,
    rst,
    ipsum,
    in_en,
    F,
    // outputs
    data_out
    );
    parameter IN_WIDTH = 32; // bitwidth of the input
    parameter ACC_WIDTH = 35; // bitwidth of the interal accumulate register
    
    // inputs
    input logic clk, rst, in_en, F;
    input logic [IN_WIDTH-1:0] ipsum;
    
    // outputs
    output [ACC_WIDTH-1:0] data_out;
    
    // ipsum_reg
    logic [IN_WIDTH-1:0] ipsum_reg;
    always@(posedge clk) begin
        if (~rst) begin
            ipsum_reg <= 0;
        end
        else if (in_en) begin
            ipsum_reg <= ipsum;
        end
        else begin
            ipsum_reg <= 0;
        end
    end
    
    logic [ACC_WIDTH-1:0] add_node;
    
    // psum_reg
    logic [ACC_WIDTH-1:0] psum_reg;
    always@(posedge clk) begin
        if (~rst) begin
            psum_reg <= 0;
        end
        else begin
            psum_reg <= add_node;
        end
    end
    
    // psum_mux
    logic [ACC_WIDTH-1:0] psum_mux;
    assign psum_mux = (F)? psum_reg:0;
    
    // add_node
    assign add_node = ipsum_reg + psum_mux;
    
    // data_out
    assign data_out = add_node;
    
endmodule
