`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2017 09:12:13 PM
// Design Name: 
// Module Name: DFSM
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


module DFSM(
    // inputs
    clk,
    rst,
    start,
    iconfig,
    config_en,
    in_en,
    // outputs
    start_out,
    in_en_bypass,
    out_en,
    A, B, C, D, E, F, G
    );
    parameter MAX_nPERIOD = 8;
    parameter MAX_nLMAC = 3*512*8;
    parameter MAX_nSHFT = 192;
    
    localparam CONF_REG_LEN = $clog2(MAX_nPERIOD) + $clog2(MAX_nLMAC) + $clog2(MAX_nSHFT);
    localparam MAC_CNT_WIDTH = (MAX_nLMAC > MAX_nSHFT)? MAX_nLMAC:MAX_nSHFT;
    
    // inputs
    input clk, rst, start, iconfig, config_en, in_en;
    
    // outputs
    output logic out_en, start_out, in_en_bypass, A, B, C, D, E, F, G;
    
    // STATE MACHINE
        
    // state definitions
    localparam S0 = 0; localparam S1 = 1; localparam S2 = 2; localparam S0p = 3;
    
    // configs
    reg [CONF_REG_LEN-1:0] configs;
    always@(posedge clk) begin
        if (rst == 0) begin
            configs <= 0;
        end
        else if (config_en == 1 && state == S0) begin
            configs <= {iconfig, configs[CONF_REG_LEN-1:1]};
        end
    end
    
    // config_period
    logic [$clog2(MAX_nPERIOD)-1:0] config_nPeriod;
    assign config_nPeriod = configs[CONF_REG_LEN-1:CONF_REG_LEN-$clog2(MAX_nPERIOD)];
    // config_nLMAC
    logic [$clog2(MAX_nLMAC)-1:0] config_nLMAC;
    assign config_nLMAC = configs[CONF_REG_LEN-$clog2(MAX_nPERIOD)-1:CONF_REG_LEN-$clog2(MAX_nPERIOD)-$clog2(MAX_nLMAC)];
    //config_nSHFT
    logic [$clog2(MAX_nSHFT)-1:0] config_nSHFT;
    assign config_nSHFT = configs[CONF_REG_LEN-$clog2(MAX_nPERIOD)-$clog2(MAX_nLMAC)-1:0];
       
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
                                state <= S0p;
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
        if (state == S1 || state == S0p) begin
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
    always@(state) begin
        if (state == S2) begin
            E = 1;
        end
        else begin
            E = 0;
        end
    end
    
    // F_dly
    reg [$clog2(MAX_nSHFT)-1:0] F_dly;
    always@(posedge clk) begin
        if (rst == 0) begin
            F_dly <= 0;
        end
        else if (state == S2 && mac_count == 0) begin
            F_dly <= {F_dly[$clog2(MAX_nSHFT)-2:0], 1'b1};
        end
        else begin
            F_dly <= {F_dly[$clog2(MAX_nSHFT)-2:0], 1'b0};
        end
    end
            
  
    // F
    always@(posedge clk) begin
        if (rst == 0) begin
            F <= 0;
        end
        else begin
            F <= F_dly[config_nSHFT];
        end
    end
    
    // G
    always@(posedge clk) begin
        G <= (state == S2)? 1:0;
    end
    
    // in_en_bypass
    always@(posedge clk) begin
        in_en_bypass <= in_en;
    end
 
    // out_en 
    always@(posedge clk) begin
        out_en <= (state != S2 && G == 1)? 1:0;
    end
    
    // start_out
    always@(posedge clk) begin
        start_out <= start;
    end
endmodule
