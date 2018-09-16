%% Create top-level design of Arthas
function CreateArthasTop()
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/Arthas_top_v1.sv'; end
ArchConfig();
CreateSysConfigRegFile(sess, nRows, nCols, nBanks, iWidth, oWidth, rAddrWidth, rDataWidth, rReqWidth, wAddrWidth, wDataWidth, wReqWidth, ...
                       QUABUF_MAX_nDATA, QUABUF_MAX_nCOL, QUABUF_MAX_nREP, QUABUF_MAX_nPERIOD, ...
                       DFSM_MAX_nPERIOD, DFSM_MAX_nLMAC, DFSM_MAX_nSHFT, ...
                       SSP_MAX_nData, SSP_MAX_nPeriod, SINGBUF_MAX_nDATA, SINGBUF_MAX_nPERIOD)
text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: Arthas top'];
text{end+1} = ['// Project Name: '];
text{end+1} = ['// Target Devices: '];
text{end+1} = ['// Tool Versions: '];
text{end+1} = ['// Description: '];
text{end+1} = ['// '];
text{end+1} = ['// Dependencies:'];
text{end+1} = ['// '];
text{end+1} = ['// Revision: 0.1'];
text{end+1} = ['// Revision 0.01 - File Created'];
text{end+1} = ['// Additional Comments:'];
text{end+1} = ['//'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = [''];
text{end+1} = ['module Arthas_top_v1('];
text{end+1} = [char(9), 'clk_arr,'];
text{end+1} = [char(9), 'rst,'];
text{end+1} = [char(9), '// DDR3 inouts'];
text{end+1} = [char(9), 'ddr3_dq,'];
text{end+1} = [char(9), 'ddr3_dqs_n,'];
text{end+1} = [char(9), 'ddr3_dqs_p,'];
text{end+1} = [char(9), '// DDR3 outputs'];
text{end+1} = [char(9), 'ddr3_addr,'];
text{end+1} = [char(9), 'ddr3_ba,'];
text{end+1} = [char(9), 'ddr3_ras_n,'];
text{end+1} = [char(9), 'ddr3_cas_n,'];
text{end+1} = [char(9), 'ddr3_we_n,'];
text{end+1} = [char(9), 'ddr3_reset_n,'];
text{end+1} = [char(9), 'ddr3_ck_p,'];
text{end+1} = [char(9), 'ddr3_ck_n,'];
text{end+1} = [char(9), 'ddr3_cke,'];
text{end+1} = [char(9), 'ddr3_cs_n,'];
text{end+1} = [char(9), 'ddr3_dm,'];
text{end+1} = [char(9), 'ddr3_odt,'];
text{end+1} = [char(9), '// DDR3 inputs (differential system clock)'];
text{end+1} = [char(9), 'sys_clk_p,'];
text{end+1} = [char(9), 'sys_clk_n,'];
text{end+1} = [char(9), 'sys_rst,'];
text{end+1} = [char(9), '// DDR3 inputs (reference clock)'];
text{end+1} = [char(9), 'clk_ref_p,'];
text{end+1} = [char(9), 'clk_ref_n,'];
text{end+1} = [');'];
text{end+1} = [''];

text{end+1} = [char(9), 'parameter nBanks = ', num2str(nBanks),';'];
text{end+1} = [char(9), 'parameter nCols = ', num2str(nCols),';'];
text{end+1} = [char(9), 'parameter nRows = ', num2str(nRows),';'];
text{end+1} = [char(9), 'parameter iWidth = ', num2str(iWidth),';'];
text{end+1} = [char(9), 'parameter oWidth = ', num2str(oWidth),';'];
text{end+1} = [char(9), 'parameter rAddrWidth = ', num2str(rAddrWidth),';'];
text{end+1} = [char(9), 'parameter rDataWidth = ', num2str(rDataWidth),';'];
text{end+1} = [char(9), 'parameter rReqWidth = ', num2str(rReqWidth),';'];
text{end+1} = [char(9), 'parameter wAddrWidth = ', num2str(wAddrWidth),';'];
text{end+1} = [char(9), 'parameter wDataWidth = ', num2str(wDataWidth),';'];
text{end+1} = [char(9), 'parameter wReqWidth = ', num2str(wReqWidth),';'];
text{end+1} = [char(9), 'parameter wMaskWidth = ', num2str(wMaskWidth),';'];
text{end+1} = [char(9), 'parameter DFSM_MAX_nPERIOD = ', num2str(DFSM_MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter DFSM_MAX_nLMAC = ', num2str(DFSM_MAX_nLMAC),';'];
text{end+1} = [char(9), 'parameter DFSM_MAX_nSHFT = ', num2str(DFSM_MAX_nSHFT),';'];
text{end+1} = [char(9), 'parameter SSP_MAX_nPeriod = ', num2str(SSP_MAX_nPeriod),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nDATA = ', num2str(QUABUF_MAX_nDATA),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nCOL = ', num2str(QUABUF_MAX_nCOL),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nPERIOD = ', num2str(QUABUF_MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nREP = ', num2str(QUABUF_MAX_nREP),';'];
text{end+1} = [char(9), 'parameter SINGBUF_MAX_nDATA = ', num2str(SINGBUF_MAX_nDATA),';'];
text{end+1} = [char(9), 'parameter SINGBUF_MAX_nPERIOD = ', num2str(SINGBUF_MAX_nPERIOD),';'];
text{end+1} = [''];

text{end+1} = [char(9), 'localparam SSP_MAX_nData = nCols;'];
text{end+1} = [char(9), 'localparam DFSM_CONFIGBIT_WIDTH = $clog2(DFSM_MAX_nPERIOD) + $clog2(DFSM_MAX_nLMAC) + $clog2(DFSM_MAX_nSHFT);'];
text{end+1} = [char(9), 'localparam SSP_CONFIGBIT_WIDTH = $clog2(SSP_MAX_nData) + $clog2(SSP_MAX_nPeriod);'];
text{end+1} = [char(9), 'localparam QUABUF_CONFIGBIT_WIDTH = $clog2(QUABUF_MAX_nDATA) + $clog2(QUABUF_MAX_nCOL) + $clog2(QUABUF_MAX_nREP) + $clog2(QUABUF_MAX_nPERIOD);'];
text{end+1} = [char(9), 'localparam SINGBUF_CONFIGBIT_WIDTH = $clog2(SINGBUF_MAX_nDATA) + $clog2(SINGBUF_MAX_nPERIOD);'];
text{end+1} = [char(9), 'localparam MODE_CONV = 0; localparam MODE_MM = 1;'];
text{end+1} = [''];

text{end+1} = [char(9), 'input clk_arr;'];
text{end+1} = [char(9), 'input rst;'];

text{end+1} = [char(9), '// DDR3 inouts'];
text{end+1} = [char(9), 'inout [7:0] ddr3_dq;'];
text{end+1} = [char(9), 'inout [0:0] ddr3_dqs_n;'];
text{end+1} = [char(9), 'inout [0:0] ddr3_dqs_p;'];
text{end+1} = [''];
text{end+1} = [char(9), '// DDR3 outputs'];
text{end+1} = [char(9), 'output [13:0] ddr3_addr;'];
text{end+1} = [char(9), 'output [2:0] ddr3_ba;'];
text{end+1} = [char(9), 'output ddr3_ras_n;'];
text{end+1} = [char(9), 'output ddr3_cas_n;'];
text{end+1} = [char(9), 'output ddr3_we_n;'];
text{end+1} = [char(9), 'output ddr3_reset_n;'];
text{end+1} = [char(9), 'output [0:0] ddr3_ck_p;'];
text{end+1} = [char(9), 'output [0:0] ddr3_ck_n;'];
text{end+1} = [char(9), 'output [0:0] ddr3_cke;'];
text{end+1} = [char(9), 'output [0:0] ddr3_cs_n;'];
text{end+1} = [char(9), 'output [0:0] ddr3_dm;'];
text{end+1} = [char(9), 'output [0:0] ddr3_odt;'];
text{end+1} = [''];
text{end+1} = [char(9), '// DDR3 inputs (differential system clock)'];
text{end+1} = [char(9), 'input sys_clk_p;'];
text{end+1} = [char(9), 'input sys_clk_n;'];
text{end+1} = [char(9), 'input sys_rst;'];
text{end+1} = [''];
text{end+1} = [char(9), '// DDR3 inputs (reference clock)'];
text{end+1} = [char(9), 'input clk_ref_p;'];
text{end+1} = [char(9), 'input clk_ref_n;'];
text{end+1} = [''];

% DRAM signals
text{end+1} = [char(9), '// user interface signals'];
text{end+1} = [char(9), 'logic [27:0]      app_addr;'];
text{end+1} = [char(9), 'logic [2:0]       app_cmd;'];
text{end+1} = [char(9), 'logic             app_en;'];
text{end+1} = [char(9), 'logic [63:0]      app_wdf_data;'];
text{end+1} = [char(9), 'logic             app_wdf_end;'];
text{end+1} = [char(9), 'logic [7:0]       app_wdf_mask;'];
text{end+1} = [char(9), 'logic             app_wdf_wren;'];
text{end+1} = [char(9), 'logic [63:0]      app_rd_data;'];
text{end+1} = [char(9), 'logic             app_rd_data_end;'];
text{end+1} = [char(9), 'logic             app_rd_data_valid;'];
text{end+1} = [char(9), 'logic             app_rdy;'];
text{end+1} = [char(9), 'logic             app_wdf_rdy;'];
text{end+1} = [char(9), 'logic             app_sr_req;'];
text{end+1} = [char(9), 'logic             app_ref_req;'];
text{end+1} = [char(9), 'logic             app_zq_req;'];
text{end+1} = [char(9), 'logic             app_sr_active;'];
text{end+1} = [char(9), 'logic             app_ref_ack;'];
text{end+1} = [char(9), 'logic             app_zq_ack;'];
text{end+1} = [char(9), 'logic             clk_bus;'];
text{end+1} = [char(9), 'logic             rst_bus;'];
text{end+1} = [char(9), 'logic             init_calib_complete;'];
text{end+1} = [''];

% SysArray signals
CreateSystolicArray_v2(nBanks, nRows, nCols, iWidth, oWidth, DFSM_MAX_nPERIOD, DFSM_MAX_nLMAC, DFSM_MAX_nSHFT, SSP_MAX_nPeriod, ...
                       QUABUF_MAX_nDATA, QUABUF_MAX_nCOL, QUABUF_MAX_nPERIOD, QUABUF_MAX_nREP, SINGBUF_MAX_nPERIOD, SINGBUF_MAX_nDATA)
CreateSystolicBank_v2(nRows, nCols, iWidth, oWidth)
text{end+1} = [char(9), 'logic [DFSM_CONFIGBIT_WIDTH-1:0] dfsm_config;'];
text{end+1} = [char(9), 'logic [SSP_CONFIGBIT_WIDTH-1:0] ssp_config;'];
text{end+1} = [char(9), 'logic [QUABUF_CONFIGBIT_WIDTH-1:0] quabuf_config;'];
text{end+1} = [char(9), 'logic [SINGBUF_CONFIGBIT_WIDTH-1:0] singbuf_config;'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'logic pe_config_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] data_horz_', num2str(i), '_', num2str(j), ';']; end, end
% for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'logic data_horz_in_en_', num2str(i), '_', num2str(j), ';']; end, end
% for k = 1: nRows+nCols-1, text{end+1} = [char(9), 'logic data_obli_in_en_', num2str(k),';']; end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] data_obli_', num2str(j), ';']; end
for i = 1:nBanks, text{end+1} = [char(9), 'logic [', num2str(2*oWidth-1),':0] data_bn_', num2str(i), ';']; end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'logic data_horz_in_en_', num2str(i), '_', num2str(j), ';']; end, end
for k = 1: nRows+nCols-1, text{end+1} = [char(9), 'logic data_obli_in_en_', num2str(k),';']; end
text{end+1} = [''];


