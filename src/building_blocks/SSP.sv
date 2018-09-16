`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan
// 
// Create Date: 12/26/2017 09:23:30 PM
// Design Name: Arthas
// Module Name: SSP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 2x2 spatial Subsampler (Max-pooling)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SSP(
    // inputs
    clk,
    rst,
    data_in,
    data_in_en,
    config_bits,
    start,
    // outputs
    data_out,
    data_out_en
    );
    
    parameter WIDTH = 16;
    parameter MAX_nData = 32;
    parameter MAX_nPeriod = 64;
    
    localparam LEN_CONFIG_BITS = $clog2(MAX_nData) + $clog2(MAX_nPeriod);
    localparam FIFO_WIDTH = WIDTH; localparam FIFO_DEPTH = 40;
    
    input clk, rst, start, data_in_en;
    input [WIDTH-1:0] data_in;
    input [LEN_CONFIG_BITS-1:0] config_bits;
    
    output logic data_out_en;
    output [WIDTH-1:0] data_out;
    
    // data_in_reg_0
    reg [WIDTH-1:0] data_in_reg_0;
    always@(posedge clk) begin
        if (~rst) begin
            data_in_reg_0 <= 0;
        end
        else if (data_in_en) begin
            data_in_reg_0 <= data_in;
        end
    end
    
    // data_in_reg_1
    reg [WIDTH-1:0] data_in_reg_1;
    always@(posedge clk) begin
        if (~rst) begin
            data_in_reg_1 <= 0;
        end
        else begin
            data_in_reg_1 <= data_in_reg_0;
        end
    end
    
    // cmp_node_0
    logic [WIDTH-1:0] cmp_node_0;
    assign cmp_node_0 = (data_in_reg_0 > data_in_reg_1)? data_in_reg_0: data_in_reg_1;
    
    // cmp_node_1
    logic [WIDTH-1:0] cmp_node_1;
    assign cmp_node_1 = (cmp_node_0 > last_col_data_mux)? cmp_node_0: last_col_data_mux;
    
    // last_col_data_mux
    logic [WIDTH-1:0] last_col_data_mux;
    assign last_col_data_mux = (~zero)? fifo_data_out: 0;
    
    // FIFO
    logic fifo_we, fifo_re, fifo_full, fifo_empty, fifo_clear;
    logic [WIDTH-1:0] fifo_data_in, fifo_data_out;
    
    // fifo_data_in
    assign fifo_data_in = (~data_out_en)? cmp_node_1: 0;
    
    // 
    
    FIFOv1 # (.WIDTH(FIFO_WIDTH), .DEPTH(FIFO_DEPTH)) 
    fifo (.clk(clk), .rst(rst), .we(fifo_we), .re(fifo_re), .full(fifo_full), .empty(fifl_empty), 
          .clear(fifo_clear), .data_in(fifo_data_in), .data_out(fifo_data_out));
    
    // data_out
    assign data_out = (data_out_en)? cmp_node_1: 0;
    
    // L-FSM
    
    // state definitions
    localparam S0 = 0; localparam S1 = 1; localparam S2 = 2; localparam S1p = 3; localparam S2p = 4;
    
    // nPeriod
    logic [$clog2(MAX_nPeriod)-1:0] nPeriod;
    assign nPeriod = config_bits[LEN_CONFIG_BITS-1:LEN_CONFIG_BITS-$clog2(MAX_nPeriod)];
    
    // nData
    logic [$clog2(MAX_nData)-1:0] nData;
    assign nData = config_bits[LEN_CONFIG_BITS-$clog2(MAX_nPeriod)-1:0];
    
    // state
    reg [1:0] state;
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
                        if (data_in_en) begin
                            state <= S1;
                        end
                     end
                S1: begin
                        if (!(data_count < nData-1)) begin
                            state <= (data_in_en)? S2: S2p;
                        end 
                        else begin
                            if (~data_in_en) begin
                                state <= S1p;
                            end
                        end
                    end
                S2: begin
                        if (data_count < nData-1) begin
                            state <= (data_in_en)? S2: S2p;
                        end
                        else if (data_count == nData-1 && period_count < nPeriod-1) begin
                            state <= (data_in_en)? S1: S1p;
                        end
                        else if (data_count == nData-1 && period_count == nPeriod-1) begin
                            state <= S0;
                        end
                    end
            endcase
        end
    end
    
    // period_count
    reg [$clog2(MAX_nPeriod)-1:0] period_count;
    always@(posedge clk) begin
        if (~rst) begin
            period_count <= 0;
        end
        else if (data_in_en && state == S2 && data_count == nData) begin
            period_count <= (period_count < nPeriod)? (period_count + 1): 0;
        end
    end
    
    // data_count
    reg [$clog2(MAX_nData)-1:0] data_count;
    always@(posedge clk) begin
        if (~rst) begin
            data_count <= 0;
        end
        else if (data_in_en && state != S0) begin
            data_count <= (data_count < nData-1)? (data_count + 1): 0;
        end
    end
    
    // zero
    logic zero;
    assign zero = (state == S1 || state == S1p)? 1: 0;
    
    // fifo_we
    always@(posedge clk) begin
        if (~rst) begin
            fifo_we <= 0;
        end
        else if ((state == S1 || state == S1p) && data_count[0] == 1 && data_in_en) begin
            fifo_we <= 1;
        end
    end
    
    // fifo_re
    always@(posedge clk) begin
        if (~rst) begin
            fifo_re <= 0;
        end
        else if ((state == S2 || state == S2p) && data_count[0] == 0 && data_in_en) begin
            fifo_re <= 1;
        end
        else begin
            fifo_re <= 0;
        end
    end
    
    // data_out_en
    always@(posedge clk) begin
        data_out_en <= fifo_re;
    end
    
endmodule
