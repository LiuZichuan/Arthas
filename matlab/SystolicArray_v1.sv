`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: SystolicArray
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

module SystolicArray(
	// inputs
	clk,
	rst,
	start,
	in_en,
	dfsm_config_en,
	dfsm_config,
	pe_config_1_1,
	pe_config_1_2,
	pe_config_1_3,
	pe_config_2_1,
	pe_config_2_2,
	pe_config_2_3,
	pe_config_load,
	weight_1_1,
	weight_1_2,
	weight_1_3,
	weight_2_1,
	weight_2_2,
	weight_2_3,
	feature_1,
	feature_2,
	feature_3,
	feature_4,
	feature_5,
	feature_6,
	// outputs
	dout_1_1,
	dout_1_2,
	dout_1_3,
	dout_1_4,
	dout_2_1,
	dout_2_2,
	dout_2_3,
	dout_2_4,
	dout_en_1,
	dout_en_2,
	dout_en_3,
	dout_en_4,
);
	parameter nBanks = 2;
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 16;
	parameter oWidth = 33;
	parameter MAX_nPERIOD = 8;
	parameter MAX_nLMAC = 12288;
	parameter MAX_nSHFT = 192;

	// inputs
	input clk, rst, start, in_en, pe_config_load, dfsm_config_en, dfsm_config;
	input pe_config_1_1;
	input pe_config_1_2;
	input pe_config_1_3;
	input pe_config_2_1;
	input pe_config_2_2;
	input pe_config_2_3;
	input [15:0] weight_1_1;
	input [15:0] weight_1_2;
	input [15:0] weight_1_3;
	input [15:0] weight_2_1;
	input [15:0] weight_2_2;
	input [15:0] weight_2_3;
	input [15:0] feature_1;
	input [15:0] feature_2;
	input [15:0] feature_3;
	input [15:0] feature_4;
	input [15:0] feature_5;
	input [15:0] feature_6;

	// outputs
	output [32:0] dout_1_1;
	output [32:0] dout_1_2;
	output [32:0] dout_1_3;
	output [32:0] dout_1_4;
	output [32:0] dout_2_1;
	output [32:0] dout_2_2;
	output [32:0] dout_2_3;
	output [32:0] dout_2_4;
	output dout_en_1;
	output dout_en_2;
	output dout_en_3;
	output dout_en_4;


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

	logic dfsm_data_en_1;
	logic dfsm_data_en_2;
	logic dfsm_data_en_3;
	logic dfsm_data_en_4;

	logic start_bypass_1;
	logic start_bypass_2;
	logic start_bypass_3;
	logic start_bypass_4;

	SystolicBank # (.iWidth(iWidth), .oWidth(oWidth), .nRows(nRows), .nCols(nCols)) bank_1(.clk(clk), .rst(rst), .in_en(in_en), .config_load(pe_config_load), .iconfig_1(pe_config_1_1), .iconfig_2(pe_config_1_2), .iconfig_3(pe_config_1_3), .weight_1(weight_1_1), .weight_2(weight_1_2), .weight_3(weight_1_3), .feature_1(feature_1), .feature_2(feature_2), .feature_3(feature_3), .feature_4(feature_4), .feature_5(feature_5), .feature_6(feature_6), .A_1(A_1), .A_2(A_2), .A_3(A_3), .A_4(A_4), .B_1(B_1), .B_2(B_2), .B_3(B_3), .B_4(B_4), .C_1(C_1), .C_2(C_2), .C_3(C_3), .C_4(C_4), .D_1(D_1), .D_2(D_2), .D_3(D_3), .D_4(D_4), .E_1(E_1), .E_2(E_2), .E_3(E_3), .E_4(E_4), .F_1(F_1), .F_2(F_2), .F_3(F_3), .F_4(F_4), .G_1(G_1), .G_2(G_2), .G_3(G_3), .G_4(G_4), .dout_1(dout_1_1), .dout_2(dout_1_2), .dout_3(dout_1_3), .dout_4(dout_1_4));
	SystolicBank # (.iWidth(iWidth), .oWidth(oWidth), .nRows(nRows), .nCols(nCols)) bank_2(.clk(clk), .rst(rst), .in_en(in_en), .config_load(pe_config_load), .iconfig_1(pe_config_2_1), .iconfig_2(pe_config_2_2), .iconfig_3(pe_config_2_3), .weight_1(weight_2_1), .weight_2(weight_2_2), .weight_3(weight_2_3), .feature_1(feature_1), .feature_2(feature_2), .feature_3(feature_3), .feature_4(feature_4), .feature_5(feature_5), .feature_6(feature_6), .A_1(A_1), .A_2(A_2), .A_3(A_3), .A_4(A_4), .B_1(B_1), .B_2(B_2), .B_3(B_3), .B_4(B_4), .C_1(C_1), .C_2(C_2), .C_3(C_3), .C_4(C_4), .D_1(D_1), .D_2(D_2), .D_3(D_3), .D_4(D_4), .E_1(E_1), .E_2(E_2), .E_3(E_3), .E_4(E_4), .F_1(F_1), .F_2(F_2), .F_3(F_3), .F_4(F_4), .G_1(G_1), .G_2(G_2), .G_3(G_3), .G_4(G_4), .dout_1(dout_2_1), .dout_2(dout_2_2), .dout_3(dout_2_3), .dout_4(dout_2_4));

	DFSM # (.MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) fsm_1(.clk(clk), .rst(rst), .config_en(dfsm_config_en), .iconfig(dfsm_config), .in_en(in_en), .start(start), .in_en_bypass(dfsm_data_en_1), .out_en(dout_en_1), .start_out(start_bypass_1), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .F(F_1), .G(G_1));
	DFSM # (.MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) fsm_2(.clk(clk), .rst(rst), .config_en(dfsm_config_en), .iconfig(dfsm_config), .in_en(dfsm_data_en_1), .start(start_bypass_1), .in_en_bypass(dfsm_data_en_2), .out_en(dout_en_2), .start_out(start_bypass_2), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .F(F_2), .G(G_2));
	DFSM # (.MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) fsm_3(.clk(clk), .rst(rst), .config_en(dfsm_config_en), .iconfig(dfsm_config), .in_en(dfsm_data_en_2), .start(start_bypass_2), .in_en_bypass(dfsm_data_en_3), .out_en(dout_en_3), .start_out(start_bypass_3), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .F(F_3), .G(G_3));
	DFSM # (.MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) fsm_4(.clk(clk), .rst(rst), .config_en(dfsm_config_en), .iconfig(dfsm_config), .in_en(dfsm_data_en_3), .start(start_bypass_3), .in_en_bypass(dfsm_data_en_4), .out_en(dout_en_4), .start_out(start_bypass_4), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .F(F_4), .G(G_4));

endmodule