for i = 1:nBanks, text{end+1} = [char(9), 'logic [', num2str(oWidth-1),':0] dout_', num2str(i), ';']; end
for i = 1:nBanks text{end+1} = [char(9), 'logic dout_en_', num2str(i), ';']; end
for i = 1:nCols+nRows-1, text{end+1} = [char(9), 'logic data_obli_wrdy_', num2str(i), ';']; end
for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'logic data_horz_wrdy_', num2str(n), '_', num2str(i), ';'];end, end
for i = 1:nBanks, text{end+1} = [char(9), 'logic data_bn_wrdy_', num2str(i), ';']; end
text{end+1} = [''];

% IBC signals
CreateInputBufferController(nRows+nCols-1, rAddrWidth, rDataWidth);
text{end+1} = [char(9), 'logic [rReqWidth-1:0] ibc_r_req;'];
text{end+1} = [char(9), 'logic mem2ibc_en;'];
text{end+1} = [char(9), 'logic [rDataWidth-1:0] mem2ibc_data;'];
text{end+1} = [char(9), 'logic mem2ibc_data_en;'];
text{end+1} = [char(9), 'logic [rAddrWidth-1:0] ibc2mem_r_addr;'];
text{end+1} = [char(9), 'logic ibc2mem_r_vld;'];
text{end+1} = [char(9), 'logic [rDataWidth-1:0] ibc2pc_data;'];
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'logic ibc2pc_data_en_', num2str(i), ';']; end
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'logic ibc_tk_', num2str(i), ';']; end
text{end+1} = [''];

