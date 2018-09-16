`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 12/26/2017 09:00:16 PM
// Design Name: Arthas 
// Module Name: DFSMv2
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


module DFSMv2(
    // inputs
    clk,
    rst,
    start,
    config_bits,
    in_en,
    // outputs
    start_out,
    in_en_bypass,
    A, B, C, D, E, F, G, H
    );
    parameter MAX_nPERIOD = 8;
    parameter MAX_nLMAC = 3*512*8;
    parameter MAX_nSHFT = 192;
    
    localparam CONF_REG_LEN = $clog2(MAX_nPERIOD) + $clog2(MAX_nLMAC) + $clog2(MAX_nSHFT);
    localparam MAC_CNT_WIDTH = (MAX_nLMAC > MAX_nSHFT)? MAX_nLMAC:MAX_nSHFT;
    
    // inputs
    input clk, rst, start, in_en;
    input [CONF_REG_LEN:0] config_bits;
    
    // outputs
    output logic start_out, in_en_bypass, A, B, C, D, E, F, G, H;
    
    // STATE MACHINE
        
    // state definitions
    localparam S0 = 0; localparam S1 = 1; localparam S2 = 2; localparam S0p = 3;
    localparam mdCONV = 0; localparam mdMM = 1;
    
    // mode
    logic mode;
    assign mode = config_bits[CONF_REG_LEN];
    // config_period
    logic [$clog2(MAX_nPERIOD)-1:0] config_nPeriod;
    assign config_nPeriod = config_bits[CONF_REG_LEN-1:CONF_REG_LEN-$clog2(MAX_nPERIOD)];
    // config_nLMAC
    logic [$clog2(MAX_nLMAC)-1:0] config_nLMAC;
    assign config_nLMAC = config_bits[CONF_REG_LEN-$clog2(MAX_nPERIOD)-1:CONF_REG_LEN-$clog2(MAX_nPERIOD)-$clog2(MAX_nLMAC)];
    //config_nSHFT
    logic [$clog2(MAX_nSHFT)-1:0] config_nSHFT;
    assign config_nSHFT = config_bits[CONF_REG_LEN-$clog2(MAX_nPERIOD)-$clog2(MAX_nLMAC)-1:0];
       
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
                            state <= S0p;
                        end
                    end
                S0p: begin
                        if (in_en) begin
                            state <= S1;
                        end
                     end
                S1: begin
                        if (!(mac_count < config_nLMAC-1)) begin
                            state <= S2;
                        end 
                        else begin
                            if (~in_en) begin
                                state <= S0p;
                            end
                        end
                    end
                S2: begin
                        if (!(mac_count < config_nSHFT-1)) begin
                            if (period_count < config_nPeriod-1) begin
                                state <= (in_en)? S1:S0p;
                            end
                            else begin
                                state <= S0;
                            end
                        end
                    end
            endcase
        end
    end
    
    // mac_count
    reg [$clog2(MAC_CNT_WIDTH)-1:0] mac_count;
    always@(posedge clk) begin
        if (~rst) begin
            mac_count <= 0;
        end
        else begin
            if (state == S1) begin
                if (mac_count < config_nLMAC-1) begin
                    mac_count <= mac_count + 1;
                end
                else begin
                    mac_count <= 0;
                end
            end
            else if (state == S2) begin
                if (mac_count < config_nSHFT-1) begin
                    mac_count <= mac_count + 1;
                end
                else begin
                    mac_count <= 0;
                end
            end
            else if (state == S0p) begin
                mac_count <= mac_count;
            end
            else begin
                mac_count <= 0;
            end
        end
    end
    
    // period_count
    reg [$clog2(MAX_nPERIOD)-1:0] period_count;
    always@(posedge clk) begin
        if (rst == 0) begin
            period_count <= 0;
        end
        else if (state == S0) begin
            period_count <= 0;
        end
        else if (state == S2 && (!(mac_count == MAX_nSHFT-1))) begin
            if (period_count < config_nPeriod-1) begin
                period_count <= period_count + 1;
            end
            else begin
                period_count <= 0;
            end
        end
    end
    
    // A
    always@(state) begin
//        if (state == S1 || state == S0p) begin
        if (state == S1) begin
            A = 1;
        end
        else begin
            A = 0;
        end
    end
    
    // B
    always@(state) begin
        if (state == S1 || state == S0p) begin
            B = 1;
        end
        else begin
            B = 0;
        end
    end
    
    // C 
    always@(posedge clk) begin
        if (state == S1 || state == S0p) begin
            C = 1;
        end
        else begin
            C = 0;
        end
    end
    
    // D
    always@(posedge clk) begin
        if (state == S1) begin
            D = 1;
        end
        else begin
            D = 0;
        end
    end
    
    // E
    always@(posedge clk) begin
        if (state == S2) begin
            E = 1;
        end
        else begin
            E = 0;
        end
    end
    
    // F_dly
    reg [MAX_nSHFT-1:0] F_dly;
    always@(posedge clk) begin
        if (rst == 0) begin
            F_dly <= 0;
        end
        else if (state == S2 && mac_count == 0) begin
            F_dly <= {F_dly[MAX_nSHFT-2:0], 1'b1};
        end
        else begin
            F_dly <= {F_dly[MAX_nSHFT-2:0], 1'b0};
        end
    end
            
  
    // F
    always@(posedge clk) begin
        if (rst == 0) begin
            F <= 0;
        end
        else begin
            F <= F_dly[config_nSHFT-1];
        end
    end
    
    // G
    always@(posedge clk) begin
        G <= (state == S2)? 1:0;
    end
    
    // H
    always@(posedge clk) begin
        H <= (mode == mdMM && state == S1)? 1: 0;
    end
    
    // in_en_bypass
    always@(posedge clk) begin
        in_en_bypass <= in_en;
    end
    
    // start_out
    always@(posedge clk) begin
        start_out <= start;
    end
endmodule
