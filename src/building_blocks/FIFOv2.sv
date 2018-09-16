`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 12/27/2017 10:41:06 AM
// Design Name: Arthas
// Module Name: FIFOv2
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


module FIFOv2(
    // inputs
    clk,
    rst,
    we,
    re,
    clear,
    data_in,
    config_bits,
    // outputs
    full,
    empty,
    reachend,
    data_out,
    );
    
    parameter WIDTH = 16;
    parameter DEPTH = 128;
    parameter MAX_nDATA = 1*1*1126;
    parameter WIDTH_CONFIGBITS = $clog2(MAX_nDATA);
    
    input clk, rst, we, re, clear;
    input [WIDTH-1:0] data_in;
    input [WIDTH_CONFIGBITS-1:0] config_bits;
    
    output full, empty, reachend;
    output [WIDTH-1:0] data_out;
    
    // nData
    logic [$clog2(MAX_nDATA)-1:0] nData;
    assign nData = config_bits;
    
    // 
    
endmodule
