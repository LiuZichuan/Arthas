`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2017 11:41:27 PM
// Design Name: 
// Module Name: DFSMv3
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


module DFSMv3(
    // inputs
    clk,
    rst,
    start,
    config_bits,
    all_data_rdy,
    in_en,
    // outputs
    start_out,
    in_en_bypass,
    data_preread,
    A, B, C, D, E, F, G, H
    );
    parameter MAX_nPERIOD = 8;
    parameter MAX_nLMAC = 3*512*8;
    parameter MAX_nSHFT = 192;
    
    localparam CONF_REG_LEN = $clog2(MAX_nPERIOD) + $clog2(MAX_nLMAC) + $clog2(MAX_nSHFT);
    localparam MAC_CNT_WIDTH = (MAX_nLMAC > MAX_nSHFT)? MAX_nLMAC:MAX_nSHFT;
    
    // inputs
    input clk, rst, start, all_data_rdy, in_en;
    input [CONF_REG_LEN:0] config_bits;
    
    // outputs
    output logic start_out, in_en_bypass, data_preread, A, B, C, D, E, F, G, H;
    
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
                        if (all_data_rdy) begin
                            state <= S1;
                        end
                     end
                S1: begin
                        if (!(mac_count < config_nLMAC-1)) begin
                            state <= S2;
                        end 
                        else begin
                            if (~all_data_rdy) begin
                                state <= S0p;
                            end
                        end
                    end
                S2: begin
                        if (!(mac_count < config_nSHFT-1)) begin
                            if (period_count < config_nPeriod-1) begin
                                state <= (all_data_rdy)? S1:S0p;
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
    
    // A_dly
    logic A_dly;
    always@(posedge clk) begin
        if (state == S1) begin
            A_dly <= 1;
        end
        else begin
            A_dly <= 0;
        end
    end
    
    // A
    always@(posedge clk) begin
        A <= A_dly;
    end
    
    // B_dly
    logic B_dly;
    always@(posedge clk) begin
        if (state == S1 || state == S0p) begin
            B_dly <= 1;
        end
        else begin
            B_dly <= 0;
        end
    end
        
    // B
    always@(posedge clk) begin
        B <= B_dly;
    end
    
    // C_dly
    logic [1:0] C_dly;
    always@(posedge clk) begin
        if (state == S1 || state == S0p) begin
            C_dly <= {C_dly[0], 1'b1};
        end
        else begin
            C_dly <= {C_dly[0], 1'b0};
        end
    end
    
    // C 
    always@(posedge clk) begin
        C <= C_dly[1];
    end
    
    // D_dly
    logic [2:0] D_dly;
    always@(posedge clk) begin
        if (state == S1) begin
            D_dly = {D_dly[1:0], 1'b1};
        end
        else begin
            D_dly = {D_dly[1:0], 1'b0};
        end
    end
    
    // D
    always@(posedge clk) begin
        D <= D_dly[2];
    end
    
    // E_dly
    logic [1:0] E_dly;
    always@(posedge clk) begin
        E_dly <= (state == S2)? {E_dly[0], 1'b1} : {E_dly[0], 1'b0}; 
    end
    
    // E
    always@(posedge clk) begin
        E <= E_dly[1];
    end
    
    // F_dly
    reg [MAX_nSHFT+1:0] F_dly;
    always@(posedge clk) begin
        if (rst == 0) begin
            F_dly <= 0;
        end
        else if (state == S2 && mac_count == 0) begin
            F_dly <= {F_dly[MAX_nSHFT:0], 1'b1};
        end
        else begin
            F_dly <= {F_dly[MAX_nSHFT:0], 1'b0};
        end
    end
            
  
    // F
    always@(posedge clk) begin
        if (rst == 0) begin
            F <= 0;
        end
        else begin
            F <= F_dly[config_nSHFT+1];
        end
    end
    
    // G_dly
    logic [1:0] G_dly;
    always@(posedge clk) begin
        G_dly <= (state == S2)? {G_dly[0], 1'b1}:{G_dly[0], 1'b0};
    end
    
    // G
    always@(posedge clk) begin
        G <= G_dly[1];
    end
    
    // H_dly
    logic [1:0] H_dly;
    always@(posedge clk) begin
        H_dly <= (mode == mdMM && state == S1)? {H_dly[0], 1'b1}: {H_dly[0], 1'b0};
    end
    
    // H_dly
    always@(posedge clk) begin
        H <= H_dly[1];
    end
    
    // in_en_bypass
    always@(posedge clk) begin
        in_en_bypass <= in_en;
    end
    
    // start_out
    always@(posedge clk) begin
        start_out <= start;
    end
    
    // data_preread
    assign data_preread = (state == S1)? 1: 0;
endmodule
