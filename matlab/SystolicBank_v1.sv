`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: SystolicBank
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

module SystolicBank(
	// inputs
	clk,
	rst,
	in_en,
	iconfig_1,
	iconfig_2,
	iconfig_3,
	config_load,
	weight_1,
	weight_2,
	weight_3,
	feature_1,
	feature_2,
	feature_3,
	feature_4,
	feature_5,
	feature_6,
	A_1,
	A_2,
	A_3,
	A_4,
	B_1,
	B_2,
	B_3,
	B_4,
	C_1,
	C_2,
	C_3,
	C_4,
	D_1,
	D_2,
	D_3,
	D_4,
	E_1,
	E_2,
	E_3,
	E_4,
	F_1,
	F_2,
	F_3,
	F_4,
	G_1,
	G_2,
	G_3,
	G_4,
	// outputs
	dout_1,
	dout_2,
	dout_3,
	dout_4
);
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 16;
	parameter oWidth = 33;

	// inputs
	input clk, rst, in_en, config_load;
	input iconfig_1;
	input iconfig_2;
	input iconfig_3;
	input [15:0] weight_1;
	input [15:0] weight_2;
	input [15:0] weight_3;
	input [15:0] feature_1;
	input [15:0] feature_2;
	input [15:0] feature_3;
	input [15:0] feature_4;
	input [15:0] feature_5;
	input [15:0] feature_6;
	input A_1;
	input A_2;
	input A_3;
	input A_4;
	input B_1;
	input B_2;
	input B_3;
	input B_4;
	input C_1;
	input C_2;
	input C_3;
	input C_4;
	input D_1;
	input D_2;
	input D_3;
	input D_4;
	input E_1;
	input E_2;
	input E_3;
	input E_4;
	input F_1;
	input F_2;
	input F_3;
	input F_4;
	input G_1;
	input G_2;
	input G_3;
	input G_4;

	// outputs
	output [32:0] dout_1;
	output [32:0] dout_2;
	output [32:0] dout_3;
	output [32:0] dout_4;

	logic wf_en_1_0;
	logic wf_en_1_1;
	logic wf_en_1_2;
	logic wf_en_1_3;
	logic wf_en_1_4;
	logic wf_en_2_0;
	logic wf_en_2_1;
	logic wf_en_2_2;
	logic wf_en_2_3;
	logic wf_en_2_4;
	logic wf_en_3_0;
	logic wf_en_3_1;
	logic wf_en_3_2;
	logic wf_en_3_3;
	logic wf_en_3_4;

	logic [32:0] psum_1_1;
	logic [32:0] psum_1_2;
	logic [32:0] psum_1_3;
	logic [32:0] psum_1_4;
	logic [32:0] psum_2_1;
	logic [32:0] psum_2_2;
	logic [32:0] psum_2_3;
	logic [32:0] psum_2_4;
	logic [32:0] psum_3_1;
	logic [32:0] psum_3_2;
	logic [32:0] psum_3_3;
	logic [32:0] psum_3_4;
	logic [32:0] psum_4_1;
	logic [32:0] psum_4_2;
	logic [32:0] psum_4_3;
	logic [32:0] psum_4_4;

	logic [15:0] weight_1_0;
	logic [15:0] weight_1_1;
	logic [15:0] weight_1_2;
	logic [15:0] weight_1_3;
	logic [15:0] weight_1_4;
	logic [15:0] weight_2_0;
	logic [15:0] weight_2_1;
	logic [15:0] weight_2_2;
	logic [15:0] weight_2_3;
	logic [15:0] weight_2_4;
	logic [15:0] weight_3_0;
	logic [15:0] weight_3_1;
	logic [15:0] weight_3_2;
	logic [15:0] weight_3_3;
	logic [15:0] weight_3_4;
	logic [15:0] weight_4_0;
	logic [15:0] weight_4_1;
	logic [15:0] weight_4_2;
	logic [15:0] weight_4_3;
	logic [15:0] weight_4_4;

	logic [15:0] feature_1_0;
	logic [15:0] feature_1_1;
	logic [15:0] feature_1_2;
	logic [15:0] feature_1_3;
	logic [15:0] feature_1_4;
	logic [15:0] feature_2_0;
	logic [15:0] feature_2_1;
	logic [15:0] feature_2_2;
	logic [15:0] feature_2_3;
	logic [15:0] feature_2_4;
	logic [15:0] feature_3_0;
	logic [15:0] feature_3_1;
	logic [15:0] feature_3_2;
	logic [15:0] feature_3_3;
	logic [15:0] feature_3_4;
	logic [15:0] feature_4_0;
	logic [15:0] feature_4_1;
	logic [15:0] feature_4_2;
	logic [15:0] feature_4_3;
	logic [15:0] feature_4_4;

	assign psum_4_1 = 0;
	assign psum_4_2 = 0;
	assign psum_4_3 = 0;
	assign psum_4_4 = 0;

	assign wf_en_1_0 = in_en;
	assign wf_en_2_0 = in_en;
	assign wf_en_3_0 = in_en;

	assign weight_1_0 = weight_1;
	assign weight_2_0 = weight_2;
	assign weight_3_0 = weight_3;

	assign feature_2_0 = feature_1;
	assign feature_3_0 = feature_2;
	assign feature_4_0 = feature_3;
	assign feature_4_1 = feature_4;
	assign feature_4_2 = feature_5;
	assign feature_4_3 = feature_6;

	PEv2 # (.WIDTH(iWidth)) p_1_1(.clk(clk), .rst(rst), .in_en(wf_en_1_0), .ipsum(psum_2_1), .iconfig(iconfig_1), .weight(weight_1_0), .feature(feature_2_0), .config_load(config_load), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .w_out(weight_1_1), .f_out(feature_1_1), .wf_en(wf_en_1_1), .opsum(psum_1_1));
	PEv2 # (.WIDTH(iWidth)) p_1_2(.clk(clk), .rst(rst), .in_en(wf_en_1_1), .ipsum(psum_2_2), .iconfig(iconfig_1), .weight(weight_1_1), .feature(feature_2_1), .config_load(config_load), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .w_out(weight_1_2), .f_out(feature_1_2), .wf_en(wf_en_1_2), .opsum(psum_1_2));
	PEv2 # (.WIDTH(iWidth)) p_1_3(.clk(clk), .rst(rst), .in_en(wf_en_1_2), .ipsum(psum_2_3), .iconfig(iconfig_1), .weight(weight_1_2), .feature(feature_2_2), .config_load(config_load), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .w_out(weight_1_3), .f_out(feature_1_3), .wf_en(wf_en_1_3), .opsum(psum_1_3));
	PEv2 # (.WIDTH(iWidth)) p_1_4(.clk(clk), .rst(rst), .in_en(wf_en_1_3), .ipsum(psum_2_4), .iconfig(iconfig_1), .weight(weight_1_3), .feature(feature_2_3), .config_load(config_load), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .w_out(weight_1_4), .f_out(feature_1_4), .wf_en(wf_en_1_4), .opsum(psum_1_4));
	PEv2 # (.WIDTH(iWidth)) p_2_1(.clk(clk), .rst(rst), .in_en(wf_en_2_0), .ipsum(psum_3_1), .iconfig(iconfig_2), .weight(weight_2_0), .feature(feature_3_0), .config_load(config_load), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .w_out(weight_2_1), .f_out(feature_2_1), .wf_en(wf_en_2_1), .opsum(psum_2_1));
	PEv2 # (.WIDTH(iWidth)) p_2_2(.clk(clk), .rst(rst), .in_en(wf_en_2_1), .ipsum(psum_3_2), .iconfig(iconfig_2), .weight(weight_2_1), .feature(feature_3_1), .config_load(config_load), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .w_out(weight_2_2), .f_out(feature_2_2), .wf_en(wf_en_2_2), .opsum(psum_2_2));
	PEv2 # (.WIDTH(iWidth)) p_2_3(.clk(clk), .rst(rst), .in_en(wf_en_2_2), .ipsum(psum_3_3), .iconfig(iconfig_2), .weight(weight_2_2), .feature(feature_3_2), .config_load(config_load), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .w_out(weight_2_3), .f_out(feature_2_3), .wf_en(wf_en_2_3), .opsum(psum_2_3));
	PEv2 # (.WIDTH(iWidth)) p_2_4(.clk(clk), .rst(rst), .in_en(wf_en_2_3), .ipsum(psum_3_4), .iconfig(iconfig_2), .weight(weight_2_3), .feature(feature_3_3), .config_load(config_load), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .w_out(weight_2_4), .f_out(feature_2_4), .wf_en(wf_en_2_4), .opsum(psum_2_4));
	PEv2 # (.WIDTH(iWidth)) p_3_1(.clk(clk), .rst(rst), .in_en(wf_en_3_0), .ipsum(psum_4_1), .iconfig(iconfig_3), .weight(weight_3_0), .feature(feature_4_0), .config_load(config_load), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .w_out(weight_3_1), .f_out(feature_3_1), .wf_en(wf_en_3_1), .opsum(psum_3_1));
	PEv2 # (.WIDTH(iWidth)) p_3_2(.clk(clk), .rst(rst), .in_en(wf_en_3_1), .ipsum(psum_4_2), .iconfig(iconfig_3), .weight(weight_3_1), .feature(feature_4_1), .config_load(config_load), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .w_out(weight_3_2), .f_out(feature_3_2), .wf_en(wf_en_3_2), .opsum(psum_3_2));
	PEv2 # (.WIDTH(iWidth)) p_3_3(.clk(clk), .rst(rst), .in_en(wf_en_3_2), .ipsum(psum_4_3), .iconfig(iconfig_3), .weight(weight_3_2), .feature(feature_4_2), .config_load(config_load), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .w_out(weight_3_3), .f_out(feature_3_3), .wf_en(wf_en_3_3), .opsum(psum_3_3));
	PEv2 # (.WIDTH(iWidth)) p_3_4(.clk(clk), .rst(rst), .in_en(wf_en_3_3), .ipsum(psum_4_4), .iconfig(iconfig_3), .weight(weight_3_3), .feature(feature_4_3), .config_load(config_load), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .w_out(weight_3_4), .f_out(feature_3_4), .wf_en(wf_en_3_4), .opsum(psum_3_4));

	AC # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth)) ac_1(.clk(clk), .rst(rst), .in_en(G_1), .ipsum(psum_1_1), .F(F_1), .data_out(dout_1));
	AC # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth)) ac_2(.clk(clk), .rst(rst), .in_en(G_2), .ipsum(psum_1_2), .F(F_2), .data_out(dout_2));
	AC # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth)) ac_3(.clk(clk), .rst(rst), .in_en(G_3), .ipsum(psum_1_3), .F(F_3), .data_out(dout_3));
	AC # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth)) ac_4(.clk(clk), .rst(rst), .in_en(G_4), .ipsum(psum_1_4), .F(F_4), .data_out(dout_4));
endmodule
