`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 12/26/2017 04:57:43 PM
// Design Name: Arthas PEv3
// Module Name: PEv3
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


module PEv3(
    // inputs
    clk,
    rst, 
    in_en,
    data_horz,
    data_obli,
    data_vert,
    active,
    A,
    B,
    C,
    D,
    E,
    H,
    // outputs
    horz_out,
    obli_out,
    bypass_en,
    opsum
    );
    parameter iWIDTH = 16;
    parameter oWIDTH = 16;
    
//    localparam M_WIDTH = WIDTH*2;
//    localparam A_WIDTH = M_WIDTH+1;
    localparam M_WIDTH = oWIDTH;
    localparam A_WIDTH = oWIDTH;
    
    // inputs
    input clk, rst, active, in_en, A, B, C, D, E, H;
    input [iWIDTH-1:0] data_horz, data_obli;
    input [A_WIDTH-1:0] data_vert;
    
    // outputs
    output logic [A_WIDTH-1:0] opsum;
    output logic [iWIDTH-1:0] horz_out, obli_out;
    output logic bypass_en;
    
    // PROCESSING UNITS
        
    // data_a_reg
    logic [iWIDTH-1:0] data_a_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            data_a_reg <= 0;
        end
        else if (A_mux && in_en) begin
            data_a_reg <= data_horz;
        end
        else begin
            data_a_reg <= 0;
        end
    end
    
    // data_b_reg
    logic [iWIDTH-1:0] data_b_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            data_b_reg <= 0;
        end
        else if (B_mux && in_en) begin
            data_b_reg <= (H_mux)? data_vert[iWIDTH-1:0]: data_obli;
        end 
        else begin
            data_b_reg <= 0;
        end
    end
    
    // m_reg
    reg [M_WIDTH-1:0] m_reg;
    always@(posedge clk) begin
        if (rst == 0) begin
            m_reg <= 0;
        end
        else begin
            m_reg <= data_a_reg * data_b_reg;
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
    always@(a_wire or data_vert_mux or D_mux) begin
        if (D_mux == 1) begin
            opsum_mux <= a_wire;
        end
        else begin
            opsum_mux <= data_vert_mux;
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
    
    
    // data_vert_mux
    logic [A_WIDTH-1:0] data_vert_mux;
    always@(data_vert or E_mux) begin
        if (E_mux == 1) begin
            data_vert_mux <= data_vert;
        end
        else begin
            data_vert_mux <= 0;
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
//    assign E_mux = (active)? E:0;
    assign E_mux = E;
    
    // H_mux
    wire H_mux;
    assign H_mux = (active)? H:0;
    
    // horz_out
    assign horz_out = data_a_reg;
    
    // obli_out
    assign obli_out = data_b_reg;
    
    // bypass_en
    always@(posedge clk) begin
        bypass_en <= in_en;
    end
    
endmodule