% OBC signals
CreateOutputBufferController(nBanks, wAddrWidth, wDataWidth);
for i = 0:nBanks-1, text{end+1} = [char(9), 'logic obc_tk_', num2str(i), ';']; end
text{end+1} = [char(9), 'logic [wReqWidth-1:0] obc_w_req;'];
text{end+1} = [char(9), 'logic obc_w_req_en;'];
text{end+1} = [char(9), 'logic mem2obc_en;'];
text{end+1} = [char(9), 'logic [wAddrWidth-1:0] obc2mem_w_addr;'];
text{end+1} = [char(9), 'logic [wDataWidth-1:0] obc2mem_w_data;'];
text{end+1} = [char(9), 'logic obc2mem_w_vld;'];
text{end+1} = [''];

%% Configuration
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'logic [2*rAddrWidth-1:0] iport_configbits_', num2str(i), ';']; end
for i = 0:nBanks-1, text{end+1} = [char(9), 'logic [2*wAddrWidth-1:0] oport_configbits_', num2str(i), ';']; end
text{end+1} = [''];
text{end+1} = [char(9), '// System Config'];
text{end+1} = [char(9), 'SCRF sys_config_reg_file ('];
text{end+1} = [char(9), char(9), '.dfsm_config(dfsm_config),'];
text{end+1} = [char(9), char(9), '.ssp_config(ssp_config),'];
text{end+1} = [char(9), char(9), '.quabuf_config(quabuf_config),'];
text{end+1} = [char(9), char(9), '.singbuf_config(singbuf_config),'];
text{end+1} = [char(9), char(9), '.mode_conv_mm(mode_conv_mm),'];
text{end+1} = [char(9), char(9), '.isac(isac),'];
text{end+1} = [char(9), char(9), '.isrelu(isrelu),'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), '.pe_config_', num2str(i), '_', num2str(j), '(pe_config_', num2str(i), '_', num2str(j) ,'),']; end, end
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), char(9), '.iport_configbits_', num2str(i),'(iport_configbits_', num2str(i),'),']; end
for i = 0:nBanks-1, text{end+1} = [char(9), char(9), '.oport_configbits_', num2str(i), '(oport_configbits_', num2str(i),'),']; end
text{end+1} = [char(9), char(9), '.isbn(isbn)'];
text{end+1} = [char(9), ');'];
text{end+1} = [''];

