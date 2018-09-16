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

module OBC(
	// inputs from PC
	clk_bus,
	rst_bus,
	w_req,
	w_req_en,
	tk_out_0,
	tk_out_1,
	// inputs from MIF
	mem2obc_en,
	// outputs to MIF
	obc2mem_w_addr,
	obc2mem_w_vld,
	obc2mem_w_data,
);

	parameter nPorts = 2;
	parameter wAddrWidth = 28;
	parameter wDataWidth = 64;
	parameter wReqWidth = 106;
	parameter wMaskWidth = 8;

	localparam FIFO_ASIZE = ($clog2(nPorts) > 2)? $clog2(nPorts) : 2;

	// inputs
	input clk_bus, rst_bus, w_req_en, mem2obc_en;
	input [wReqWidth-1:0] w_req;

	// outputs
	output tk_out_0;
	output tk_out_1;
	output [wAddrWidth-1:0] obc2mem_w_addr;
	output [wDataWidth-1:0] obc2mem_w_data;
	output obc2mem_w_vld;

	logic [wAddrWidth-1:0] pc2obc_addr;
	assign pc2obc_addr = w_req[wDataWidth+wMaskWidth+wAddrWidth-1:wDataWidth+wMaskWidth];

	logic [wDataWidth-1:0] pc2obc_data_mask;
	assign pc2obc_data_mask = w_req[wDataWidth+wMaskWidth-1:wDataWidth];

	logic [wDataWidth-1:0] pc2obc_data;
	assign pc2obc_data = w_req[wDataWidth-1:0];

	assign obc2mem_w_data = (fifo_sel)? obc2mem_data_1: obc2mem_data_2;

	assign obc2mem_w_addr = (fifo_sel)? obc2mem_addr_1: obc2mem_addr_2;

	assign obc2mem_w_vld = ~w_addr_fifo_empty;

	logic tk_count;
	always@(posedge clk_bus) begin
		if (~rst_bus) begin
			tk_count <= 0;
		end
		else if (~(w_addr_fifo_full_almost || w_addr_fifo_full)) begin
			tk_count = (tk_count < nPorts-1)? tk_count + 1 : 0;
		end
	end

	logic fifo_sel;
	always@(posedge clk_bus) begin
		if (~rst_bus) begin
			fifo_sel <= 0;
		end
		else if ((w_addr_fifo_full_almost || w_addr_fifo_full) && w_req_en && fifo_sel == 0) begin
			fifo_sel = ~fifo_sel;
		end
		else if ((w_addr_fifo_full_almost || w_addr_fifo_full) && w_req_en && fifo_sel == 1) begin
			fifo_sel = ~fifo_sel;
		end
	end

	logic w_addr_fifo_full;
	assign w_addr_fifo_full = (~fifo_sel)? w_addr_fifo_full_1: w_addr_fifo_full_2;

	logic w_addr_fifo_empty;
	assign w_addr_fifo_empty = (fifo_sel)? w_addr_fifo_empty_1: w_addr_fifo_empty_2;

	logic w_addr_fifo_full_almost;
	assign w_addr_fifo_full_almost = (~fifo_sel)? w_addr_fifo_full_almost_1: w_addr_fifo_full_almost_2;

	logic [wAddrWidth-1:0] pc2ibc_addr;
	assign obc2mem_addr = (fifo_sel)? obc2mem_addr_1: obc2mem_addr_2;

	// w_addr_fifo_1
	logic w_addr_fifo_full_1;
	logic w_addr_fifo_empty_1;
	logic w_addr_fifo_full_almost_1;
	logic mem2obc_addr_en_1;
	logic w_req_en_1;
	logic [wAddrWidth-1:0] obc2mem_addr_1;
	logic [wAddrWidth-1:0] pc2obc_addr_1;

	assign w_req_en_1 = (~fifo_sel)? w_req: 0;
	assign mem2obc_addr_en_1 = (fifo_sel)? mem2obc_en: 0;
	assign pc2obc_addr_1 = (~fifo_sel)? pc2obc_addr: 0;

	FIFO # (.DSIZE(wAddrWidth), .ASIZE(FIFO_ASIZE)) w_addr_fifo_1(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(w_req_en_1), .rinc(mem2obc_addr_en_1), .wfull(w_addr_fifo_full_1), .rempty(w_addr_fifo_empty_1), .wfull_almost(w_addr_fifo_full_almost_1), .rdata(obc2mem_addr_1), .wdata(pc2obc_addr_1));

	// w_addr_fifo_2
	logic w_addr_fifo_full_2;
	logic w_addr_fifo_empty_2;
	logic w_addr_fifo_full_almost_2;
	logic mem2obc_addr_en_2;
	logic w_req_en_2;
	logic [wAddrWidth-1:0] obc2mem_addr_2;
	logic [wAddrWidth-1:0] pc2obc_addr_2;

	assign w_req_en_2 = (fifo_sel)? w_req: 0;
	assign mem2obc_addr_en_2 = (~fifo_sel)? mem2obc_en: 0;
	assign pc2obc_addr_2 = (fifo_sel)? pc2obc_addr: 0;

	FIFO # (.DSIZE(wAddrWidth), .ASIZE(FIFO_ASIZE)) w_addr_fifo_2(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(w_req_en_2), .rinc(mem2obc_addr_en_2), .wfull(w_addr_fifo_full_2), .rempty(w_addr_fifo_empty_2), .wfull_almost(w_addr_fifo_full_almost_2), .rdata(obc2mem_addr_2), .wdata(pc2obc_addr_2));

	logic data_fifo_full;
	assign data_fifo_full = (~fifo_sel)? data_fifo_full_1: data_fifo_full_2;

	logic data_fifo_empty;
	assign data_fifo_empty = (~fifo_sel)? data_fifo_empty_1: data_fifo_empty_2;

	logic data_fifo_full_almost;
	assign data_fifo_full_almost = (~fifo_sel)? data_fifo_full_almost_1: data_fifo_full_almost_2;

	// data_fifo_1
	logic data_fifo_full_1;
	logic data_fifo_empty_1;
	logic data_fifo_full_almost_1;
	logic mem2obc_data_en_1;
	logic [wDataWidth-1:0] obc2mem_data_1;
	logic [wDataWidth-1:0] pc2obc_data_1;

	assign pc2obc_data_1 = (~fifo_sel)? pc2obc_data: 0;
	assign mem2obc_data_en_1 = (fifo_sel)? mem2obc_en: 0;

	FIFO # (.DSIZE(wReqWidth-wAddrWidth), .ASIZE(FIFO_ASIZE)) data_fifo_1(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(w_req_en_1), .rinc(mem2obc_data_en_1), .wfull(data_fifo_full_1), .rempty(data_fifo_empty_1), .wfull_almost(data_fifo_full_almost_1), .rdata(obc2mem_data_1), .wdata(pc2obc_data_1));

	// data_fifo_2
	logic data_fifo_full_2;
	logic data_fifo_empty_2;
	logic data_fifo_full_almost_2;
	logic mem2obc_data_en_2;
	logic [wDataWidth-1:0] obc2mem_data_2;
	logic [wDataWidth-1:0] pc2obc_data_2;

	assign pc2obc_data_2 = (fifo_sel)? pc2obc_data: 0;
	assign mem2obc_data_en_2 = (~fifo_sel)? mem2obc_en: 0;

	FIFO # (.DSIZE(wReqWidth-wAddrWidth), .ASIZE(FIFO_ASIZE)) data_fifo_2(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(w_req_en_2), .rinc(mem2obc_data_en_2), .wfull(data_fifo_full_2), .rempty(data_fifo_empty_2), .wfull_almost(data_fifo_full_almost_2), .rdata(obc2mem_data_2), .wdata(pc2obc_data_2));

	assign tk_out_0 = (tk_count == -1 && ~w_addr_fifo_full_almost && ~w_addr_fifo_full)? 1: 0;

	assign tk_out_1 = (tk_count == 0 && ~w_addr_fifo_full_almost && ~w_addr_fifo_full)? 1: 0;

endmodule
