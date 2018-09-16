`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2017 03:51:03 PM
// Design Name: 
// Module Name: PE
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


module PE(
    // inputs
    clk,
    rst,
    start,
    iconfig,
    config_en,
    in_en,
    weight,
    feature,
    ipsum,
    // outputs
    opsum,
    out_en
    );
    parameter WIDTH = 16;
    parameter MAX_nPERIOD = 8;
    parameter MAX_nLMAC = 3*512*8;
    parameter MAX_nSHFT = 192;
    
    localparam CONF_REG_LEN = $clog2(MAX_nPERIOD) + $clog2(MAX_nLMAC) + $clog2(MAX_nSHFT);
    localparam MAC_CNT_WIDTH = (MAX_nLMAC > MAX_nSHFT)? MAX_nLMAC:MAX_nSHFT;
    localparam M_WIDTH = WIDTH*2;
    localparam A_WIDTH = M_WIDTH+1;
    
    // inputs
    input clk, rst, start, iconfig, config_en, in_en;
    input [WIDTH-1:0] weight, feature;
    input [A_WIDTH-1:0] ipsum;
    
    // outputs
    output logic [A_WIDTH-1:0] opsum;
    output logic out_en;
    
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
    logic A;
    always@(state) begin
        if (state == S1 || state == S0p) begin
            A = 1;
        end
        else begin
            A = 0;
        end
    end
    
    // B
    logic B;
    always@(state) begin
        if (state == S1 || state == S0p) begin
            B = 1;
        end
        else begin
            B = 0;
        end
    end
    
    // C 
    logic C;
    always@(posedge clk) begin
        if (state == S1 || state == S0p) begin
            C = 1;
        end
        else begin
            C = 0;
        end
    end
    
    // D
    logic D;
    always@(posedge clk) begin
        if (state == S1) begin
            D = 1;
        end
        else begin
            D = 0;
        end
    end
    
    // E
    logic E;
    always@(state) begin
        if (state == S2) begin
            E = 1;
        end
        else begin
            E = 0;
        end
    end
    
    // out_en
    always@(posedge clk) begin
        out_en <= (state == S2)? 1:0;
    end
    
    // PROCESSING UNITS
    
    // weight_reg
    logic [WIDTH-1:0] weight_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            weight_reg <= 0;
        end
        else if (A && in_en) begin
            weight_reg <= weight;
        end
        else begin
            weight_reg <= 0;
        end
    end
    
    // feature_reg
    logic [WIDTH-1:0] feature_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            feature_reg <= 0;
        end
        else if (A && in_en) begin
            feature_reg <= feature;
        end 
        else begin
            feature_reg <= 0;
        end
    end
    
    // m_reg
    reg [M_WIDTH-1:0] m_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            m_reg <= 0;
        end
        else begin
            m_reg <= weight_reg * feature_reg;
        end
    end
    
    // a_wire
    logic [A_WIDTH-1:0] a_wire;
    always@(m_reg or psum_mux) begin
        a_wire <= m_reg + psum_mux;
    end
    
    // psum_reg
    reg [A_WIDTH-1:0] psum_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            psum_reg <= 0;
        end
        else begin
            psum_reg <= a_wire;
        end
    end
    
    // psum_mux
    logic [A_WIDTH-1:0] psum_mux;
    always@(psum_reg or C) begin
        if (C == 1) begin
            psum_mux <= psum_reg;
        end
        else begin
            psum_mux <= 0;
        end
    end
    
    // opsum_mux
    logic [A_WIDTH-1:0] opsum_mux;
    always@(a_wire or ipsum_reg or D) begin
        if (D == 1) begin
            opsum_mux <= a_wire;
        end
        else begin
            opsum_mux <= ipsum_reg;
        end
    end
    
    // opsum
    always@(posedge clk) begin
        if (rst == 0) begin
            opsum <= 0;
        end
        else begin
         opsum <= opsum_mux;
        end
    end
    
    // ipsum_reg
    reg [A_WIDTH-1:0] ipsum_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            ipsum_reg <= 0;
        end
        else begin
         ipsum_reg <= ipsum_mux;
        end
    end
    
    // ipsum_mux
    logic [A_WIDTH-1:0] ipsum_mux;
    always@(a_wire or ipsum_reg or D or E) begin
        if (E == 1) begin
            ipsum_mux <= ipsum;
        end
        else begin
            ipsum_mux <= ipsum_reg;
        end
    end
    
endmodule
