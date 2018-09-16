`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: Arthas top
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

module Arthas_top_v1(
	clk_arr,
	rst,
	// DDR3 inouts
	ddr3_dq,
	ddr3_dqs_n,
	ddr3_dqs_p,
	// DDR3 outputs
	ddr3_addr,
	ddr3_ba,
	ddr3_ras_n,
	ddr3_cas_n,
	ddr3_we_n,
	ddr3_reset_n,
	ddr3_ck_p,
	ddr3_ck_n,
	ddr3_cke,
	ddr3_cs_n,
	ddr3_dm,
	ddr3_odt,
	// DDR3 inputs (differential system clock)
	sys_clk_p,
	sys_clk_n,
	sys_rst,
	// DDR3 inputs (reference clock)
	clk_ref_p,
	clk_ref_n,
);

	parameter nBanks = 2;
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 8;
	parameter oWidth = 8;
	parameter rAddrWidth = 28;
	parameter rDataWidth = 64;
	parameter rReqWidth = 31;
	parameter wAddrWidth = 28;
	parameter wDataWidth = 64;
	parameter wReqWidth = 106;
	parameter wMaskWidth = 8;
	parameter DFSM_MAX_nPERIOD = 512;
	parameter DFSM_MAX_nLMAC = 3072;
	parameter DFSM_MAX_nSHFT = 3;
	parameter SSP_MAX_nPeriod = 262144;
	parameter QUABUF_MAX_nDATA = 1024;
	parameter QUABUF_MAX_nCOL = 3;
	parameter QUABUF_MAX_nPERIOD = 65536;
	parameter QUABUF_MAX_nREP = 1024;
	parameter SINGBUF_MAX_nDATA = 1024;
	parameter SINGBUF_MAX_nPERIOD = 65536;

	localparam SSP_MAX_nData = nCols;
	localparam DFSM_CONFIGBIT_WIDTH = $clog2(DFSM_MAX_nPERIOD) + $clog2(DFSM_MAX_nLMAC) + $clog2(DFSM_MAX_nSHFT);
	localparam SSP_CONFIGBIT_WIDTH = $clog2(SSP_MAX_nData) + $clog2(SSP_MAX_nPeriod);
	localparam QUABUF_CONFIGBIT_WIDTH = $clog2(QUABUF_MAX_nDATA) + $clog2(QUABUF_MAX_nCOL) + $clog2(QUABUF_MAX_nREP) + $clog2(QUABUF_MAX_nPERIOD);
	localparam SINGBUF_CONFIGBIT_WIDTH = $clog2(SINGBUF_MAX_nDATA) + $clog2(SINGBUF_MAX_nPERIOD);
	localparam MODE_CONV = 0; localparam MODE_MM = 1;

	input clk_arr;
	input rst;
	// DDR3 inouts
	inout [7:0] ddr3_dq;
	inout [0:0] ddr3_dqs_n;
	inout [0:0] ddr3_dqs_p;

	// DDR3 outputs
	output [13:0] ddr3_addr;
	output [2:0] ddr3_ba;
	output ddr3_ras_n;
	output ddr3_cas_n;
	output ddr3_we_n;
	output ddr3_reset_n;
	output [0:0] ddr3_ck_p;
	output [0:0] ddr3_ck_n;
	output [0:0] ddr3_cke;
	output [0:0] ddr3_cs_n;
	output [0:0] ddr3_dm;
	output [0:0] ddr3_odt;

	// DDR3 inputs (differential system clock)
	input sys_clk_p;
	input sys_clk_n;
	input sys_rst;

	// DDR3 inputs (reference clock)
	input clk_ref_p;
	input clk_ref_n;

	// user interface signals
	logic [27:0]      app_addr;
	logic [2:0]       app_cmd;
	logic             app_en;
	logic [63:0]      app_wdf_data;
	logic             app_wdf_end;
	logic [7:0]       app_wdf_mask;
	logic             app_wdf_wren;
	logic [63:0]      app_rd_data;
	logic             app_rd_data_end;
	logic             app_rd_data_valid;
	logic             app_rdy;
	logic             app_wdf_rdy;
	logic             app_sr_req;
	logic             app_ref_req;
	logic             app_zq_req;
	logic             app_sr_active;
	logic             app_ref_ack;
	logic             app_zq_ack;
	logic             clk_bus;
	logic             rst_bus;
	logic             init_calib_complete;

	logic [DFSM_CONFIGBIT_WIDTH-1:0] dfsm_config;
	logic [SSP_CONFIGBIT_WIDTH-1:0] ssp_config;
	logic [QUABUF_CONFIGBIT_WIDTH-1:0] quabuf_config;
	logic [SINGBUF_CONFIGBIT_WIDTH-1:0] singbuf_config;
	logic pe_config_1_1;
	logic pe_config_1_2;
	logic pe_config_1_3;
	logic pe_config_2_1;
	logic pe_config_2_2;
	logic pe_config_2_3;
	logic [7:0] data_horz_1_1;
	logic [7:0] data_horz_1_2;
	logic [7:0] data_horz_1_3;
	logic [7:0] data_horz_2_1;
	logic [7:0] data_horz_2_2;
	logic [7:0] data_horz_2_3;
	logic [7:0] data_obli_1;
	logic [7:0] data_obli_2;
	logic [7:0] data_obli_3;
	logic [7:0] data_obli_4;
	logic [7:0] data_obli_5;
	logic [7:0] data_obli_6;
	logic [15:0] data_bn_1;
	logic [15:0] data_bn_2;
	logic data_horz_in_en_1_1;
	logic data_horz_in_en_1_2;
	logic data_horz_in_en_1_3;
	logic data_horz_in_en_2_1;
	logic data_horz_in_en_2_2;
	logic data_horz_in_en_2_3;
	logic data_obli_in_en_1;
	logic data_obli_in_en_2;
	logic data_obli_in_en_3;
	logic data_obli_in_en_4;
	logic data_obli_in_en_5;
	logic data_obli_in_en_6;

	logic [7:0] dout_1;
	logic [7:0] dout_2;
	logic dout_en_1;
	logic dout_en_2;
	logic data_obli_wrdy_1;
	logic data_obli_wrdy_2;
	logic data_obli_wrdy_3;
	logic data_obli_wrdy_4;
	logic data_obli_wrdy_5;
	logic data_obli_wrdy_6;
	logic data_horz_wrdy_1_1;
	logic data_horz_wrdy_1_2;
	logic data_horz_wrdy_1_3;
	logic data_horz_wrdy_2_1;
	logic data_horz_wrdy_2_2;
	logic data_horz_wrdy_2_3;
	logic data_bn_wrdy_1;
	logic data_bn_wrdy_2;

	logic [rReqWidth-1:0] ibc_r_req;
	logic mem2ibc_en;
	logic [rDataWidth-1:0] mem2ibc_data;
	logic mem2ibc_data_en;
	logic [rAddrWidth-1:0] ibc2mem_r_addr;
	logic ibc2mem_r_vld;
	logic [rDataWidth-1:0] ibc2pc_data;
	logic ibc2pc_data_en_0;
	logic ibc2pc_data_en_1;
	logic ibc2pc_data_en_2;
	logic ibc2pc_data_en_3;
	logic ibc2pc_data_en_4;
	logic ibc2pc_data_en_5;
	logic ibc2pc_data_en_6;
	logic ibc2pc_data_en_7;
	logic ibc2pc_data_en_8;
	logic ibc2pc_data_en_9;
	logic ibc2pc_data_en_10;
	logic ibc2pc_data_en_11;
	logic ibc_tk_0;
	logic ibc_tk_1;
	logic ibc_tk_2;
	logic ibc_tk_3;
	logic ibc_tk_4;
	logic ibc_tk_5;
	logic ibc_tk_6;
	logic ibc_tk_7;
	logic ibc_tk_8;
	logic ibc_tk_9;
	logic ibc_tk_10;
	logic ibc_tk_11;

	logic obc_tk_0;
	logic obc_tk_1;
	logic [wReqWidth-1:0] obc_w_req;
	logic obc_w_req_en;
	logic mem2obc_en;
	logic [wAddrWidth-1:0] obc2mem_w_addr;
	logic [wDataWidth-1:0] obc2mem_w_data;
	logic obc2mem_w_vld;

	logic [2*rAddrWidth-1:0] iport_configbits_0;
	logic [2*rAddrWidth-1:0] iport_configbits_1;
	logic [2*rAddrWidth-1:0] iport_configbits_2;
	logic [2*rAddrWidth-1:0] iport_configbits_3;
	logic [2*rAddrWidth-1:0] iport_configbits_4;
	logic [2*rAddrWidth-1:0] iport_configbits_5;
	logic [2*rAddrWidth-1:0] iport_configbits_6;
	logic [2*rAddrWidth-1:0] iport_configbits_7;
	logic [2*rAddrWidth-1:0] iport_configbits_8;
	logic [2*rAddrWidth-1:0] iport_configbits_9;
	logic [2*rAddrWidth-1:0] iport_configbits_10;
	logic [2*rAddrWidth-1:0] iport_configbits_11;
	logic [2*wAddrWidth-1:0] oport_configbits_0;
	logic [2*wAddrWidth-1:0] oport_configbits_1;

	// System Config
	SCRF sys_config_reg_file (
		.dfsm_config(dfsm_config),
		.ssp_config(ssp_config),
		.quabuf_config(quabuf_config),
		.singbuf_config(singbuf_config),
		.mode_conv_mm(mode_conv_mm),
		.isac(isac),
		.isrelu(isrelu),
		.pe_config_1_1(pe_config_1_1),
		.pe_config_1_2(pe_config_1_2),
		.pe_config_1_3(pe_config_1_3),
		.pe_config_2_1(pe_config_2_1),
		.pe_config_2_2(pe_config_2_2),
		.pe_config_2_3(pe_config_2_3),
		.iport_configbits_0(iport_configbits_0),
		.iport_configbits_1(iport_configbits_1),
		.iport_configbits_2(iport_configbits_2),
		.iport_configbits_3(iport_configbits_3),
		.iport_configbits_4(iport_configbits_4),
		.iport_configbits_5(iport_configbits_5),
		.iport_configbits_6(iport_configbits_6),
		.iport_configbits_7(iport_configbits_7),
		.iport_configbits_8(iport_configbits_8),
		.iport_configbits_9(iport_configbits_9),
		.iport_configbits_10(iport_configbits_10),
		.iport_configbits_11(iport_configbits_11),
		.oport_configbits_0(oport_configbits_0),
		.oport_configbits_1(oport_configbits_1),
		.isbn(isbn)
	);

	mig_7series_0 u_mig_7series_0 (
		// Memory interface ports
		.ddr3_addr(ddr3_addr),
		.ddr3_ba(ddr3_ba),
		.ddr3_cas_n(ddr3_cas_n),
		.ddr3_ck_n(ddr3_ck_n),
		.ddr3_ck_p(ddr3_ck_p),
		.ddr3_cke(ddr3_cke),
		.ddr3_ras_n(ddr3_ras_n),
		.ddr3_reset_n(ddr3_reset_n),
		.ddr3_we_n(ddr3_we_n),
		.ddr3_dq(ddr3_dq),
		.ddr3_dqs_n(ddr3_dqs_n),
		.ddr3_dqs_p(ddr3_dqs_p),
		.ddr3_cs_n(ddr3_cs_n),
		.ddr3_dm(ddr3_dm),
		.ddr3_odt(ddr3_odt),
		// System Clock Ports
		.sys_clk_p(sys_clk_p),
		.sys_clk_n(sys_clk_n),
		.sys_rst(sys_rst),
		// Reference Clock Ports
		.clk_ref_p(clk_ref_p),
		.clk_ref_n(clk_ref_n),
		// Application interface ports
		.app_addr(app_addr),
		.app_cmd(app_cmd),
		.app_en(app_en),
		.app_wdf_data(app_wdf_data),
		.app_wdf_end(app_wdf_end),
		.app_wdf_wren(app_wdf_wren),
		.app_rd_data(app_rd_data),
		.app_rd_data_end(app_rd_data_end),
		.app_rd_data_valid(app_rd_data_valid),
		.app_rdy(app_rdy),
		.app_wdf_rdy(app_wdf_rdy),
		.app_sr_req(0),
		.app_ref_req(0),
		.app_zq_req(app_zq_req),
		.app_sr_active(app_sr_active),
		.app_ref_ack(app_ref_ack),
		.app_zq_ack(app_zq_ack),
		.app_wdf_mask(app_wdf_mask),
		.ui_clk(clk_bus),
		.ui_clk_sync_rst(rst_bus),
		.init_calib_complete(init_calib_complete)
	);

	SystolicArray_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nBanks(nBanks), .nRows(nRows), .nCols(nCols), 
						.DFSM_MAX_nPERIOD(DFSM_MAX_nPERIOD), .DFSM_MAX_nLMAC(DFSM_MAX_nLMAC), .DFSM_MAX_nSHFT(DFSM_MAX_nSHFT), 
						.QUABUF_MAX_nDATA(QUABUF_MAX_nDATA), .QUABUF_MAX_nCOL(QUABUF_MAX_nCOL), .QUABUF_MAX_nPERIOD(QUABUF_MAX_nPERIOD), .QUABUF_MAX_nREP(QUABUF_MAX_nREP), 
						.SINGBUF_MAX_nPERIOD(SINGBUF_MAX_nPERIOD), .SINGBUF_MAX_nDATA(SINGBUF_MAX_nDATA), 
						.SSP_MAX_nPeriod(SSP_MAX_nPeriod))
	U(.clk(clk), .clk_mem(clk), .rst(rst), .start(start), .mode_conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), 
		.pe_config_1_1(pe_config_1_1), .pe_config_1_2(pe_config_1_2), .pe_config_1_3(pe_config_1_3), .pe_config_2_1(pe_config_2_1), .pe_config_2_2(pe_config_2_2), .pe_config_2_3(pe_config_2_3), 
		.data_horz_1_1(data_horz_1_1), .data_horz_1_2(data_horz_1_2), .data_horz_1_3(data_horz_1_3), .data_horz_2_1(data_horz_2_1), .data_horz_2_2(data_horz_2_2), .data_horz_2_3(data_horz_2_3), 
		.data_horz_in_en_1_1(w_in_en), .data_horz_in_en_1_2(w_in_en), .data_horz_in_en_1_3(w_in_en), .data_horz_in_en_2_1(w_in_en), .data_horz_in_en_2_2(w_in_en), .data_horz_in_en_2_3(w_in_en), 
		.data_obli_1(data_obli_1), .data_obli_2(data_obli_2), .data_obli_3(data_obli_3), .data_obli_4(data_obli_4), .data_obli_5(data_obli_5), .data_obli_6(data_obli_6), 
		.data_obli_in_en_1(f_in_en), .data_obli_in_en_2(f_in_en), .data_obli_in_en_3(f_in_en), .data_obli_in_en_4(f_in_en), .data_obli_in_en_5(f_in_en), .data_obli_in_en_6(f_in_en), 
		.data_horz_wrdy_1_1(data_horz_wrdy_1_1), .data_horz_wrdy_1_2(data_horz_wrdy_1_2), .data_horz_wrdy_1_3(data_horz_wrdy_1_3), .data_horz_wrdy_2_1(data_horz_wrdy_2_1), .data_horz_wrdy_2_2(data_horz_wrdy_2_2), .data_horz_wrdy_2_3(data_horz_wrdy_2_3), 
		.data_obli_wrdy_1(data_obli_wrdy_1), .data_obli_wrdy_2(data_obli_wrdy_2), .data_obli_wrdy_3(data_obli_wrdy_3), .data_obli_wrdy_4(data_obli_wrdy_4), .data_obli_wrdy_5(data_obli_wrdy_5), .data_obli_wrdy_6(data_obli_wrdy_6), 
		.dout_1(dout_1), .dout_2(dout_2), 
		.dout_en_1(dout_en_1), .dout_en_2(dout_en_2), 
		.data_bn_1(data_bn_1), .data_bn_2(data_bn_2), 
		.data_bn_we_1(bn_in_en), .data_bn_we_2(bn_in_en), 
		.data_bn_wrdy_1(data_bn_wrdy_1), .data_bn_wrdy_2(data_bn_wrdy_2), 
		.dfsm_config(dfsm_config), .ssp_config(ssp_config), .quabuf_config(quabuf_config),
		.singbuf_config(singbuf_config)
	);

	MIF # (.rAddrWidth(rAddrWidth), .rDataWidth(rDataWidth), .rReqWidth(rReqWidth), .wAddrWidth(wAddrWidth), .wDataWidth(wDataWidth), .wReqWidth(wReqWidth), .wMaskWidth(wMaskWidth))
	mif_inst (
		.start(start),
		// inputs from MIG
		.clk_bus(clk_bus),
		.rst_bus(rst_bus),
		.app_rd_data(app_rd_data),
		.app_rd_data_end(app_rd_data_end),
		.app_rd_data_valid(app_rd_data_valid),
		.app_rdy(app_rdy),
		.app_wdf_rdy(app_wdf_rdy),
		// outputs to MIG 
		.app_addr(app_addr),
		.app_cmd(app_cmd),
		.app_en(app_en),
		.app_wdf_data(app_wdf_data),
		.app_wdf_end(app_wdf_end),
		.app_wdf_mask(app_wdf_mask),
		.app_wdf_wren(app_wdf_wren),
		// inputs from IBC
		.ibc2mem_r_addr(ibc2mem_r_addr),
		.ibc2mem_r_vld(ibc2mem_r_vld),
		// outputs to IBC
		.mem2ibc_en(mem2ibc_en),
		.mem2ibc_data(mem2ibc_data),
		.mem2ibc_data_en(mem2ibc_data_en),
		// inputs from OBC
		.obc2mem_w_addr(obc2mem_w_addr),
		.obc2mem_w_vld(obc2mem_w_vld),
		.obc2mem_w_data(obc2mem_w_data),
		// output to OBC
		.mem2obc_en(mem2obc_en)
	);

	IBC # (.nPorts(nRows+nCols-1), .rAddrWidth(rAddrWidth), .rDataWidth(rDataWidth), .rReqWidth(rReqWidth))
	ibc_inst (
		// inputs from PC
		.clk_bus(clk_bus),
		.rst_bus(rst_bus),
		.r_req(ibc_r_req),
		.r_req_en(ibc_r_req_en),
		// inputs from MIF
		.mem2ibc_en(mem2ibc_en),
		.mem2ibc_data(mem2ibc_data),
		.mem2ibc_data_en(mem2ibc_data_en),
		// outputs to MIF
		.ibc2mem_r_addr(ibc2mem_r_addr),
		.ibc2mem_r_vld(ibc2mem_r_vld),
		// outputs to PC
		.ibc2pc_data_en_0(ibc2pc_data_en_0),
		.ibc2pc_data_en_1(ibc2pc_data_en_1),
		.ibc2pc_data_en_2(ibc2pc_data_en_2),
		.ibc2pc_data_en_3(ibc2pc_data_en_3),
		.ibc2pc_data_en_4(ibc2pc_data_en_4),
		.ibc2pc_data_en_5(ibc2pc_data_en_5),
		.tk_out_0(ibc_tk_0),
		.tk_out_1(ibc_tk_1),
		.tk_out_2(ibc_tk_2),
		.tk_out_3(ibc_tk_3),
		.tk_out_4(ibc_tk_4),
		.tk_out_5(ibc_tk_5),
		.ibc2pc_data(ibc2pc_data)
	);

	OBC # (.nPorts(nBanks), .wAddrWidth(wAddrWidth), .wDataWidth(wDataWidth), .wReqWidth(wReqWidth), .wMaskWidth(wMaskWidth))
	obc_inst (
		// inputs from PC
		.clk_bus(clk_bus),
		.rst_bus(rst_bus),
		.w_req(obc_w_req),
		.w_req_en(obc_w_req_en),
		// inputs from MIF
		.mem2obc_en(mem2obc_en),
		// outputs to MIF
		.obc2mem_w_addr(obc2mem_w_addr),
		.obc2mem_w_vld(obc2mem_w_vld),
		.tk_out_0(obc_tk_0),
		.tk_out_1(obc_tk_1),
		.obc2mem_w_data(obc2mem_w_data)
	);

	logic [rReqWidth-1:0] rd_req_0;
	logic [rReqWidth-1:0] rd_req_1;
	logic [rReqWidth-1:0] rd_req_2;
	logic [rReqWidth-1:0] rd_req_3;
	logic [rReqWidth-1:0] rd_req_4;
	logic [rReqWidth-1:0] rd_req_5;
	logic [rReqWidth-1:0] rd_req_6;
	logic [rReqWidth-1:0] rd_req_7;
	logic [rReqWidth-1:0] rd_req_8;
	logic [rReqWidth-1:0] rd_req_9;
	logic [rReqWidth-1:0] rd_req_10;
	logic [rReqWidth-1:0] rd_req_11;

	logic rd_req_en_0;
	logic rd_req_en_1;
	logic rd_req_en_2;
	logic rd_req_en_3;
	logic rd_req_en_4;
	logic rd_req_en_5;

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(0))
	iPort_0 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_0),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_0),
		.wrdy(data_obli_wrdy_1),
		.config_bits(iport_configbits_0),
		// outputs
		.rd_data_pc2arr(data_obli_1),
		.rd_data_pc2arr_en(data_obli_in_en_1),
		.rd_req_en(rd_req_en_0),
		.rd_req_out(rd_req_0)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(1))
	iPort_1 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_1),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_1),
		.wrdy(data_obli_wrdy_2),
		.config_bits(iport_configbits_1),
		// outputs
		.rd_data_pc2arr(data_obli_2),
		.rd_data_pc2arr_en(data_obli_in_en_2),
		.rd_req_en(rd_req_en_1),
		.rd_req_out(rd_req_1)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(2))
	iPort_2 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_2),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_2),
		.wrdy(data_obli_wrdy_3),
		.config_bits(iport_configbits_2),
		// outputs
		.rd_data_pc2arr(data_obli_3),
		.rd_data_pc2arr_en(data_obli_in_en_3),
		.rd_req_en(rd_req_en_2),
		.rd_req_out(rd_req_2)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(3))
	iPort_3 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_3),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_3),
		.wrdy(data_obli_wrdy_4),
		.config_bits(iport_configbits_3),
		// outputs
		.rd_data_pc2arr(data_obli_4),
		.rd_data_pc2arr_en(data_obli_in_en_4),
		.rd_req_en(rd_req_en_3),
		.rd_req_out(rd_req_3)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(4))
	iPort_4 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_4),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_4),
		.wrdy(data_obli_wrdy_5),
		.config_bits(iport_configbits_4),
		// outputs
		.rd_data_pc2arr(data_obli_5),
		.rd_data_pc2arr_en(data_obli_in_en_5),
		.rd_req_en(rd_req_en_4),
		.rd_req_out(rd_req_4)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(5))
	iPort_5 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_5),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_5),
		.wrdy(data_obli_wrdy_6),
		.config_bits(iport_configbits_5),
		// outputs
		.rd_data_pc2arr(data_obli_6),
		.rd_data_pc2arr_en(data_obli_in_en_6),
		.rd_req_en(rd_req_en_5),
		.rd_req_out(rd_req_5)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(6))
	iPort_6 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_6),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_6),
		.wrdy(data_horz_wrdy_1_1),
		.config_bits(iport_configbits_6),
		// outputs
		.rd_data_pc2arr(data_horz_1_1),
		.rd_data_pc2arr_en(data_horz_in_en_1_1),
		.rd_req_en(rd_req_en_6),
		.rd_req_out(rd_req_6)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(7))
	iPort_7 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_7),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_7),
		.wrdy(data_horz_wrdy_1_2),
		.config_bits(iport_configbits_7),
		// outputs
		.rd_data_pc2arr(data_horz_1_2),
		.rd_data_pc2arr_en(data_horz_in_en_1_2),
		.rd_req_en(rd_req_en_7),
		.rd_req_out(rd_req_7)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(8))
	iPort_8 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_8),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_8),
		.wrdy(data_horz_wrdy_1_3),
		.config_bits(iport_configbits_8),
		// outputs
		.rd_data_pc2arr(data_horz_1_3),
		.rd_data_pc2arr_en(data_horz_in_en_1_3),
		.rd_req_en(rd_req_en_8),
		.rd_req_out(rd_req_8)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(9))
	iPort_9 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_9),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_9),
		.wrdy(data_horz_wrdy_2_1),
		.config_bits(iport_configbits_9),
		// outputs
		.rd_data_pc2arr(data_horz_2_1),
		.rd_data_pc2arr_en(data_horz_in_en_2_1),
		.rd_req_en(rd_req_en_9),
		.rd_req_out(rd_req_9)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(10))
	iPort_10 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_10),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_10),
		.wrdy(data_horz_wrdy_2_2),
		.config_bits(iport_configbits_10),
		// outputs
		.rd_data_pc2arr(data_horz_2_2),
		.rd_data_pc2arr_en(data_horz_in_en_2_2),
		.rd_req_en(rd_req_en_10),
		.rd_req_out(rd_req_10)
	);

	PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(11))
	iPort_11 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(ibc_tk_11),
		.rd_data_mem2pc(ibc2pc_data),
		.rd_data_mem2pc_en(ibc2pc_data_en_11),
		.wrdy(data_horz_wrdy_2_3),
		.config_bits(iport_configbits_11),
		// outputs
		.rd_data_pc2arr(data_horz_2_3),
		.rd_data_pc2arr_en(data_horz_in_en_2_3),
		.rd_req_en(rd_req_en_11),
		.rd_req_out(rd_req_11)
	);

	logic [wReqWidth-1:0] wr_req_0;
	logic [wReqWidth-1:0] wr_req_1;

	logic wr_req_en_0;
	logic wr_req_en_1;

	PCv2 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .WIDTH_MASK(),
			.nCols(nCols), .nRows(nRows), .MAX_nPERIOD(), .MAX_nCHN(), .P_ID(0))
	oPort_0 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(obc_tk_0),
		.data_arr2pc(dout_1),
		.data_arr2pc_en(dout_en_1),
		.config_bits(oport_configbits_0),
		// outputs
		.wr_req_out(wr_req_0),
		.wr_req_en(wr_req_en_0)
	);

	PCv2 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .WIDTH_MASK(),
			.nCols(nCols), .nRows(nRows), .MAX_nPERIOD(), .MAX_nCHN(), .P_ID(1))
	oPort_1 (
		// inputs
		.clk_bus(clk_bus),
		.clk_array(clk_array),
		.rst_bus(rst_bus),
		.rst_array(rst_array),
		.start(start),
		.tk_en(obc_tk_1),
		.data_arr2pc(dout_2),
		.data_arr2pc_en(dout_en_2),
		.config_bits(oport_configbits_1),
		// outputs
		.wr_req_out(wr_req_1),
		.wr_req_en(wr_req_en_1)
	);

endmodule
