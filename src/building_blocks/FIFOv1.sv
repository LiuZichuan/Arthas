`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 12/27/2017 10:41:06 AM
// Design Name: Arthas
// Module Name: FIFOv1
// Project Name: Arthas 
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


module FIFOv1(
    // inputs
    clk,
    rst,
    we,
    re,
    clear,
    data_in,
    // outputs
    full,
    empty,
    data_out,
    );
    
    parameter WIDTH = 16;
    parameter DEPTH = 128;
    
    input clk, rst, we, re, clear;
    input [WIDTH-1:0] data_in;
    
    output full, empty;
    output [WIDTH-1:0] data_out;
    
    FIFO # (.DSIZE(WIDTH), .ASIZE($clog2(DEPTH))) 
    data_vert_fifo_1_1(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(we), 
                       .rinc(re), .wfull(full), .rempty(empty), 
                       .wfull_almost(), .rdata(data_out), 
                       .wdata(data_in));
    
endmodule
