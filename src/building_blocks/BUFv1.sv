`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan
// 
// Create Date: 12/27/2017 11:05:08 AM
// Design Name: Arthas
// Module Name: BUFv1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Data buffer used to feed obli data
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BUFv1(
    // inputs
    clk,
    rst,
    clear,
    data_in,
    we,
    re,
    config_bits,
    // outputs
    full,
    empty,
    reachend,
    data_out
    );
    
    parameter DATA_WIDTH = 16;
    parameter MAX_nDATA = 1024;
    localparam ADDR_WIDTH = $clog2(MAX_nDATA);
    localparam WIDTH_CONFIGBITS = $clog2(MAX_nDATA);
    
    input clk, rst, clear, we, re;
    input [DATA_WIDTH-1:0] data_in;
    input [WIDTH_CONFIGBITS-1:0] config_bits;
    
    output logic full, empty, reachend;
    output [DATA_WIDTH-1:0] data_out;
    
    // data_size
    logic [$clog2(MAX_nDATA):0] data_size;
    assign data_size = config_bits;
    
    // nData
    reg [$clog2(MAX_nDATA):0] nData;
    always@(posedge clk) begin
        if (~rst) begin
            nData <= 0;
        end
        else if (clear) begin
            nData <= 0;
        end
        else if (we && nData < data_size) begin
            nData <= nData + 1;
        end
    end
    
    // full
    assign full = (nData >= data_size-1 && nData > 0)? 1: 0;
    
    // empty
    assign empty = (nData == 0)? 1:0;
    
    // raddr
    reg [ADDR_WIDTH-1:0] raddr;
    always@(posedge clk) begin
        if (~rst) begin
            raddr <= 0;
        end
        else if (clear) begin
            raddr <= 0;
        end
        else if (re) begin
            raddr <= (raddr < nData-1 && nData != 0)? (raddr + 1): 0;
        end
    end
    
    // reachend
    always@(posedge clk) begin
        reachend <= (raddr == nData-1 && nData != 0 && re)? 1:0;
    end
    
    // addr 
    logic [ADDR_WIDTH-1:0] addr;
    assign addr = (we)? nData[$clog2(MAX_nDATA)-1:0]: raddr;
    
    // BRAMLP16x1024
    SPBRAM#(.WIDTH(DATA_WIDTH), .DEPTH(MAX_nDATA)) U(.clk(clk), .en(1'b1), .we(we), .addr(addr), .data_in(data_in), .data_out(data_out));
    
endmodule