%% DRAM
text{end+1} = [char(9), 'mig_7series_0 u_mig_7series_0 ('];
text{end+1} = [char(9), char(9), '// Memory interface ports'];
text{end+1} = [char(9), char(9), '.ddr3_addr(ddr3_addr),'];
text{end+1} = [char(9), char(9), '.ddr3_ba(ddr3_ba),'];
text{end+1} = [char(9), char(9), '.ddr3_cas_n(ddr3_cas_n),'];
text{end+1} = [char(9), char(9), '.ddr3_ck_n(ddr3_ck_n),'];
text{end+1} = [char(9), char(9), '.ddr3_ck_p(ddr3_ck_p),'];
text{end+1} = [char(9), char(9), '.ddr3_cke(ddr3_cke),'];
text{end+1} = [char(9), char(9), '.ddr3_ras_n(ddr3_ras_n),']; 
text{end+1} = [char(9), char(9), '.ddr3_reset_n(ddr3_reset_n),']; 
text{end+1} = [char(9), char(9), '.ddr3_we_n(ddr3_we_n),']; 
text{end+1} = [char(9), char(9), '.ddr3_dq(ddr3_dq),'];  
text{end+1} = [char(9), char(9), '.ddr3_dqs_n(ddr3_dqs_n),'];  
text{end+1} = [char(9), char(9), '.ddr3_dqs_p(ddr3_dqs_p),'];  
text{end+1} = [char(9), char(9), '.ddr3_cs_n(ddr3_cs_n),'];  
text{end+1} = [char(9), char(9), '.ddr3_dm(ddr3_dm),']; 
text{end+1} = [char(9), char(9), '.ddr3_odt(ddr3_odt),']; 
text{end+1} = [char(9), char(9), '// System Clock Ports'];
text{end+1} = [char(9), char(9), '.sys_clk_p(sys_clk_p),'];  
text{end+1} = [char(9), char(9), '.sys_clk_n(sys_clk_n),'];  
text{end+1} = [char(9), char(9), '.sys_rst(sys_rst),']; 
text{end+1} = [char(9), char(9), '// Reference Clock Ports'];
text{end+1} = [char(9), char(9), '.clk_ref_p(clk_ref_p),'];  
text{end+1} = [char(9), char(9), '.clk_ref_n(clk_ref_n),'];  
text{end+1} = [char(9), char(9), '// Application interface ports'];
text{end+1} = [char(9), char(9), '.app_addr(app_addr),'];  
text{end+1} = [char(9), char(9), '.app_cmd(app_cmd),'];  
text{end+1} = [char(9), char(9), '.app_en(app_en),'];  
text{end+1} = [char(9), char(9), '.app_wdf_data(app_wdf_data),'];  
text{end+1} = [char(9), char(9), '.app_wdf_end(app_wdf_end),']; 
text{end+1} = [char(9), char(9), '.app_wdf_wren(app_wdf_wren),'];  
text{end+1} = [char(9), char(9), '.app_rd_data(app_rd_data),']; 
text{end+1} = [char(9), char(9), '.app_rd_data_end(app_rd_data_end),'];  
text{end+1} = [char(9), char(9), '.app_rd_data_valid(app_rd_data_valid),'];  
text{end+1} = [char(9), char(9), '.app_rdy(app_rdy),'];  
text{end+1} = [char(9), char(9), '.app_wdf_rdy(app_wdf_rdy),'];  
text{end+1} = [char(9), char(9), '.app_sr_req(0),'];  
text{end+1} = [char(9), char(9), '.app_ref_req(0),'];
text{end+1} = [char(9), char(9), '.app_zq_req(app_zq_req),'];
text{end+1} = [char(9), char(9), '.app_sr_active(app_sr_active),']; 
text{end+1} = [char(9), char(9), '.app_ref_ack(app_ref_ack),']; 
text{end+1} = [char(9), char(9), '.app_zq_ack(app_zq_ack),']; 
text{end+1} = [char(9), char(9), '.app_wdf_mask(app_wdf_mask),'];  
text{end+1} = [char(9), char(9), '.ui_clk(clk_bus),'];  
text{end+1} = [char(9), char(9), '.ui_clk_sync_rst(rst_bus),']; 
text{end+1} = [char(9), char(9), '.init_calib_complete(init_calib_complete)'];  
text{end+1} = [char(9), ');'];  

