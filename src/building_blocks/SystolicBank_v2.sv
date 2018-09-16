`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: SystolicBank_v2
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

module SystolicBank_v2(
	// inputs
	clk,
	rst,
	in_en,
	conv_mm,
	isac,
	isrelu,
	isbn,
	active_1,
	active_2,
	active_3,
	data_in_horz_1,
	data_in_horz_2,
	data_in_horz_3,
	data_in_obli_1,
	data_in_obli_2,
	data_in_obli_3,
	data_in_obli_4,
	data_in_obli_5,
	data_in_obli_6,
	bn_param_in,
	bn_param_in_en,
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
	H_1,
	H_2,
	H_3,
	H_4,
	// outputs
	dout_en_1,
	dout_en_2,
	dout_en_3,
	dout_en_4,
	dout_1,
	dout_2,
	dout_3,
	dout_4
);
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 8;
	parameter oWidth = 8;

	localparam MODE_CONV = 0; localparam MODE_MM = 1;

	// inputs
	input clk, rst, in_en, conv_mm, isac, isrelu, isbn;
	input active_1;
	input active_2;
	input active_3;
	input [7:0] data_in_horz_1;
	input [7:0] data_in_horz_2;
	input [7:0] data_in_horz_3;
	input [7:0] data_in_obli_1;
	input [7:0] data_in_obli_2;
	input [7:0] data_in_obli_3;
	input [7:0] data_in_obli_4;
	input [7:0] data_in_obli_5;
	input [7:0] data_in_obli_6;
	input [15:0] bn_param_in;
	input bn_param_in_en;
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
	input H_1;
	input H_2;
	input H_3;
	input H_4;

	// outputs
	output [7:0] dout_1;
	output [7:0] dout_2;
	output [7:0] dout_3;
	output [7:0] dout_4;

	output dout_en_1;
	output dout_en_2;
	output dout_en_3;
	output dout_en_4;

	logic bypass_en_1_0;
	logic bypass_en_1_1;
	logic bypass_en_1_2;
	logic bypass_en_1_3;
	logic bypass_en_1_4;
	logic bypass_en_2_0;
	logic bypass_en_2_1;
	logic bypass_en_2_2;
	logic bypass_en_2_3;
	logic bypass_en_2_4;
	logic bypass_en_3_0;
	logic bypass_en_3_1;
	logic bypass_en_3_2;
	logic bypass_en_3_3;
	logic bypass_en_3_4;

	logic [7:0] data_in_vert_1_1;
	logic [7:0] data_in_vert_1_2;
	logic [7:0] data_in_vert_1_3;
	logic [7:0] data_in_vert_1_4;
	logic [7:0] data_in_vert_2_1;
	logic [7:0] data_in_vert_2_2;
	logic [7:0] data_in_vert_2_3;
	logic [7:0] data_in_vert_2_4;
	logic [7:0] data_in_vert_3_1;
	logic [7:0] data_in_vert_3_2;
	logic [7:0] data_in_vert_3_3;
	logic [7:0] data_in_vert_3_4;
	logic [7:0] data_in_vert_4_1;
	logic [7:0] data_in_vert_4_2;
	logic [7:0] data_in_vert_4_3;
	logic [7:0] data_in_vert_4_4;

	logic [7:0] data_in_horz_1_0;
	logic [7:0] data_in_horz_1_1;
	logic [7:0] data_in_horz_1_2;
	logic [7:0] data_in_horz_1_3;
	logic [7:0] data_in_horz_1_4;
	logic [7:0] data_in_horz_2_0;
	logic [7:0] data_in_horz_2_1;
	logic [7:0] data_in_horz_2_2;
	logic [7:0] data_in_horz_2_3;
	logic [7:0] data_in_horz_2_4;
	logic [7:0] data_in_horz_3_0;
	logic [7:0] data_in_horz_3_1;
	logic [7:0] data_in_horz_3_2;
	logic [7:0] data_in_horz_3_3;
	logic [7:0] data_in_horz_3_4;
	logic [7:0] data_in_horz_4_0;
	logic [7:0] data_in_horz_4_1;
	logic [7:0] data_in_horz_4_2;
	logic [7:0] data_in_horz_4_3;
	logic [7:0] data_in_horz_4_4;

	logic [7:0] data_in_obli_1_0;
	logic [7:0] data_in_obli_1_1;
	logic [7:0] data_in_obli_1_2;
	logic [7:0] data_in_obli_1_3;
	logic [7:0] data_in_obli_1_4;
	logic [7:0] data_in_obli_2_0;
	logic [7:0] data_in_obli_2_1;
	logic [7:0] data_in_obli_2_2;
	logic [7:0] data_in_obli_2_3;
	logic [7:0] data_in_obli_2_4;
	logic [7:0] data_in_obli_3_0;
	logic [7:0] data_in_obli_3_1;
	logic [7:0] data_in_obli_3_2;
	logic [7:0] data_in_obli_3_3;
	logic [7:0] data_in_obli_3_4;
	logic [7:0] data_in_obli_4_0;
	logic [7:0] data_in_obli_4_1;
	logic [7:0] data_in_obli_4_2;
	logic [7:0] data_in_obli_4_3;
	logic [7:0] data_in_obli_4_4;

	logic [15:0] bn_param_out_1;
	logic [15:0] bn_param_out_2;
	logic [15:0] bn_param_out_3;
	logic [15:0] bn_param_out_4;

	logic bn_param_out_en_1;
	logic bn_param_out_en_2;
	logic bn_param_out_en_3;
	logic bn_param_out_en_4;

	assign data_in_vert_4_1 = (conv_mm == MODE_CONV)? 0: data_in_obli_3;
	assign data_in_vert_4_2 = (conv_mm == MODE_CONV)? 0: data_in_obli_4;
	assign data_in_vert_4_3 = (conv_mm == MODE_CONV)? 0: data_in_obli_5;
	assign data_in_vert_4_4 = (conv_mm == MODE_CONV)? 0: data_in_obli_6;

	assign bypass_en_1_0 = in_en;
	assign bypass_en_2_0 = in_en;
	assign bypass_en_3_0 = in_en;

	assign data_in_horz_1_0 = data_in_horz_1;
	assign data_in_horz_2_0 = data_in_horz_2;
	assign data_in_horz_3_0 = data_in_horz_3;

	assign data_in_obli_2_0 = (conv_mm == MODE_CONV)? data_in_obli_1: 0;
	assign data_in_obli_3_0 = (conv_mm == MODE_CONV)? data_in_obli_2: 0;
	assign data_in_obli_4_0 = (conv_mm == MODE_CONV)? data_in_obli_3: 0;
	assign data_in_obli_4_1 = (conv_mm == MODE_CONV)? data_in_obli_4: 0;
	assign data_in_obli_4_2 = (conv_mm == MODE_CONV)? data_in_obli_5: 0;
	assign data_in_obli_4_3 = (conv_mm == MODE_CONV)? data_in_obli_6: 0;

	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_1_1(.clk(clk), .rst(rst), .in_en(bypass_en_1_0), .data_vert(data_in_vert_2_1), .active(active_1), .data_horz(data_in_horz_1_0), .data_obli(data_in_obli_2_0), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .H(H_1), .horz_out(data_in_horz_1_1), .obli_out(data_in_obli_1_1), .bypass_en(bypass_en_1_1), .opsum(data_in_vert_1_1));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_1_2(.clk(clk), .rst(rst), .in_en(bypass_en_1_1), .data_vert(data_in_vert_2_2), .active(active_1), .data_horz(data_in_horz_1_1), .data_obli(data_in_obli_2_1), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .H(H_2), .horz_out(data_in_horz_1_2), .obli_out(data_in_obli_1_2), .bypass_en(bypass_en_1_2), .opsum(data_in_vert_1_2));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_1_3(.clk(clk), .rst(rst), .in_en(bypass_en_1_2), .data_vert(data_in_vert_2_3), .active(active_1), .data_horz(data_in_horz_1_2), .data_obli(data_in_obli_2_2), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .H(H_3), .horz_out(data_in_horz_1_3), .obli_out(data_in_obli_1_3), .bypass_en(bypass_en_1_3), .opsum(data_in_vert_1_3));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_1_4(.clk(clk), .rst(rst), .in_en(bypass_en_1_3), .data_vert(data_in_vert_2_4), .active(active_1), .data_horz(data_in_horz_1_3), .data_obli(data_in_obli_2_3), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .H(H_4), .horz_out(data_in_horz_1_4), .obli_out(data_in_obli_1_4), .bypass_en(bypass_en_1_4), .opsum(data_in_vert_1_4));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_2_1(.clk(clk), .rst(rst), .in_en(bypass_en_2_0), .data_vert(data_in_vert_3_1), .active(active_2), .data_horz(data_in_horz_2_0), .data_obli(data_in_obli_3_0), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .H(H_1), .horz_out(data_in_horz_2_1), .obli_out(data_in_obli_2_1), .bypass_en(bypass_en_2_1), .opsum(data_in_vert_2_1));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_2_2(.clk(clk), .rst(rst), .in_en(bypass_en_2_1), .data_vert(data_in_vert_3_2), .active(active_2), .data_horz(data_in_horz_2_1), .data_obli(data_in_obli_3_1), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .H(H_2), .horz_out(data_in_horz_2_2), .obli_out(data_in_obli_2_2), .bypass_en(bypass_en_2_2), .opsum(data_in_vert_2_2));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_2_3(.clk(clk), .rst(rst), .in_en(bypass_en_2_2), .data_vert(data_in_vert_3_3), .active(active_2), .data_horz(data_in_horz_2_2), .data_obli(data_in_obli_3_2), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .H(H_3), .horz_out(data_in_horz_2_3), .obli_out(data_in_obli_2_3), .bypass_en(bypass_en_2_3), .opsum(data_in_vert_2_3));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_2_4(.clk(clk), .rst(rst), .in_en(bypass_en_2_3), .data_vert(data_in_vert_3_4), .active(active_2), .data_horz(data_in_horz_2_3), .data_obli(data_in_obli_3_3), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .H(H_4), .horz_out(data_in_horz_2_4), .obli_out(data_in_obli_2_4), .bypass_en(bypass_en_2_4), .opsum(data_in_vert_2_4));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_3_1(.clk(clk), .rst(rst), .in_en(bypass_en_3_0), .data_vert(data_in_vert_4_1), .active(active_3), .data_horz(data_in_horz_3_0), .data_obli(data_in_obli_4_0), .A(A_1), .B(B_1), .C(C_1), .D(D_1), .E(E_1), .H(H_1), .horz_out(data_in_horz_3_1), .obli_out(data_in_obli_3_1), .bypass_en(bypass_en_3_1), .opsum(data_in_vert_3_1));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_3_2(.clk(clk), .rst(rst), .in_en(bypass_en_3_1), .data_vert(data_in_vert_4_2), .active(active_3), .data_horz(data_in_horz_3_1), .data_obli(data_in_obli_4_1), .A(A_2), .B(B_2), .C(C_2), .D(D_2), .E(E_2), .H(H_2), .horz_out(data_in_horz_3_2), .obli_out(data_in_obli_3_2), .bypass_en(bypass_en_3_2), .opsum(data_in_vert_3_2));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_3_3(.clk(clk), .rst(rst), .in_en(bypass_en_3_2), .data_vert(data_in_vert_4_3), .active(active_3), .data_horz(data_in_horz_3_2), .data_obli(data_in_obli_4_2), .A(A_3), .B(B_3), .C(C_3), .D(D_3), .E(E_3), .H(H_3), .horz_out(data_in_horz_3_3), .obli_out(data_in_obli_3_3), .bypass_en(bypass_en_3_3), .opsum(data_in_vert_3_3));
	PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_3_4(.clk(clk), .rst(rst), .in_en(bypass_en_3_3), .data_vert(data_in_vert_4_4), .active(active_3), .data_horz(data_in_horz_3_3), .data_obli(data_in_obli_4_3), .A(A_4), .B(B_4), .C(C_4), .D(D_4), .E(E_4), .H(H_4), .horz_out(data_in_horz_3_4), .obli_out(data_in_obli_3_4), .bypass_en(bypass_en_3_4), .opsum(data_in_vert_3_4));

	ACv2 # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth), .BN_SCALE_WIDTH(oWidth), .BN_SHIFT_WIDTH(oWidth)) ac_1(.clk(clk), .rst(rst), .config_bits({isac, isrelu, isbn}), .in_en(G_1), .ipsum(data_in_vert_1_1), .F(F_1), .bn_param_in_en(bn_param_in_en), .bn_param_in(bn_param_in), .bn_param_out(bn_param_out_1), .bn_param_out_en(bn_param_out_en_1), .data_out_en(dout_en_1), .data_out(dout_1));
	ACv2 # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth), .BN_SCALE_WIDTH(oWidth), .BN_SHIFT_WIDTH(oWidth)) ac_2(.clk(clk), .rst(rst), .config_bits({isac, isrelu, isbn}), .in_en(G_2), .ipsum(data_in_vert_1_2), .F(F_2), .bn_param_in_en(bn_param_out_en_1), .bn_param_in(bn_param_out_1), .bn_param_out(bn_param_out_2), .bn_param_out_en(bn_param_out_en_2), .data_out_en(dout_en_2), .data_out(dout_2));
	ACv2 # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth), .BN_SCALE_WIDTH(oWidth), .BN_SHIFT_WIDTH(oWidth)) ac_3(.clk(clk), .rst(rst), .config_bits({isac, isrelu, isbn}), .in_en(G_3), .ipsum(data_in_vert_1_3), .F(F_3), .bn_param_in_en(bn_param_out_en_2), .bn_param_in(bn_param_out_2), .bn_param_out(bn_param_out_3), .bn_param_out_en(bn_param_out_en_3), .data_out_en(dout_en_3), .data_out(dout_3));
	ACv2 # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth), .BN_SCALE_WIDTH(oWidth), .BN_SHIFT_WIDTH(oWidth)) ac_4(.clk(clk), .rst(rst), .config_bits({isac, isrelu, isbn}), .in_en(G_4), .ipsum(data_in_vert_1_4), .F(F_4), .bn_param_in_en(bn_param_out_en_3), .bn_param_in(bn_param_out_3), .bn_param_out(bn_param_out_4), .bn_param_out_en(bn_param_out_en_4), .data_out_en(dout_en_4), .data_out(dout_4));
endmodule
