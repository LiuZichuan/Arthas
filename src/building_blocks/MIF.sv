`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: Output Buffer Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies:
// 
// Revision: 0.1
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module MIF(
    start,
    // inputs from MIG
    clk_bus,
    rst_bus,
    app_rd_data,
    app_rd_data_end,
    app_rd_data_valid,
    app_rdy,
    app_wdf_rdy,
    // outputs to MIG    
    app_addr,
    app_cmd,
    app_en,
    app_wdf_data,
    app_wdf_end,
    app_wdf_mask,
    app_wdf_wren,
    // inputs from IBC
    ibc2mem_r_addr,
    ibc2mem_r_vld,
    // outputs to IBC
    mem2ibc_en,
    mem2ibc_data,
    mem2ibc_data_en,
    // inputs from OBC
    obc2mem_w_addr,
    obc2mem_w_vld,
    obc2mem_w_data,
    // output to OBC
    mem2obc_en,
);

	parameter rAddrWidth = 28;
	parameter rDataWidth = 64;
	parameter rReqWidth = 31;
	parameter wAddrWidth = 28;
    parameter wDataWidth = 64;
    parameter wReqWidth = 106;
    parameter wMaskWidth = 8;
    
    input start;
    
    // inputs from MIG
    input clk_bus, rst_bus;
    input  [63:0]      app_rd_data;
    input              app_rd_data_end;
    input              app_rd_data_valid;
    input              app_rdy;
    input              app_wdf_rdy;
    
    // outputs to MIG 
    output [27:0]      app_addr;
    output [2:0]       app_cmd;
    output             app_en;
    output [63:0]      app_wdf_data;
    output             app_wdf_end;
    output [7:0]       app_wdf_mask;
    output             app_wdf_wren;
    
    // inputs from IBC
    input [rAddrWidth-1:0] ibc2mem_r_addr;
    input ibc2mem_r_vld;
    
    // outputs to IBC
    output mem2ibc_en;
    output [rDataWidth-1:0] mem2ibc_data;
    output mem2ibc_data_en;
    
    // inputs from OBC
    input [wAddrWidth-1:0] obc2mem_w_addr;
    input obc2mem_w_vld;
    input [wDataWidth-1:0] obc2mem_w_data;
    
    // output to OBC
    output mem2obc_en;
    
    

endmodule