`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: SystolicArray_v2
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

module SystolicArray_v2(
	// inputs
	clk,
	clk_mem,
	rst,
	start,
	data_obli_in_en_1,
	data_obli_in_en_2,
	data_obli_in_en_3,
	data_obli_in_en_4,
	data_obli_in_en_5,
	data_obli_in_en_6,
	mode_conv_mm,
	isac,
	isrelu,
	isbn,
	dfsm_config,
	ssp_config,
	quabuf_config,
	singbuf_config,
	pe_config_1_1,
	pe_config_1_2,
	pe_config_1_3,
	pe_config_2_1,
	pe_config_2_2,
	pe_config_2_3,
	data_horz_1_1,
	data_horz_1_2,
	data_horz_1_3,
	data_horz_2_1,
	data_horz_2_2,
	data_horz_2_3,
	data_horz_in_en_1_1,
	data_horz_in_en_1_2,
	data_horz_in_en_1_3,
	data_horz_in_en_2_1,
	data_horz_in_en_2_2,
	data_horz_in_en_2_3,
	data_obli_1,
	data_obli_2,
	data_obli_3,
	data_obli_4,
	data_obli_5,
	data_obli_6,
	data_bn_1,
	data_bn_2,
	data_bn_wrdy_1,
	data_bn_wrdy_2,
	data_bn_we_1,
	data_bn_we_2,
	// outputs
	dout_1,
	dout_2,
	dout_en_1,
	dout_en_2,
	data_obli_wrdy_1,
	data_obli_wrdy_2,
	data_obli_wrdy_3,
	data_obli_wrdy_4,
	data_obli_wrdy_5,
	data_obli_wrdy_6,
	data_horz_wrdy_1_1,
	data_horz_wrdy_1_2,
	data_horz_wrdy_1_3,
	data_horz_wrdy_2_1,
	data_horz_wrdy_2_2,
	data_horz_wrdy_2_3,
);
	parameter nBanks = 2;
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 8;
	parameter oWidth = 8;
	parameter DFSM_MAX_nPERIOD = 512;
	parameter DFSM_MAX_nLMAC = 3072;
	parameter DFSM_MAX_nSHFT = 3;
	parameter SSP_MAX_nPeriod = 262144;
	parameter QUABUF_MAX_nDATA = 1024;
	parameter QUABUF_MAX_nCOL = 3;
	parameter QUABUF_MAX_nPERIOD = 65536;
	parameter QUABUF_MAX_nREP = 1024;
	parameter SINGBUF_MAX_nPERIOD = 65536;
	parameter SINGBUF_MAX_nDATA = 1024;

	localparam SSP_MAX_nData = nCols;
	localparam DFSM_CONFIGBIT_WIDTH = $clog2(DFSM_MAX_nPERIOD) + $clog2(DFSM_MAX_nLMAC) + $clog2(DFSM_MAX_nSHFT);
	localparam SSP_CONFIGBIT_WIDTH = $clog2(SSP_MAX_nData) + $clog2(SSP_MAX_nPeriod);
	localparam QUABUF_CONFIGBIT_WIDTH = $clog2(QUABUF_MAX_nDATA) + $clog2(QUABUF_MAX_nCOL) + $clog2(QUABUF_MAX_nREP) + $clog2(QUABUF_MAX_nPERIOD);
	localparam SINGBUF_CONFIGBIT_WIDTH = $clog2(SINGBUF_MAX_nDATA) + $clog2(SINGBUF_MAX_nPERIOD);
	localparam MODE_CONV = 0; localparam MODE_MM = 1;

	// inputs
	input clk, clk_mem, rst, start,  mode_conv_mm, isac, isrelu, isbn;
	input [DFSM_CONFIGBIT_WIDTH-1:0] dfsm_config;
	input [SSP_CONFIGBIT_WIDTH-1:0] ssp_config;
	input [QUABUF_CONFIGBIT_WIDTH-1:0] quabuf_config;
	input [SINGBUF_CONFIGBIT_WIDTH-1:0] singbuf_config;
	input data_obli_in_en_1;
	input data_obli_in_en_2;
	input data_obli_in_en_3;
	input data_obli_in_en_4;
	input data_obli_in_en_5;
	input data_obli_in_en_6;
	input pe_config_1_1;
	input pe_config_1_2;
	input pe_config_1_3;
	input pe_config_2_1;
	input pe_config_2_2;
	input pe_config_2_3;
	input [7:0] data_horz_1_1;
	input [7:0] data_horz_1_2;
	input [7:0] data_horz_1_3;
	input [7:0] data_horz_2_1;
	input [7:0] data_horz_2_2;
	input [7:0] data_horz_2_3;
	input data_horz_in_en_1_1;
	input data_horz_in_en_1_2;
	input data_horz_in_en_1_3;
	input data_horz_in_en_2_1;
	input data_horz_in_en_2_2;
	input data_horz_in_en_2_3;
	input [7:0] data_obli_1;
	input [7:0] data_obli_2;
	input [7:0] data_obli_3;
	input [7:0] data_obli_4;
	input [7:0] data_obli_5;
	input [7:0] data_obli_6;
	input [15:0] data_bn_1;
	input [15:0] data_bn_2;
	input data_bn_we_1;
	input data_bn_we_2;

	// outputs
	output [7:0] dout_1;
	output [7:0] dout_2;
	output dout_en_1;
	output dout_en_2;
	output data_obli_wrdy_1;
	output data_obli_wrdy_2;
	output data_obli_wrdy_3;
	output data_obli_wrdy_4;
	output data_obli_wrdy_5;
	output data_obli_wrdy_6;
	output data_horz_wrdy_1_1;
	output data_horz_wrdy_1_2;
	output data_horz_wrdy_1_3;
	output data_horz_wrdy_2_1;
	output data_horz_wrdy_2_2;
	output data_horz_wrdy_2_3;
	output data_bn_wrdy_1;
	output data_bn_wrdy_2;

	logic A_1;
	logic A_2;
	logic A_3;
	logic A_4;
	logic B_1;
	logic B_2;
	logic B_3;
	logic B_4;
	logic C_1;
	logic C_2;
	logic C_3;
	logic C_4;
	logic D_1;
	logic D_2;
	logic D_3;
	logic D_4;
	logic E_1;
	logic E_2;
	logic E_3;
	logic E_4;
	logic F_1;
	logic F_2;
	logic F_3;
	logic F_4;
	logic G_1;
	logic G_2;
	logic G_3;
	logic G_4;
	logic H_1;
	logic H_2;
	logic H_3;
	logic H_4;

	logic [7:0] data_obli_buf_1;
	logic [7:0] data_obli_buf_2;
	logic [7:0] data_obli_buf_3;
	logic [7:0] data_obli_buf_4;
	logic [7:0] data_obli_buf_5;
	logic [7:0] data_obli_buf_6;

	logic [7:0] data_horz_buf_1_1;
	logic [7:0] data_horz_buf_1_2;
	logic [7:0] data_horz_buf_1_3;
	logic [7:0] data_horz_buf_2_1;
	logic [7:0] data_horz_buf_2_2;
	logic [7:0] data_horz_buf_2_3;

	logic data_obli_rrdy_1;
	logic data_obli_rrdy_2;
	logic data_obli_rrdy_3;
	logic data_obli_rrdy_4;
	logic data_obli_rrdy_5;
	logic data_obli_rrdy_6;

	logic dfsm_data_en_1;
	logic dfsm_data_en_2;
	logic dfsm_data_en_3;
	logic dfsm_data_en_4;

	logic start_bypass_1;
	logic start_bypass_2;
	logic start_bypass_3;
	logic start_bypass_4;

	logic quabuf_re_mux_1;
	logic quabuf_re_mux_2;
	logic quabuf_re_mux_3;
	logic quabuf_re_mux_4;
	logic quabuf_re_mux_5;
	logic quabuf_re_mux_6;

	logic data_horz_rrdy_1_1;
	logic data_horz_rrdy_1_2;
	logic data_horz_rrdy_1_3;
	logic data_horz_rrdy_2_1;
	logic data_horz_rrdy_2_2;
	logic data_horz_rrdy_2_3;

	logic horz_fifo_empty_1_1;
	logic horz_fifo_empty_1_2;
	logic horz_fifo_empty_1_3;
	logic horz_fifo_empty_2_1;
	logic horz_fifo_empty_2_2;
	logic horz_fifo_empty_2_3;

	logic [7:0]dout_vert_1_1;
	logic [7:0]dout_vert_1_2;
	logic [7:0]dout_vert_1_3;
	logic [7:0]dout_vert_1_4;
	logic [7:0]dout_vert_2_1;
	logic [7:0]dout_vert_2_2;
	logic [7:0]dout_vert_2_3;
	logic [7:0]dout_vert_2_4;

	logic [31:0] dout_vert_buf_1;
	logic [31:0] dout_vert_buf_2;

	logic vert_fifo_full_1_1;
	logic vert_fifo_full_1_2;
	logic vert_fifo_full_1_3;
	logic vert_fifo_full_1_4;
	logic vert_fifo_full_2_1;
	logic vert_fifo_full_2_2;
	logic vert_fifo_full_2_3;
	logic vert_fifo_full_2_4;

	logic vert_fifo_full_almost_1_1;
	logic vert_fifo_full_almost_1_2;
	logic vert_fifo_full_almost_1_3;
	logic vert_fifo_full_almost_1_4;
	logic vert_fifo_full_almost_2_1;
	logic vert_fifo_full_almost_2_2;
	logic vert_fifo_full_almost_2_3;
	logic vert_fifo_full_almost_2_4;

	logic vert_fifo_re_1_1;
	logic vert_fifo_re_1_2;
	logic vert_fifo_re_1_3;
	logic vert_fifo_re_1_4;
	logic vert_fifo_re_2_1;
	logic vert_fifo_re_2_2;
	logic vert_fifo_re_2_3;
	logic vert_fifo_re_2_4;

	logic vert_fifo_we_1_1;
	logic vert_fifo_we_1_2;
	logic vert_fifo_we_1_3;
	logic vert_fifo_we_1_4;
	logic vert_fifo_we_2_1;
	logic vert_fifo_we_2_2;
	logic vert_fifo_we_2_3;
	logic vert_fifo_we_2_4;

	logic vert_fifo_empty_1_1;
	logic vert_fifo_empty_1_2;
	logic vert_fifo_empty_1_3;
	logic vert_fifo_empty_1_4;
	logic vert_fifo_empty_2_1;
	logic vert_fifo_empty_2_2;
	logic vert_fifo_empty_2_3;
	logic vert_fifo_empty_2_4;

	logic horz_fifo_full_1_1;
	logic horz_fifo_full_1_2;
	logic horz_fifo_full_1_3;
	logic horz_fifo_full_2_1;
	logic horz_fifo_full_2_2;
	logic horz_fifo_full_2_3;

	logic quabuf_re;

	logic horz_fifo_re;

	logic data_bn_re;
	always@(posedge clk) begin
		if (~rst) begin
			data_bn_re <= 0;
		end
		else begin
			data_bn_re <= G_1 & data_bn_rrdy_1 & data_bn_rrdy_2 & 1;
		end
	end

	logic data_bn_en;
	always@(posedge clk) begin
		if (~rst) begin
			data_bn_en <= 0;
		end
		else begin
			data_bn_en <= data_bn_re;
		end
	end

	logic data_bn_rrdy_1;
	logic data_bn_rrdy_2;

	logic [15:0] data_bn_buf_1;
	logic [15:0] data_bn_buf_2;

	reg [2:0] quabuf_re_dly;
	always@(posedge clk) begin
		if (~rst) begin
			quabuf_re_dly <= 0;
		end
		else begin
			quabuf_re_dly <= {quabuf_re_dly[1:0], quabuf_re};
		end
	end

	logic vert_shifter_load_1;

	assign vert_shifter_load_1 = ~vert_fifo_empty_1_1 & ~vert_fifo_empty_1_2 & ~vert_fifo_empty_1_3 & ~vert_fifo_empty_1_4 & ~shifting_1;

	assign vert_fifo_re_1_1 = vert_shifter_load_1;
	assign vert_fifo_re_1_2 = vert_shifter_load_1;
	assign vert_fifo_re_1_3 = vert_shifter_load_1;
	assign vert_fifo_re_1_4 = vert_shifter_load_1;

	reg [31:0] dout_vert_shifter_1;
	always@(posedge clk) begin
		if (~rst) begin
			dout_vert_shifter_1 <= 0;
		end
		else if (vert_shifter_load_1) begin
			dout_vert_shifter_1 <= dout_vert_buf_1;
		end
		else if (shifting_1) begin
			dout_vert_shifter_1 <= {8'd0, dout_vert_shifter_1[31:8]};
		end
	end

	logic shifting_1;
	always@(posedge clk) begin
		if (~rst) begin
			shifting_1 <= 0;
		end
		else if (vert_shifter_load_1) begin
			shifting_1 <= 1;
		end
		else if (shift_count_1 == 3) begin
			shifting_1 <= 0;
		end
	end

	logic [$clog2(nCols)-1:0] shift_count_1;
	always@(posedge clk) begin
		if (~rst) begin
			shift_count_1 <= 0;
		end
		else if (vert_shifter_load_1 || shifting_1) begin
			shift_count_1 <= (shift_count_1 < 3)? (shift_count_1 + 1): 0;
		end
	end

	assign ssp_data_in_en_1 = shifting_1 | vert_shifter_load_1;

	logic vert_shifter_load_2;

	assign vert_shifter_load_2 = ~vert_fifo_empty_2_1 & ~vert_fifo_empty_2_2 & ~vert_fifo_empty_2_3 & ~vert_fifo_empty_2_4 & ~shifting_2;

	assign vert_fifo_re_2_1 = vert_shifter_load_2;
	assign vert_fifo_re_2_2 = vert_shifter_load_2;
	assign vert_fifo_re_2_3 = vert_shifter_load_2;
	assign vert_fifo_re_2_4 = vert_shifter_load_2;

	reg [31:0] dout_vert_shifter_2;
	always@(posedge clk) begin
		if (~rst) begin
			dout_vert_shifter_2 <= 0;
		end
		else if (vert_shifter_load_2) begin
			dout_vert_shifter_2 <= dout_vert_buf_2;
		end
		else if (shifting_2) begin
			dout_vert_shifter_2 <= {8'd0, dout_vert_shifter_2[31:8]};
		end
	end

	logic shifting_2;
	always@(posedge clk) begin
		if (~rst) begin
			shifting_2 <= 0;
		end
		else if (vert_shifter_load_2) begin
			shifting_2 <= 1;
		end
		else if (shift_count_2 == 3) begin
			shifting_2 <= 0;
		end
	end

	logic [$clog2(nCols)-1:0] shift_count_2;
	always@(posedge clk) begin
		if (~rst) begin
			shift_count_2 <= 0;
		end
		else if (vert_shifter_load_2 || shifting_2) begin
			shift_count_2 <= (shift_count_2 < 3)? (shift_count_2 + 1): 0;
		end
	end

	assign ssp_data_in_en_2 = shifting_2 | vert_shifter_load_2;

	assign data_horz_wrdy_1_1 = ~horz_fifo_full_almost_1_1;
	assign data_horz_wrdy_1_2 = ~horz_fifo_full_almost_1_2;
	assign data_horz_wrdy_1_3 = ~horz_fifo_full_almost_1_3;
	assign data_horz_wrdy_2_1 = ~horz_fifo_full_almost_2_1;
	assign data_horz_wrdy_2_2 = ~horz_fifo_full_almost_2_2;
	assign data_horz_wrdy_2_3 = ~horz_fifo_full_almost_2_3;

	assign quabuf_re_mux_1 = (mode_conv_mm == MODE_CONV)? quabuf_re: 0;
	assign quabuf_re_mux_2 = (mode_conv_mm == MODE_CONV)? quabuf_re: 0;
	assign quabuf_re_mux_3 = quabuf_re;
	assign quabuf_re_mux_4 = (mode_conv_mm == MODE_CONV)? quabuf_re_dly[0]: 0;
	assign quabuf_re_mux_5 = (mode_conv_mm == MODE_CONV)? quabuf_re_dly[1]: 0;
	assign quabuf_re_mux_6 = (mode_conv_mm == MODE_CONV)? quabuf_re_dly[2]: 0;

	assign data_horz_rrdy_1_1 = ~horz_fifo_empty_1_1;
	assign data_horz_rrdy_1_2 = ~horz_fifo_empty_1_2;
	assign data_horz_rrdy_1_3 = ~horz_fifo_empty_1_3;
	assign data_horz_rrdy_2_1 = ~horz_fifo_empty_2_1;
	assign data_horz_rrdy_2_2 = ~horz_fifo_empty_2_2;
	assign data_horz_rrdy_2_3 = ~horz_fifo_empty_2_3;

	logic all_data_rdy;
	logic data_preread;
	assign all_data_rdy = data_horz_rrdy_1_1 & data_horz_rrdy_1_2 & data_horz_rrdy_1_3 & data_horz_rrdy_2_1 & data_horz_rrdy_2_2 & data_horz_rrdy_2_3 & data_obli_rrdy_1 & data_obli_rrdy_2 & data_obli_rrdy_3 & data_obli_rrdy_4 & data_obli_rrdy_5 & data_obli_rrdy_6 & 1;
	assign quabuf_re = data_preread;
	assign horz_fifo_re = data_preread;

	logic array_data_en;
	always@(posedge clk) begin
		if (~rst) begin
			array_data_en <= 0;
		end
		else begin
			array_data_en <= data_preread;
		end
	end

	SystolicBank_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nRows(nRows), .nCols(nCols)) bank_1(.clk(clk), .rst(rst), .in_en(array_data_en), .conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), .bn_param_in_en(data_bn_en), .bn_param_in(data_bn_buf_1),.active_1(pe_config_1_1), .active_2(pe_config_1_2), .active_3(pe_config_1_3), .data_in_horz_1(data_horz_buf_1_1), .data_in_horz_2(data_horz_buf_1_2), .data_in_horz_3(data_horz_buf_1_3), .data_in_obli_1(data_obli_buf_1), .data_in_obli_2(data_obli_buf_2), .data_in_obli_3(data_obli_buf_3), .data_in_obli_4(data_obli_buf_4), .data_in_obli_5(data_obli_buf_5), .data_in_obli_6(data_obli_buf_6), .A_1(A_1), .A_2(A_2), .A_3(A_3), .A_4(A_4), .B_1(B_1), .B_2(B_2), .B_3(B_3), .B_4(B_4), .C_1(C_1), .C_2(C_2), .C_3(C_3), .C_4(C_4), .D_1(D_1), .D_2(D_2), .D_3(D_3), .D_4(D_4), .E_1(E_1), .E_2(E_2), .E_3(E_3), .E_4(E_4), .F_1(F_1), .F_2(F_2), .F_3(F_3), .F_4(F_4), .G_1(G_1), .G_2(G_2), .G_3(G_3), .G_4(G_4), .H_1(H_1), .H_2(H_2), .H_3(H_3), .H_4(H_4), .dout_en_1(vert_fifo_we_1_1), .dout_en_2(vert_fifo_we_1_2), .dout_en_3(vert_fifo_we_1_3), .dout_en_4(vert_fifo_we_1_4), .dout_1(dout_vert_1_1), .dout_2(dout_vert_1_2), .dout_3(dout_vert_1_3), .dout_4(dout_vert_1_4));
	SystolicBank_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nRows(nRows), .nCols(nCols)) bank_2(.clk(clk), .rst(rst), .in_en(array_data_en), .conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), .bn_param_in_en(data_bn_en), .bn_param_in(data_bn_buf_2),.active_1(pe_config_2_1), .active_2(pe_config_2_2), .active_3(pe_config_2_3), .data_in_horz_1(data_horz_buf_2_1), .data_in_horz_2(data_horz_buf_2_2), .data_in_horz_3(data_horz_buf_2_3), .data_in_obli_1(data_obli_buf_1), .data_in_obli_2(data_obli_buf_2), .data_in_obli_3(data_obli_buf_3), .data_in_obli_4(data_obli_buf_4), .data_in_obli_5(data_obli_buf_5), .data_in_obli_6(data_obli_buf_6), .A_1(A_1), .A_2(A_2), .A_3(A_3), .A_4(A_4), .B_1(B_1), .B_2(B_2), .B_3(B_3), .B_4(B_4), .C_1(C_1), .C_2(C_2), .C_3(C_3), .C_4(C_4), .D_1(D_1), .D_2(D_2), .D_3(D_3), .D_4(D_4), .E_1(E_1), .E_2(E_2), .E_3(E_3), .E_4(E_4), .F_1(F_1), .F_2(F_2), .F_3(F_3), .F_4(F_4), .G_1(G_1), .G_2(G_2), .G_3(G_3), .G_4(G_4), .H_1(H_1), .H_2(H_2), .H_3(H_3), .H_4(H_4), .dout_en_1(vert_fifo_we_2_1), .dout_en_2(vert_fifo_we_2_2), .dout_en_3(vert_fifo_we_2_3), .dout_en_4(vert_fifo_we_2_4), .dout_1(dout_vert_2_1), .dout_2(dout_vert_2_2), .dout_3(dout_vert_2_3), .dout_4(dout_vert_2_4));

	DFSMv3 # (.MAX_nPERIOD(DFSM_MAX_nPERIOD), .MAX_nLMAC(DFSM_MAX_nLMAC), .MAX_nSHFT(DFSM_MAX_nSHFT)) fsm_1(.clk(clk), .rst(rst), .config_bits({mode_conv_mm, dfsm_config}), .all_data_rdy(all_data_rdy), .in_en(array_data_en), .start(start), .data_preread(data_preread), .in_en_bypass(dfsm_data_en_1), .start_out(start_bypass_1), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .F(F_1), .G(G_1), .H(H_1));
	DFSMv2 # (.MAX_nPERIOD(DFSM_MAX_nPERIOD), .MAX_nLMAC(DFSM_MAX_nLMAC), .MAX_nSHFT(DFSM_MAX_nSHFT)) fsm_2(.clk(clk), .rst(rst), .config_bits({mode_conv_mm, dfsm_config}), .in_en(dfsm_data_en_1), .start(start_bypass_1), .in_en_bypass(dfsm_data_en_2), .start_out(start_bypass_2), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .F(F_2), .G(G_2), .H(H_2));
	DFSMv2 # (.MAX_nPERIOD(DFSM_MAX_nPERIOD), .MAX_nLMAC(DFSM_MAX_nLMAC), .MAX_nSHFT(DFSM_MAX_nSHFT)) fsm_3(.clk(clk), .rst(rst), .config_bits({mode_conv_mm, dfsm_config}), .in_en(dfsm_data_en_2), .start(start_bypass_2), .in_en_bypass(dfsm_data_en_3), .start_out(start_bypass_3), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .F(F_3), .G(G_3), .H(H_3));
	DFSMv2 # (.MAX_nPERIOD(DFSM_MAX_nPERIOD), .MAX_nLMAC(DFSM_MAX_nLMAC), .MAX_nSHFT(DFSM_MAX_nSHFT)) fsm_4(.clk(clk), .rst(rst), .config_bits({mode_conv_mm, dfsm_config}), .in_en(dfsm_data_en_3), .start(start_bypass_3), .in_en_bypass(dfsm_data_en_4), .start_out(start_bypass_4), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .F(F_4), .G(G_4), .H(H_4));

	QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_1(.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), .data_in(data_obli_1), .we(data_obli_in_en_1), .re(quabuf_re_mux_1), .wrdy(data_obli_wrdy_1), .rrdy(data_obli_rrdy_1), .data_out(data_obli_buf_1));
	QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_2(.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), .data_in(data_obli_2), .we(data_obli_in_en_2), .re(quabuf_re_mux_2), .wrdy(data_obli_wrdy_2), .rrdy(data_obli_rrdy_2), .data_out(data_obli_buf_2));
	QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_3(.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), .data_in(data_obli_3), .we(data_obli_in_en_3), .re(quabuf_re_mux_3), .wrdy(data_obli_wrdy_3), .rrdy(data_obli_rrdy_3), .data_out(data_obli_buf_3));
	QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_4(.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), .data_in(data_obli_4), .we(data_obli_in_en_4), .re(quabuf_re_mux_4), .wrdy(data_obli_wrdy_4), .rrdy(data_obli_rrdy_4), .data_out(data_obli_buf_4));
	QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_5(.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), .data_in(data_obli_5), .we(data_obli_in_en_5), .re(quabuf_re_mux_5), .wrdy(data_obli_wrdy_5), .rrdy(data_obli_rrdy_5), .data_out(data_obli_buf_5));
	QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_6(.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), .data_in(data_obli_6), .we(data_obli_in_en_6), .re(quabuf_re_mux_6), .wrdy(data_obli_wrdy_6), .rrdy(data_obli_rrdy_6), .data_out(data_obli_buf_6));

	FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_1_1(.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(data_horz_in_en_1_1), .rinc(horz_fifo_re), .wfull(horz_fifo_full_1_1), .rempty(horz_fifo_empty_1_1), .wfull_almost(horz_fifo_full_almost_1_1), .rdata(data_horz_buf_1_1), .wdata(data_horz_1_1));
	FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_1_2(.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(data_horz_in_en_1_2), .rinc(horz_fifo_re), .wfull(horz_fifo_full_1_2), .rempty(horz_fifo_empty_1_2), .wfull_almost(horz_fifo_full_almost_1_2), .rdata(data_horz_buf_1_2), .wdata(data_horz_1_2));
	FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_1_3(.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(data_horz_in_en_1_3), .rinc(horz_fifo_re), .wfull(horz_fifo_full_1_3), .rempty(horz_fifo_empty_1_3), .wfull_almost(horz_fifo_full_almost_1_3), .rdata(data_horz_buf_1_3), .wdata(data_horz_1_3));
	FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_2_1(.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(data_horz_in_en_2_1), .rinc(horz_fifo_re), .wfull(horz_fifo_full_2_1), .rempty(horz_fifo_empty_2_1), .wfull_almost(horz_fifo_full_almost_2_1), .rdata(data_horz_buf_2_1), .wdata(data_horz_2_1));
	FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_2_2(.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(data_horz_in_en_2_2), .rinc(horz_fifo_re), .wfull(horz_fifo_full_2_2), .rempty(horz_fifo_empty_2_2), .wfull_almost(horz_fifo_full_almost_2_2), .rdata(data_horz_buf_2_2), .wdata(data_horz_2_2));
	FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_2_3(.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(data_horz_in_en_2_3), .rinc(horz_fifo_re), .wfull(horz_fifo_full_2_3), .rempty(horz_fifo_empty_2_3), .wfull_almost(horz_fifo_full_almost_2_3), .rdata(data_horz_buf_2_3), .wdata(data_horz_2_3));

	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_1_1(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_1_1), .rinc(vert_fifo_re_1_1), .wfull(vert_fifo_full_1_1), .rempty(vert_fifo_empty_1_1), .wfull_almost(vert_fifo_full_almost_1_1), .rdata(dout_vert_buf_1[31:24]), .wdata(dout_vert_1_1));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_1_2(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_1_2), .rinc(vert_fifo_re_1_2), .wfull(vert_fifo_full_1_2), .rempty(vert_fifo_empty_1_2), .wfull_almost(vert_fifo_full_almost_1_2), .rdata(dout_vert_buf_1[23:16]), .wdata(dout_vert_1_2));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_1_3(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_1_3), .rinc(vert_fifo_re_1_3), .wfull(vert_fifo_full_1_3), .rempty(vert_fifo_empty_1_3), .wfull_almost(vert_fifo_full_almost_1_3), .rdata(dout_vert_buf_1[15:8]), .wdata(dout_vert_1_3));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_1_4(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_1_4), .rinc(vert_fifo_re_1_4), .wfull(vert_fifo_full_1_4), .rempty(vert_fifo_empty_1_4), .wfull_almost(vert_fifo_full_almost_1_4), .rdata(dout_vert_buf_1[7:0]), .wdata(dout_vert_1_4));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_2_1(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_2_1), .rinc(vert_fifo_re_2_1), .wfull(vert_fifo_full_2_1), .rempty(vert_fifo_empty_2_1), .wfull_almost(vert_fifo_full_almost_2_1), .rdata(dout_vert_buf_2[31:24]), .wdata(dout_vert_2_1));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_2_2(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_2_2), .rinc(vert_fifo_re_2_2), .wfull(vert_fifo_full_2_2), .rempty(vert_fifo_empty_2_2), .wfull_almost(vert_fifo_full_almost_2_2), .rdata(dout_vert_buf_2[23:16]), .wdata(dout_vert_2_2));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_2_3(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_2_3), .rinc(vert_fifo_re_2_3), .wfull(vert_fifo_full_2_3), .rempty(vert_fifo_empty_2_3), .wfull_almost(vert_fifo_full_almost_2_3), .rdata(dout_vert_buf_2[15:8]), .wdata(dout_vert_2_3));
	FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_2_4(.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), .winc(vert_fifo_we_2_4), .rinc(vert_fifo_re_2_4), .wfull(vert_fifo_full_2_4), .rempty(vert_fifo_empty_2_4), .wfull_almost(vert_fifo_full_almost_2_4), .rdata(dout_vert_buf_2[7:0]), .wdata(dout_vert_2_4));

	SSP # (.WIDTH(oWidth), .MAX_nData(SSP_MAX_nData), .MAX_nPeriod(SSP_MAX_nPeriod)) ssp_1(.clk(clk), .rst(rst), .config_bits(ssp_config), .start(start), .data_in_en(ssp_data_in_en_1), .data_in(dout_vert_shifter_1[7:0]), .data_out(dout_1), .data_out_en(dout_en_1));
	SSP # (.WIDTH(oWidth), .MAX_nData(SSP_MAX_nData), .MAX_nPeriod(SSP_MAX_nPeriod)) ssp_2(.clk(clk), .rst(rst), .config_bits(ssp_config), .start(start), .data_in_en(ssp_data_in_en_2), .data_in(dout_vert_shifter_2[7:0]), .data_out(dout_2), .data_out_en(dout_en_2));

	SINGBUFv1 # (.DATA_WIDTH(2*oWidth), .MAX_nDATA(SINGBUF_MAX_nDATA), .MAX_nPERIOD(SINGBUF_MAX_nPERIOD)) singbuf_1(.clk(clk), .rst(rst), .config_bits(singbuf_config), .start(start), .we(data_bn_we_1), .re(data_bn_re), .data_in(data_bn_1), .wrdy(data_bn_wrdy_1), .rrdy(data_bn_rrdy_1), .data_out(data_bn_buf_1));
	SINGBUFv1 # (.DATA_WIDTH(2*oWidth), .MAX_nDATA(SINGBUF_MAX_nDATA), .MAX_nPERIOD(SINGBUF_MAX_nPERIOD)) singbuf_2(.clk(clk), .rst(rst), .config_bits(singbuf_config), .start(start), .we(data_bn_we_2), .re(data_bn_re), .data_in(data_bn_2), .wrdy(data_bn_wrdy_2), .rrdy(data_bn_rrdy_2), .data_out(data_bn_buf_2));

endmodule
