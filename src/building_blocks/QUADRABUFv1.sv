`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan
// 
// Create Date: 12/27/2017 12:41:53 PM
// Design Name: 
// Module Name: QUADRABUFv1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Data buffer to feed obli data alternatively
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module QUADRABUFv1(
    // inputs
    clk,
    rst, 
    data_in,
    we,
    re, 
    config_bits,
    start,
    // outputs
    swcol,
    nxcol,
    rrdy,
    wrdy,
    data_out
    );
    
    parameter DATA_WIDTH = 16;
    parameter MAX_nDATA = 1024;
    parameter MAX_nREP = 1024;
    parameter MAX_nPERIOD = 512*(2 ** 10);
    
    localparam MAX_nCOL = 3;
    localparam WIDTH_CONFIGBITS = $clog2(MAX_nDATA) + $clog2(MAX_nCOL) + $clog2(MAX_nREP) + $clog2(MAX_nPERIOD);
    
    // state definitions
    localparam S0 = 0; localparam S1 = 1; localparam S2 = 2; localparam S1p = 3; localparam S2p = 4;
    
    input clk, rst, we, re, start;
    input [DATA_WIDTH-1:0] data_in;
    input [WIDTH_CONFIGBITS-1:0] config_bits;
    
    output logic rrdy, wrdy, swcol, nxcol;
    output [DATA_WIDTH-1:0] data_out;
    
    // nCol
    logic [$clog2(MAX_nCOL)-1:0] nCol;
    assign nCol = config_bits[WIDTH_CONFIGBITS-1:WIDTH_CONFIGBITS-$clog2(MAX_nCOL)];
    
    // nRep
    logic [$clog2(MAX_nREP)-1:0] nRep;
    assign nRep = config_bits[WIDTH_CONFIGBITS-$clog2(MAX_nCOL)-1:WIDTH_CONFIGBITS-$clog2(MAX_nCOL)-$clog2(MAX_nREP)];
    
    // nPeriod
    logic [$clog2(MAX_nPERIOD)-1:0] nPeriod;
    assign nPeriod = config_bits[WIDTH_CONFIGBITS-$clog2(MAX_nCOL)-$clog2(MAX_nREP)-1:WIDTH_CONFIGBITS-$clog2(MAX_nCOL)-$clog2(MAX_nREP)-$clog2(MAX_nPERIOD)];

    // nData
    logic [$clog2(MAX_nDATA)-1:0] nData;
    assign nData = config_bits[WIDTH_CONFIGBITS-$clog2(MAX_nCOL)-$clog2(MAX_nREP)-$clog2(MAX_nPERIOD)-1:WIDTH_CONFIGBITS-$clog2(MAX_nCOL)-$clog2(MAX_nREP)-$clog2(MAX_nPERIOD)-$clog2(MAX_nDATA)];
    
    // col_count
    reg [$clog2(MAX_nCOL)-1:0] col_count;
    always@(posedge clk) begin
        if (~rst) begin
            col_count <= 0;
        end
        else if ((state == S2 || state == S2p) && re && rrdy && data_count == nData-1) begin
            col_count <= (col_count < nCol-1)? (col_count + 1): 0;
        end
    end
    
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
    
    // rep_count
    reg [$clog2(MAX_nREP)-1:0] rep_count;
    always@(posedge clk) begin
        if (~rst) begin
            rep_count <= 0;
        end
        else if ((state == S2 || state == S2p) && re && rrdy && data_count == nData-1 && col_count == nCol-1) begin
            rep_count <= (rep_count < nRep-1)? (rep_count + 1): 0;
        end
    end
    
    // period_count
    reg [$clog2(MAX_nPERIOD)-1:0] period_count;
    always@(posedge clk) begin
        if (~rst) begin
            period_count <= 0;
        end
        else if ((state == S2 || state == S2p) && re && rrdy && data_count == nData-1 && col_count == nCol-1 && rep_count == nRep-1) begin
            period_count <= (period_count < nPeriod-1)? (period_count + 1): 0;
        end
    end
    
    // buffer signals
    logic buf_clear [3:0], buf_we [3:0], buf_re [3:0], buf_full [3:0], buf_empty [3:0], buf_reachend [3:0];
    logic [DATA_WIDTH-1:0] buf_data_in [3:0];
    logic [DATA_WIDTH-1:0] buf_data_out [3:0];
    
    // forthidx
    logic [1:0] forthidx;
    always@(posedge clk) begin
        if (~rst) begin
            forthidx <= 0;
        end
        else if ((state == S1 || state == S1p) && we && data_count == nData-1 && forthidx < 3) begin
            forthidx <= forthidx + 1;
        end
        else if ((state == S2 || state == S2p) && rrdy && re && data_count == nData-1 && col_count == nCol-1 && rep_count == nRep-1) begin
            forthidx <= forthidx + 1;
        end
    end
    
    // actidx
    logic [1:0] actidx;
    assign actidx = col_count + forthidx + 1;
    
    // wrdy
    assign wrdy = (state != S0 && buf_full[forthidx] == 0)? 1: 0;
    
    // rrdy
    assign rrdy = (state == S2 || state == S2p)? buf_full[actidx]: 0;
    
    // nxcol
    assign nxcol = (state == S2 || state == S2p)? buf_reachend[actidx]: 0;
    
    // swcol
    assign swcol = (data_count == nData-1 && col_count == nCol-1 && rep_count == nRep-1 && re)? 1:0;
    
    // buf_clear
    always@(*) begin
        case(forthidx)
            0:
            begin
                buf_clear[0] = 0; buf_clear[1] = swcol; buf_clear[2] = 0; buf_clear[3] = 0;
            end
            1:
            begin
                buf_clear[0] = 0; buf_clear[1] = 0; buf_clear[2] = swcol; buf_clear[3] = 0;
            end
            2:
            begin
                buf_clear[0] = 0; buf_clear[1] = 0; buf_clear[2] = 0; buf_clear[3] = swcol;
            end
            3:
            begin
                buf_clear[0] = swcol; buf_clear[1] = 0; buf_clear[2] = 0; buf_clear[3] = 0;
            end
        endcase
    end
    
    // buf_we
    always@(*) begin
        case(forthidx)
            0:
            begin
                buf_we[0] = we; buf_we[1] = 0; buf_we[2] = 0; buf_we[3] = 0;
            end
            1:
            begin
                buf_we[0] = 0; buf_we[1] = we; buf_we[2] = 0; buf_we[3] = 0;
            end
            2:
            begin
                buf_we[0] = 0; buf_we[1] = 0; buf_we[2] = we; buf_we[3] = 0;
            end
            3:
            begin
                buf_we[0] = 0; buf_we[1] = 0; buf_we[2] = 0; buf_we[3] = we;
            end
        endcase
    end
    
    // buf_re
    always@(*) begin
        case(actidx)
            0:
            begin
                buf_re[0] = re; buf_re[1] = 0; buf_re[2] = 0; buf_re[3] = 0;
            end
            1:
            begin
                buf_re[0] = 0; buf_re[1] = re; buf_re[2] = 0; buf_re[3] = 0;
            end
            2:
            begin
                buf_re[0] = 0; buf_re[1] = 0; buf_re[2] = re; buf_re[3] = 0;
            end
            3:
            begin
                buf_re[0] = 0; buf_re[1] = 0; buf_re[2] = 0; buf_re[3] = re;
            end
        endcase
    end
    
    // buf_data_in
    always@(*) begin
        case(forthidx)
            0:
            begin
                buf_data_in[0] = data_in; buf_data_in[1] = 0; buf_data_in[2] = 0; buf_data_in[3] = 0;
            end
            1:
            begin
                buf_data_in[0] = 0; buf_data_in[1] = data_in; buf_data_in[2] = 0; buf_data_in[3] = 0;
            end
            2:
            begin
                buf_data_in[0] = 0; buf_data_in[1] = 0; buf_data_in[2] = data_in; buf_data_in[3] = 0;
            end
            3:
            begin
                buf_data_in[0] = 0; buf_data_in[1] = 0; buf_data_in[2] = 0; buf_data_in[3] = data_in;
            end
        endcase
    end
    
    // buf_data_out
    assign data_out = buf_data_out[actidx];
        
    // U0
    BUFv1#(.DATA_WIDTH(DATA_WIDTH), .MAX_nDATA(MAX_nDATA)) 
    U0 (.clk(clk), .rst(rst), .clear(buf_clear[0]), .data_in(buf_data_in[0]), .we(buf_we[0]), .re(buf_re[0]), 
        .config_bits(nData), .full(buf_full[0]), .empty(buf_empty[0]), .reachend(buf_reachend[0]), .data_out(buf_data_out[0]));
    
    // U1
    BUFv1#(.DATA_WIDTH(DATA_WIDTH), .MAX_nDATA(MAX_nDATA)) 
    U1 (.clk(clk), .rst(rst), .clear(buf_clear[1]), .data_in(buf_data_in[1]), .we(buf_we[1]), .re(buf_re[1]), 
        .config_bits(nData), .full(buf_full[1]), .empty(buf_empty[1]), .reachend(buf_reachend[1]), .data_out(buf_data_out[1]));
    
    // U2
    BUFv1#(.DATA_WIDTH(DATA_WIDTH), .MAX_nDATA(MAX_nDATA)) 
    U2 (.clk(clk), .rst(rst), .clear(buf_clear[2]), .data_in(buf_data_in[2]), .we(buf_we[2]), .re(buf_re[2]), 
        .config_bits(nData), .full(buf_full[2]), .empty(buf_empty[2]), .reachend(buf_reachend[2]), .data_out(buf_data_out[2]));
    
    // U3
    BUFv1#(.DATA_WIDTH(DATA_WIDTH), .MAX_nDATA(MAX_nDATA)) 
    U3 (.clk(clk), .rst(rst), .clear(buf_clear[3]), .data_in(buf_data_in[3]), .we(buf_we[3]), .re(buf_re[3]), 
        .config_bits(nData), .full(buf_full[3]), .empty(buf_empty[3]), .reachend(buf_reachend[3]), .data_out(buf_data_out[3]));
        
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
                        if (buf_full[0] && buf_full[1] && buf_full[2] && buf_full[3]) begin
                            state <= (re)? S2: S2p;
                        end
                    end
                S2: begin
                        if (data_count == nData-1 && col_count == nCol-1 && rep_count == nRep-1 && period_count == nPeriod-1 && re && rrdy) begin
                            state <= S0;
                        end
                        else if (~re) begin
                            state <= S2p;
                        end
                    end
                S2p: begin
                        if (data_count == nData-1 && col_count == nCol-1 && rep_count == nRep-1 && period_count == nPeriod-1 && re && rrdy) begin
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