%% SysArray
pe_config = [char(9), char(9), ];
data_horz = [char(9), char(9), ];
data_horz_wrdy = [char(9), char(9), ];
data_horz_in_en = [char(9), char(9), ];
data_obli_wrdy = [char(9), char(9), ];
data_obli = [char(9), char(9), ];
data_obli_in_en = [char(9), char(9), ];
dout = [char(9), char(9), ];
dout_en = [char(9), char(9), ];
data_bn = [char(9), char(9), ];
data_bn_en = [char(9), char(9), ];
data_bn_wrdy = [char(9), char(9), ];
for i = 1:nBanks
    for j = 1:nRows
        data_horz = [data_horz, '.data_horz_', num2str(i), '_', num2str(j),'(data_horz_', num2str(i), '_', num2str(j), '), '];
        data_horz_in_en = [data_horz_in_en, '.data_horz_in_en_', num2str(i), '_', num2str(j),'(w_in_en), '];
        data_horz_wrdy = [data_horz_wrdy, '.data_horz_wrdy_', num2str(i), '_', num2str(j),'(data_horz_wrdy_', num2str(i), '_', num2str(j), '), '];
        pe_config = [pe_config, '.pe_config_', num2str(i), '_', num2str(j),'(pe_config_', num2str(i), '_', num2str(j), '), '];
    end
end
for j = 1:(nRows+nCols-1)
    data_obli = [data_obli, '.data_obli_', num2str(j),'(data_obli_', num2str(j), '), '];
    data_obli_in_en = [data_obli_in_en, '.data_obli_in_en_', num2str(j),'(f_in_en), '];
    data_obli_wrdy = [data_obli_wrdy, '.data_obli_wrdy_', num2str(j),'(data_obli_wrdy_', num2str(j), '), '];
end
for i = 1:nBanks
    dout = [dout, '.dout_', num2str(i), '(dout_', num2str(i), '), '];
    dout_en = [dout_en, '.dout_en_', num2str(i), '(dout_en_', num2str(i), '), '];
end
for i = 1:nBanks
    data_bn = [data_bn, '.data_bn_', num2str(i), '(data_bn_', num2str(i), '), '];
    data_bn_en = [data_bn_en, '.data_bn_we_', num2str(i), '(bn_in_en), '];
    data_bn_wrdy = [data_bn_wrdy, '.data_bn_wrdy_', num2str(i), '(data_bn_wrdy_', num2str(i), '), '];
end
text{end+1} = [''];

