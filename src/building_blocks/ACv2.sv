`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 12/23/2017 09:45:40 PM
// Design Name: 
// Module Name: ACv2
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


module ACv2(
    // inputs
    clk,
    rst,
    ipsum,
    bn_param_in_en,
    bn_param_in,
    config_bits,
    in_en,
    F,
    // outputs
    data_out,
    data_out_en,
    bn_param_out,
    bn_param_out_en,
    );
    
    parameter IN_WIDTH = 32; // bitwidth of the input
    parameter ACC_WIDTH = 35; // bitwidth of the interal accumulate register
    parameter BN_SCALE_WIDTH = 16;
    parameter BN_SHIFT_WIDTH = 16;
    localparam BN_PARAM_WIDTH = BN_SCALE_WIDTH + BN_SHIFT_WIDTH; // bitwidth of the batch normalization parameters
    
    // inputs
    input logic clk, rst, in_en, F, bn_param_in_en;
    input [2:0] config_bits;
    input logic [IN_WIDTH-1:0] ipsum;
    input [BN_PARAM_WIDTH-1:0] bn_param_in;
    
    // outputs
    output [ACC_WIDTH-1:0] data_out;
    output logic [BN_PARAM_WIDTH-1:0] bn_param_out;
    output logic bn_param_out_en, data_out_en;
    
    // ipsum_reg
    logic [IN_WIDTH-1:0] ipsum_reg;
    always@(posedge clk) begin
        if (~rst) begin
            ipsum_reg <= 0;
        end
        else if (in_en) begin
            ipsum_reg <= ipsum;
        end
        else begin
            ipsum_reg <= 0;
        end
    end
    
    logic [ACC_WIDTH-1:0] add_node;
    
    // psum_reg
    logic [ACC_WIDTH-1:0] psum_reg;
    always@(posedge clk) begin
        if (~rst) begin
            psum_reg <= 0;
        end
        else begin
            psum_reg <= add_node;
        end
    end
    
    // in_en_dly
    logic in_en_dly;
    always@(posedge clk) begin
        in_en_dly <= in_en;
    end
    
    // psum_mux
    logic [ACC_WIDTH-1:0] psum_mux;
    assign psum_mux = (config_bits[2] & in_en_dly)? psum_reg:0;
    
    // add_node
    assign add_node = ipsum_reg + psum_mux;
    
    // bn_param_reg
    logic [BN_PARAM_WIDTH-1:0] bn_param_reg;
    always@(posedge clk) begin
        if (~rst) begin
            bn_param_reg <= 0;
        end
        else if (bn_param_in_en) begin
            bn_param_reg <= bn_param_in;
        end
    end
    
    // bn_scale
    logic [BN_SCALE_WIDTH-1:0] bn_scale;
    assign bn_scale = bn_param_reg[BN_PARAM_WIDTH-1:BN_PARAM_WIDTH-BN_SCALE_WIDTH];
    
    // bn_shift
    logic [BN_SHIFT_WIDTH-1:0] bn_shift;
    assign bn_shift = bn_param_reg[BN_SCALE_WIDTH-1:0];
    
    // bn_scale_node
    logic [BN_SCALE_WIDTH+ACC_WIDTH-1:0] bn_scale_node;
    assign bn_scale_node = add_node * bn_scale;
    
    // bn_shift_node
    logic [BN_SCALE_WIDTH+ACC_WIDTH:0] be_shift_node;
    assign be_shift_node = bn_scale_node + bn_shift;
    
    // bn_mux
    logic [BN_SCALE_WIDTH+ACC_WIDTH:0] bn_mux;
    assign bn_mux = (config_bits[0])? be_shift_node: add_node;
    
    // relu_node
    logic [BN_SCALE_WIDTH+ACC_WIDTH:0] relu_node;
    assign relu_node = ($signed(bn_mux) > $signed(0))? bn_mux: 0;
    
    // relu_mux
    logic [BN_SCALE_WIDTH+ACC_WIDTH:0] relu_mux;
    assign relu_mux = (config_bits[1])? relu_node: bn_mux;
    
    // data_out
    assign data_out = relu_mux;
    
    // data_out_en
    assign data_out_en = F;
    
    // bn_param_out_en
    always@(posedge clk) begin
        bn_param_out_en <= bn_param_in_en;
    end
    
    // bn_param_out
    always@(posedge clk) begin
        bn_param_out <= bn_param_in;
    end
    
endmodule
