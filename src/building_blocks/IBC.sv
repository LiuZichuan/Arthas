`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: Input Buffer Controller
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

module IBC(
	// inputs from PC
	clk_bus,
	rst_bus,
	r_req,
	r_req_en,
	// inputs from MIF
	mem2ibc_en,
	mem2ibc_data,
	mem2ibc_data_en,
	// outputs to MIF
	ibc2mem_r_addr,
	ibc2mem_r_vld,
	// outputs to PC
	ibc2pc_data,
	ibc2pc_data_en_0,
	ibc2pc_data_en_1,
	ibc2pc_data_en_2,
	ibc2pc_data_en_3,
	ibc2pc_data_en_4,
	ibc2pc_data_en_5,
	tk_out_0,
	tk_out_1,
	tk_out_2,
	tk_out_3,
	tk_out_4,
	tk_out_5,
);

	parameter nPorts = 6;
	parameter rAddrWidth = 28;
	parameter rDataWidth = 64;
	parameter rReqWidth = 31;

	localparam FIFO_ASIZE = ($clog2(nPorts) > 2)? $clog2(nPorts) : 2;

	// inputs
	input clk_bus, rst_bus, r_req_en, mem2ibc_data_en, mem2ibc_en;
	input [rReqWidth-1:0] r_req;
	input [rDataWidth-1:0] mem2ibc_data;

	// outputs
	output ibc2pc_data_en_0;
	output ibc2pc_data_en_1;
	output ibc2pc_data_en_2;
	output ibc2pc_data_en_3;
	output ibc2pc_data_en_4;
	output ibc2pc_data_en_5;
	output tk_out_0;
	output tk_out_1;
	output tk_out_2;
	output tk_out_3;
	output tk_out_4;
	output tk_out_5;
	output [rAddrWidth-1:0] ibc2mem_r_addr;
	output ibc2mem_r_vld;
	output [rDataWidth-1:0] ibc2pc_data;

	logic [rAddrWidth-1:0] pc2ibc_addr;
	assign pc2ibc_addr = r_req[rAddrWidth-1:0];

	logic [rReqWidth-rAddrWidth-1:0] p_id;
	assign p_id = r_req[rReqWidth-1:rAddrWidth];

	assign ibc2mem_r_addr = (fifo_sel)? ibc2mem_addr_1: ibc2mem_addr_2;

	assign ibc2mem_r_vld = ~r_addr_fifo_empty;

	logic fifo_sel;
	always@(posedge clk_bus) begin
		if (~rst_bus) begin
			fifo_sel <= 0;
		end
		else if ((r_addr_fifo_full_almost || r_addr_fifo_full) && r_req_en && fifo_sel == 0 && p_id_fifo_empty_2) begin
			fifo_sel = ~fifo_sel;
		end
		else if ((r_addr_fifo_full_almost || r_addr_fifo_full) && r_req_en && fifo_sel == 1 && p_id_fifo_empty_1) begin
			fifo_sel = ~fifo_sel;
		end
	end

	logic r_addr_fifo_full;
	assign r_addr_fifo_full = (~fifo_sel)? r_addr_fifo_full_1: r_addr_fifo_full_2;

	logic r_addr_fifo_empty;
	assign r_addr_fifo_empty = (fifo_sel)? r_addr_fifo_empty_1: r_addr_fifo_empty_2;

	logic r_addr_fifo_full_almost;
	assign r_addr_fifo_full_almost = (~fifo_sel)? r_addr_fifo_full_almost_1: r_addr_fifo_full_almost_2;

	assign pc2ibc_addr = (~fifo_sel)? pc2ibc_addr_1: pc2ibc_addr_2;

	// r_addr_fifo_1
	logic r_addr_fifo_full_1;
	logic r_addr_fifo_empty_1;
	logic r_addr_fifo_full_almost_1;
	logic ibc2mem_addr_en_1;
	logic r_req_en_1;
	logic [rAddrWidth-1:0] ibc2mem_addr_1;
	logic [rAddrWidth-1:0] pc2ibc_addr_1;

	assign r_req_en_1 = (~fifo_sel)? r_req: 0;
	assign ibc2mem_addr_en_1 = (fifo_sel)? mem2ibc_en: 0;

	FIFO # (.DSIZE(rAddrWidth), .ASIZE(FIFO_ASIZE)) r_addr_fifo_1(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(r_req_en_1), .rinc(ibc2mem_addr_en_1), .wfull(r_addr_fifo_full_1), .rempty(r_addr_fifo_empty_1), .wfull_almost(r_addr_fifo_full_almost_1), .rdata(ibc2mem_addr_1), .wdata(pc2ibc_addr_1));

	// r_addr_fifo_2
	logic r_addr_fifo_full_2;
	logic r_addr_fifo_empty_2;
	logic r_addr_fifo_full_almost_2;
	logic ibc2mem_addr_en_2;
	logic r_req_en_2;
	logic [rAddrWidth-1:0] ibc2mem_addr_2;
	logic [rAddrWidth-1:0] pc2ibc_addr_2;

	assign r_req_en_2 = (fifo_sel)? r_req: 0;
	assign ibc2mem_addr_en_2 = (~fifo_sel)? mem2ibc_en: 0;

	FIFO # (.DSIZE(rAddrWidth), .ASIZE(FIFO_ASIZE)) r_addr_fifo_2(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(r_req_en_2), .rinc(ibc2mem_addr_en_2), .wfull(r_addr_fifo_full_2), .rempty(r_addr_fifo_empty_2), .wfull_almost(r_addr_fifo_full_almost_2), .rdata(ibc2mem_addr_2), .wdata(pc2ibc_addr_2));

	logic p_id_fifo_full;
	assign p_id_fifo_full = (~fifo_sel)? p_id_fifo_full_1: p_id_fifo_full_2;

	logic p_id_fifo_empty;
	assign p_id_fifo_empty = (~fifo_sel)? p_id_fifo_empty_1: p_id_fifo_empty_2;

	logic p_id_fifo_full_almost;
	assign p_id_fifo_full_almost = (~fifo_sel)? p_id_fifo_full_almost_1: p_id_fifo_full_almost_2;

	logic [rReqWidth-rAddrWidth-1:0] ibc2pc_p_id;
	logic [rReqWidth-rAddrWidth-1:0] pc2ibc_p_id;
	assign pc2ibc_p_id = p_id;

	// p_id_fifo_1
	logic p_id_fifo_full_1;
	logic p_id_fifo_empty_1;
	logic p_id_fifo_full_almost_1;
	logic mem2ibc_data_en_1;
	logic [rReqWidth-rAddrWidth-1:0] ibc2pc_p_id_1;
	logic [rReqWidth-rAddrWidth-1:0] pc2ibc_p_id_1;

	assign pc2ibc_p_id_1 = (~fifo_sel)? pc2ibc_p_id: 0;
	assign mem2ibc_data_en_1 = (~fifo_sel)? mem2ibc_data_en: 0;

	FIFO # (.DSIZE(rReqWidth-rAddrWidth), .ASIZE(FIFO_ASIZE)) p_id_fifo_1(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(r_req_en_1), .rinc(mem2ibc_data_en_1), .wfull(p_id_fifo_full_1), .rempty(p_id_fifo_empty_1), .wfull_almost(p_id_fifo_full_almost_1), .rdata(ibc2pc_p_id_1), .wdata(pc2ibc_p_id_1));

	// p_id_fifo_2
	logic p_id_fifo_full_2;
	logic p_id_fifo_empty_2;
	logic p_id_fifo_full_almost_2;
	logic mem2ibc_data_en_2;
	logic [rReqWidth-rAddrWidth-1:0] ibc2pc_p_id_2;
	logic [rReqWidth-rAddrWidth-1:0] pc2ibc_p_id_2;

	assign pc2ibc_p_id_2 = (fifo_sel)? pc2ibc_p_id: 0;
	assign mem2ibc_data_en_2 = (fifo_sel)? mem2ibc_data_en: 0;

	FIFO # (.DSIZE(rReqWidth-rAddrWidth), .ASIZE(FIFO_ASIZE)) p_id_fifo_2(.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), .winc(r_req_en_2), .rinc(mem2ibc_data_en_2), .wfull(p_id_fifo_full_2), .rempty(p_id_fifo_empty_2), .wfull_almost(p_id_fifo_full_almost_2), .rdata(ibc2pc_p_id_2), .wdata(pc2ibc_p_id_2));

	logic [rReqWidth-rAddrWidth-1:0] tk_count;
	always@(posedge clk_bus) begin
		if (~rst_bus) begin
			tk_count <= 0;
		end
		else if (~p_id_fifo_full_almost) begin
			tk_count <= (tk_count < nPorts -1)? tk_count + 1 : 0;
		end
	end

	assign ibc2pc_data_en_0 = (ibc2pc_p_id == -1)? mem2ibc_data_en: 0;

	assign ibc2pc_data_en_1 = (ibc2pc_p_id == 0)? mem2ibc_data_en: 0;

	assign ibc2pc_data_en_2 = (ibc2pc_p_id == 1)? mem2ibc_data_en: 0;

	assign ibc2pc_data_en_3 = (ibc2pc_p_id == 2)? mem2ibc_data_en: 0;

	assign ibc2pc_data_en_4 = (ibc2pc_p_id == 3)? mem2ibc_data_en: 0;

	assign ibc2pc_data_en_5 = (ibc2pc_p_id == 4)? mem2ibc_data_en: 0;

	assign ibc2pc_data = mem2ibc_data;

	assign tk_out_0 = (tk_count == -1 && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;

	assign tk_out_1 = (tk_count == 0 && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;

	assign tk_out_2 = (tk_count == 1 && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;

	assign tk_out_3 = (tk_count == 2 && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;

	assign tk_out_4 = (tk_count == 3 && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;

	assign tk_out_5 = (tk_count == 4 && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;

endmodule