text{end+1} = [char(9), 'SystolicArray_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nBanks(nBanks), .nRows(nRows), .nCols(nCols), '];
text{end+1} = [char(9), char(9), char(9), char(9), char(9), char(9), '.DFSM_MAX_nPERIOD(DFSM_MAX_nPERIOD), .DFSM_MAX_nLMAC(DFSM_MAX_nLMAC), .DFSM_MAX_nSHFT(DFSM_MAX_nSHFT), '];
text{end+1} = [char(9), char(9), char(9), char(9), char(9), char(9), '.QUABUF_MAX_nDATA(QUABUF_MAX_nDATA), .QUABUF_MAX_nCOL(QUABUF_MAX_nCOL), .QUABUF_MAX_nPERIOD(QUABUF_MAX_nPERIOD), .QUABUF_MAX_nREP(QUABUF_MAX_nREP), '];
text{end+1} = [char(9), char(9), char(9), char(9), char(9), char(9), '.SINGBUF_MAX_nPERIOD(SINGBUF_MAX_nPERIOD), .SINGBUF_MAX_nDATA(SINGBUF_MAX_nDATA), '];
text{end+1} = [char(9), char(9), char(9), char(9), char(9), char(9), '.SSP_MAX_nPeriod(SSP_MAX_nPeriod))'];
text{end+1} = [char(9), 'U(.clk(clk), .clk_mem(clk), .rst(rst), .start(start), .mode_conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), '];
text{end+1} = pe_config;
text{end+1} = data_horz; 
text{end+1} = data_horz_in_en; 
text{end+1} = data_obli;
text{end+1} = data_obli_in_en; 
text{end+1} = data_horz_wrdy;
text{end+1} = data_obli_wrdy; 
text{end+1} = dout; 
text{end+1} = dout_en; 
text{end+1} = data_bn; 
text{end+1} = data_bn_en; 
text{end+1} = data_bn_wrdy;
text{end+1} = [char(9), char(9), '.dfsm_config(dfsm_config), .ssp_config(ssp_config), .quabuf_config(quabuf_config),'];
text{end+1} = [char(9), char(9), '.singbuf_config(singbuf_config)'];
text{end+1} = [char(9), ');'];
text{end+1} = [''];

%% MIF
text{end+1} = [char(9), 'MIF # (.rAddrWidth(rAddrWidth), .rDataWidth(rDataWidth), .rReqWidth(rReqWidth), .wAddrWidth(wAddrWidth), .wDataWidth(wDataWidth), .wReqWidth(wReqWidth), .wMaskWidth(wMaskWidth))'];
text{end+1} = [char(9), 'mif_inst ('];
text{end+1} = [char(9), char(9), '.start(start),'];  
text{end+1} = [char(9), char(9), '// inputs from MIG'];
text{end+1} = [char(9), char(9), '.clk_bus(clk_bus),'];  
text{end+1} = [char(9), char(9), '.rst_bus(rst_bus),']; 
text{end+1} = [char(9), char(9), '.app_rd_data(app_rd_data),']; 
text{end+1} = [char(9), char(9), '.app_rd_data_end(app_rd_data_end),'];  
text{end+1} = [char(9), char(9), '.app_rd_data_valid(app_rd_data_valid),'];  
text{end+1} = [char(9), char(9), '.app_rdy(app_rdy),'];
text{end+1} = [char(9), char(9), '.app_wdf_rdy(app_wdf_rdy),'];  
text{end+1} = [char(9), char(9), '// outputs to MIG '];
text{end+1} = [char(9), char(9), '.app_addr(app_addr),'];  
text{end+1} = [char(9), char(9), '.app_cmd(app_cmd),'];  
text{end+1} = [char(9), char(9), '.app_en(app_en),'];  
text{end+1} = [char(9), char(9), '.app_wdf_data(app_wdf_data),'];  
text{end+1} = [char(9), char(9), '.app_wdf_end(app_wdf_end),'];  
text{end+1} = [char(9), char(9), '.app_wdf_mask(app_wdf_mask),'];  
text{end+1} = [char(9), char(9), '.app_wdf_wren(app_wdf_wren),']; 
text{end+1} = [char(9), char(9), '// inputs from IBC'];
text{end+1} = [char(9), char(9), '.ibc2mem_r_addr(ibc2mem_r_addr),'];
text{end+1} = [char(9), char(9), '.ibc2mem_r_vld(ibc2mem_r_vld),'];
text{end+1} = [char(9), char(9), '// outputs to IBC'];
text{end+1} = [char(9), char(9), '.mem2ibc_en(mem2ibc_en),'];
text{end+1} = [char(9), char(9), '.mem2ibc_data(mem2ibc_data),'];
text{end+1} = [char(9), char(9), '.mem2ibc_data_en(mem2ibc_data_en),'];
text{end+1} = [char(9), char(9), '// inputs from OBC'];
text{end+1} = [char(9), char(9), '.obc2mem_w_addr(obc2mem_w_addr),'];
text{end+1} = [char(9), char(9), '.obc2mem_w_vld(obc2mem_w_vld),'];
text{end+1} = [char(9), char(9), '.obc2mem_w_data(obc2mem_w_data),'];
text{end+1} = [char(9), char(9), '// output to OBC'];
text{end+1} = [char(9), char(9), '.mem2obc_en(mem2obc_en)'];
text{end+1} = [char(9), ');'];
text{end+1} = [''];


