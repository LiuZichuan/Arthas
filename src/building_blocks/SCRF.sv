`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liu Zichuan
// 
// Create Date: 09/01/2017 09:40:47 PM
// Design Name: Arthas
// Module Name: System Config Registerr File (SCRF)
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

module SCRF(
	dfsm_config,
	ssp_config,
	quabuf_config,
	singbuf_config,
	mode_conv_mm,
	isac,
	isrelu,
	isbn,
	pe_config_1_1,
	pe_config_1_2,
	pe_config_1_3,
	pe_config_2_1,
	pe_config_2_2,
	pe_config_2_3,
	iport_configbts_0,
	iport_configbts_1,
	iport_configbts_2,
	iport_configbts_3,
	iport_configbts_4,
	iport_configbts_5,
	iport_configbts_6,
	iport_configbts_7,
	iport_configbts_8,
	iport_configbts_9,
	iport_configbts_10,
	iport_configbts_11,
	oport_configbits_0,
	oport_configbits_1,
);

	output [22:0] dfsm_config;
	output [19:0] ssp_config;
	output [37:0] quabuf_config;
	output [25:0] singbuf_config;
	output mode_conv_mm;
	output isac;
	output isrelu;
	output isbn;
	output pe_config_1_1;
	output pe_config_1_2;
	output pe_config_1_3;
	output pe_config_2_1;
	output pe_config_2_2;
	output pe_config_2_3;
	output [55:0] iport_configbts_0;
	output [55:0] iport_configbts_1;
	output [55:0] iport_configbts_2;
	output [55:0] iport_configbts_3;
	output [55:0] iport_configbts_4;
	output [55:0] iport_configbts_5;
	output [55:0] iport_configbts_6;
	output [55:0] iport_configbts_7;
	output [55:0] iport_configbts_8;
	output [55:0] iport_configbts_9;
	output [55:0] iport_configbts_10;
	output [55:0] iport_configbts_11;
	output [55:0] oport_configbits_0;
	output [55:0] oport_configbits_1;

	assign dfsm_config = 524387;
	assign quabuf_config = 38'd206695305224;
	assign ssp_config = 12;
	assign singbuf_config = 4104;
	assign mode_conv_mm = 0;
	assign isac = 1;
	assign isrelu = 1;
	assign isbn = 1;
	assign pe_config_1_1 = 1;
	assign pe_config_1_2 = 1;
	assign pe_config_1_3 = 1;
	assign pe_config_2_1 = 1;
	assign pe_config_2_2 = 1;
	assign pe_config_2_3 = 1;
	assign iport_configbts_0 = 55'd38654705670;
	assign iport_configbts_1 = 55'd40265318406;
	assign iport_configbts_2 = 55'd41875931142;
	assign iport_configbts_3 = 55'd43486543878;
	assign iport_configbts_4 = 55'd45097156614;
	assign iport_configbts_5 = 55'd46707769350;
	assign iport_configbts_6 = 55'd24;
	assign iport_configbts_7 = 55'd6442450968;
	assign iport_configbts_8 = 55'd12884901912;
	assign iport_configbts_9 = 55'd19327352856;
	assign iport_configbts_10 = 55'd25769803800;
	assign iport_configbts_11 = 55'd32212254744;

endmodule
