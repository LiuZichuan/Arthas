`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2017 08:45:07 PM
// Design Name: Arthas
// Module Name: PEv2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 2.0
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PEv2(
    // inputs
    clk,
    rst, 
    in_en,
    weight,
    feature,
    ipsum,
    iconfig,
    config_load,
    A,
    B,
    C,
    D,
    E,
    // outputs
    w_out,
    f_out,
    wf_en,
    opsum
    );
    parameter WIDTH = 16;
    
    localparam M_WIDTH = WIDTH*2;
    localparam A_WIDTH = M_WIDTH+1;
    
    // inputs
    input clk, rst, iconfig, config_load, in_en, A, B, C, D, E;
    input [WIDTH-1:0] weight, feature;
    input [A_WIDTH-1:0] ipsum;
    
    // outputs
    output logic [A_WIDTH-1:0] opsum;
    output logic [WIDTH-1:0] w_out, f_out;
    output logic wf_en;
    
    // PROCESSING UNITS
        
    // weight_reg
    logic [WIDTH-1:0] weight_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            weight_reg <= 0;
        end
        else if (A_mux && in_en) begin
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
        else if (B_mux && in_en) begin
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
    always@(psum_reg or C_mux) begin
        if (C_mux == 1) begin
            psum_mux <= psum_reg;
        end
        else begin
            psum_mux <= 0;
        end
    end
    
    // opsum_mux
    logic [A_WIDTH-1:0] opsum_mux;
    always@(a_wire or ipsum_reg or D_mux) begin
        if (D_mux == 1) begin
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
    
    // active
    logic active;
    always@(posedge clk) begin
        if (~rst) begin
            active <= 0;
        end
        else if (config_load) begin
            active <= iconfig;
        end
    end
    
    // ipsum_mux
    logic [A_WIDTH-1:0] ipsum_mux;
    always@(ipsum or ipsum_reg or E_mux) begin
        if (E_mux == 1) begin
            ipsum_mux <= ipsum;
        end
        else begin
            ipsum_mux <= 0;
        end
    end
    
    // A_mux
    wire A_mux;
    assign A_mux = (active)? A:0;
    
    // B_mux
    wire B_mux;
    assign B_mux = (active)? B:0;
    
    // C_mux
    wire C_mux;
    assign C_mux = (active)? C:0;
    
    // D_mux
    wire D_mux;
    assign D_mux = (active)? D:0;
    
    // E_mux
    wire E_mux;
    assign E_mux = (active)? E:0;
    
    // w_out
    assign w_out = weight_reg;
    
    // f_out
    assign f_out = feature_reg;
    
    // wf_en
    always@(posedge clk) begin
        wf_en <= in_en;
    end
        
endmodule