%% IBC
text{end+1} = [char(9), 'IBC # (.nPorts(nRows+nCols-1), .rAddrWidth(rAddrWidth), .rDataWidth(rDataWidth), .rReqWidth(rReqWidth))'];
text{end+1} = [char(9), 'ibc_inst ('];
text{end+1} = [char(9), char(9), '// inputs from PC'];
text{end+1} = [char(9), char(9), '.clk_bus(clk_bus),'];
text{end+1} = [char(9), char(9), '.rst_bus(rst_bus),'];
text{end+1} = [char(9), char(9), '.r_req(ibc_r_req),'];
text{end+1} = [char(9), char(9), '.r_req_en(ibc_r_req_en),'];
text{end+1} = [char(9), char(9), '// inputs from MIF'];
text{end+1} = [char(9), char(9), '.mem2ibc_en(mem2ibc_en),'];
text{end+1} = [char(9), char(9), '.mem2ibc_data(mem2ibc_data),'];
text{end+1} = [char(9), char(9), '.mem2ibc_data_en(mem2ibc_data_en),'];
text{end+1} = [char(9), char(9), '// outputs to MIF'];
text{end+1} = [char(9), char(9), '.ibc2mem_r_addr(ibc2mem_r_addr),'];
text{end+1} = [char(9), char(9), '.ibc2mem_r_vld(ibc2mem_r_vld),'];
text{end+1} = [char(9), char(9), '// outputs to PC'];
for i = 0:nRows+nCols-1-1, text{end+1} = [char(9), char(9), '.ibc2pc_data_en_', num2str(i), '(ibc2pc_data_en_', num2str(i),'),']; end
for i = 0:nRows+nCols-1-1, text{end+1} = [char(9), char(9), '.tk_out_', num2str(i), '(ibc_tk_', num2str(i),'),']; end
text{end+1} = [char(9), char(9), '.ibc2pc_data(ibc2pc_data)'];
text{end+1} = [char(9), ');'];
text{end+1} = [''];

%% OBC
text{end+1} = [char(9), 'OBC # (.nPorts(nBanks), .wAddrWidth(wAddrWidth), .wDataWidth(wDataWidth), .wReqWidth(wReqWidth), .wMaskWidth(wMaskWidth))'];
text{end+1} = [char(9), 'obc_inst ('];
text{end+1} = [char(9), char(9), '// inputs from PC'];
text{end+1} = [char(9), char(9), '.clk_bus(clk_bus),'];
text{end+1} = [char(9), char(9), '.rst_bus(rst_bus),'];
text{end+1} = [char(9), char(9), '.w_req(obc_w_req),'];
text{end+1} = [char(9), char(9), '.w_req_en(obc_w_req_en),'];
text{end+1} = [char(9), char(9), '// inputs from MIF'];
text{end+1} = [char(9), char(9), '.mem2obc_en(mem2obc_en),'];
text{end+1} = [char(9), char(9), '// outputs to MIF'];
text{end+1} = [char(9), char(9), '.obc2mem_w_addr(obc2mem_w_addr),'];
text{end+1} = [char(9), char(9), '.obc2mem_w_vld(obc2mem_w_vld),'];
for i = 0:nBanks-1, text{end+1} = [char(9), char(9), '.tk_out_', num2str(i), '(obc_tk_', num2str(i),'),']; end
text{end+1} = [char(9), char(9), '.obc2mem_w_data(obc2mem_w_data)'];
text{end+1} = [char(9), ');'];
text{end+1} = [''];

