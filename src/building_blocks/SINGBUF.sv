`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 01/01/2018 03:29:06 PM
// Design Name: Arthas
// Module Name: SINGBUF
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


module SINGBUFv1(
    // inputs
    clk,
    rst, 
    data_in,
    we,
    re, 
    config_bits,
    start,
    // outputs
    rrdy,
    wrdy,
    data_out
    );
    
    parameter DATA_WIDTH = 32;
    parameter MAX_nDATA = 1024;
    parameter MAX_nPERIOD = 512*(2 ** 10);
    
    localparam WIDTH_CONFIGBITS = $clog2(MAX_nDATA) + $clog2(MAX_nPERIOD);
    
    // state definitions
    localparam S0 = 0; localparam S1 = 1; localparam S2 = 2; localparam S1p = 3; localparam S2p = 4;
    
    input clk, rst, we, re, start;
    input [DATA_WIDTH-1:0] data_in;
    input [WIDTH_CONFIGBITS-1:0] config_bits;
    
    output logic rrdy, wrdy;
    output [DATA_WIDTH-1:0] data_out;
        
    // nPeriod
    logic [$clog2(MAX_nPERIOD)-1:0] nPeriod;
    assign nPeriod = config_bits[WIDTH_CONFIGBITS-1:WIDTH_CONFIGBITS-$clog2(MAX_nPERIOD)];

    // nData
    logic [$clog2(MAX_nDATA)-1:0] nData;
    assign nData = config_bits[WIDTH_CONFIGBITS-$clog2(MAX_nPERIOD)-1:WIDTH_CONFIGBITS-$clog2(MAX_nPERIOD)-$clog2(MAX_nDATA)];
      
    // data_count
    reg [$clog2(MAX_nDATA)-1:0] data_count;
    always@(posedge clk) begin
        if (~rst) begin
            data_count <= 0;
        end
        else if ((state == S1 || state == S1p) && we) begin
            data_count <= (data_count < nData-1)? (data_count + 1): 0;
        end
        else if ((state == S2 || state == S2p) && re && rrdy) begin
            data_count <= (data_count < nData-1)? (data_count + 1): 0;
        end
    end
        
    // period_count
    reg [$clog2(MAX_nPERIOD)-1:0] period_count;
    always@(posedge clk) begin
        if (~rst) begin
            period_count <= 0;
        end
        else if ((state == S2 || state == S2p) && re && rrdy && data_count == nData-1) begin
            period_count <= (period_count < nPeriod-1)? (period_count + 1): 0;
        end
    end
    
    // buffer signals
    logic buf_clear, buf_we, buf_re, buf_full, buf_empty, buf_reachend;
    logic [DATA_WIDTH-1:0] buf_data_in;
    logic [DATA_WIDTH-1:0] buf_data_out;
    
    // wrdy
    assign wrdy = (state != S0 && buf_full == 0)? 1: 0;
    
    // rrdy
    assign rrdy = (state == S2 || state == S2p)? buf_full & (~re) & (~rrdy_tmp): 0;
    
    // rrdy_dly
    logic rrdy_dly;
    always@(posedge clk) begin
        if (~rst) begin
            rrdy_dly <= 0;
        end
        else begin
            rrdy_dly <= rrdy;
        end
    end
        
    // rrdy_tmp
    logic rrdy_tmp;
    always@(posedge clk) begin
        if (~rst) begin
            rrdy_tmp <= 0;
        end
        else if (!rrdy & rrdy_dly) begin
            rrdy_tmp <= 1;
        end
        else begin
            rrdy_tmp <= 0;
        end
    end
    
    // buf_clear
    assign buf_clear = (data_count == nData-1 && period_count == nPeriod-1 && re)? 1:0;
    
    // buf_we
    assign buf_we = we;
    
    // buf_re
    assign buf_re = re;
    
    // buf_data_in
    assign buf_data_in = data_in;
    
    // buf_data_out
    assign data_out = buf_data_out;
        
    // U0
    BUFv1#(.DATA_WIDTH(DATA_WIDTH), .MAX_nDATA(MAX_nDATA)) 
    U0 (.clk(clk), .rst(rst), .clear(buf_clear), .data_in(buf_data_in), .we(buf_we), .re(buf_re), 
        .config_bits(nData), .full(buf_full), .empty(buf_empty), .reachend(buf_reachend), .data_out(buf_data_out));
    
    // FSM
    
    // state
    reg [2:0] state;
    always@(posedge clk) begin
        if (rst == 0) begin
            state <= S0;
        end
        else begin
            case (state)
                S0: begin
                        if (start) begin
                            state <= S1p;
                        end
                    end
                S1p: begin
                        if (we) begin
                            state <= S1;
                        end
                     end
                S1: begin
                        if (buf_full) begin
                            state <= (re)? S2: S2p;
                        end
                    end
                S2: begin
                        if (data_count == nData-1 && period_count == nPeriod-1 && re && rrdy) begin
                            state <= S0;
                        end
                        else if (~re) begin
                            state <= S2p;
                        end
                    end
                S2p: begin
                        if (data_count == nData-1 && period_count == nPeriod-1 && re && rrdy) begin
                            state <= S0;
                        end
                        else if (re && rrdy) begin
                            state <= S2;
                        end
                     end
            endcase
        end
    end
    
endmodule