%% PCv1
for i = 0: nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'logic [rReqWidth-1:0] rd_req_', num2str(i), ';']; end
text{end+1} = [''];
for i = 0: 1:nRows+nCols-1-1, text{end+1} = [char(9), 'logic rd_req_en_', num2str(i), ';']; end
text{end+1} = [''];
for i = 0: nRows+nCols-1+nRows*nBanks-1
    text{end+1} = [char(9), 'PCv1 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .P_ID(', num2str(i),'))'];
    text{end+1} = [char(9), 'iPort_', num2str(i),' ('];
    text{end+1} = [char(9), char(9), '// inputs'];
    text{end+1} = [char(9), char(9), '.clk_bus(clk_bus),'];
    text{end+1} = [char(9), char(9), '.clk_array(clk_array),'];
    text{end+1} = [char(9), char(9), '.rst_bus(rst_bus),'];
    text{end+1} = [char(9), char(9), '.rst_array(rst_array),'];
    text{end+1} = [char(9), char(9), '.start(start),'];
    text{end+1} = [char(9), char(9), '.tk_en(ibc_tk_', num2str(i),'),'];
    text{end+1} = [char(9), char(9), '.rd_data_mem2pc(ibc2pc_data),'];
    text{end+1} = [char(9), char(9), '.rd_data_mem2pc_en(ibc2pc_data_en_', num2str(i),'),'];
    if i < nRows+nCols-1
        text{end+1} = [char(9), char(9), '.wrdy(data_obli_wrdy_', num2str(i+1),'),'];
    else
        tmp = i-(nRows+nCols-1);
        tmp_b = floor(tmp/nRows)+1;
        tmp_r = mod(tmp, nRows)+1;
        text{end+1} = [char(9), char(9), '.wrdy(data_horz_wrdy_', num2str(tmp_b),'_', num2str(tmp_r),'),'];
    end
    text{end+1} = [char(9), char(9), '.config_bits(iport_configbits_', num2str(i),'),'];
    text{end+1} = [char(9), char(9), '// outputs'];
    if i < nRows+nCols-1
        text{end+1} = [char(9), char(9), '.rd_data_pc2arr(data_obli_', num2str(i+1),'),'];
        text{end+1} = [char(9), char(9), '.rd_data_pc2arr_en(data_obli_in_en_', num2str(i+1),'),'];
    else
        tmp = i-(nRows+nCols-1);
        tmp_b = floor(tmp/nRows)+1;
        tmp_r = mod(tmp, nRows)+1;
        text{end+1} = [char(9), char(9), '.rd_data_pc2arr(data_horz_',  num2str(tmp_b),'_', num2str(tmp_r) ,'),'];
        text{end+1} = [char(9), char(9), '.rd_data_pc2arr_en(data_horz_in_en_',  num2str(tmp_b),'_', num2str(tmp_r),'),'];
    end
    text{end+1} = [char(9), char(9), '.rd_req_en(rd_req_en_', num2str(i),'),'];
    text{end+1} = [char(9), char(9), '.rd_req_out(rd_req_', num2str(i),')'];
    text{end+1} = [char(9), ');'];
    text{end+1} = [''];
end

%% PCv2
for i = 0: 1:nBanks-1, text{end+1} = [char(9), 'logic [wReqWidth-1:0] wr_req_', num2str(i), ';']; end
text{end+1} = [''];
for i = 0: 1:nBanks-1, text{end+1} = [char(9), 'logic wr_req_en_', num2str(i), ';']; end
text{end+1} = [''];
for i = 0: 1:nBanks-1
    text{end+1} = [char(9), 'PCv2 # (.WIDTH_ARR(iWidth), .WIDTH_BUS(rAddrWidth), .WIDTH_MASK(),'];
    text{end+1} = [char(9), char(9), char(9),'.nCols(nCols), .nRows(nRows), .MAX_nPERIOD(), .MAX_nCHN(), .P_ID(', num2str(i),'))'];
    text{end+1} = [char(9), 'oPort_', num2str(i),' ('];
    text{end+1} = [char(9), char(9), '// inputs'];
    text{end+1} = [char(9), char(9), '.clk_bus(clk_bus),'];
    text{end+1} = [char(9), char(9), '.clk_array(clk_array),'];
    text{end+1} = [char(9), char(9), '.rst_bus(rst_bus),'];
    text{end+1} = [char(9), char(9), '.rst_array(rst_array),'];
    text{end+1} = [char(9), char(9), '.start(start),'];
    text{end+1} = [char(9), char(9), '.tk_en(obc_tk_', num2str(i),'),'];
    text{end+1} = [char(9), char(9), '.data_arr2pc(dout_', num2str(i+1),'),'];
    text{end+1} = [char(9), char(9), '.data_arr2pc_en(dout_en_', num2str(i+1),'),'];
    text{end+1} = [char(9), char(9), '.config_bits(oport_configbits_', num2str(i),'),'];
    text{end+1} = [char(9), char(9), '// outputs'];
    text{end+1} = [char(9), char(9), '.wr_req_out(wr_req_', num2str(i),'),'];
    text{end+1} = [char(9), char(9), '.wr_req_en(wr_req_en_', num2str(i),')'];
    text{end+1} = [char(9), ');'];
    text{end+1} = [''];
end

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);
end