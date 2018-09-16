%% Create a system verilog file of a synthesizable Systolic Array v2 (SA)
function CreateSystolicArray_v2(nBanks, nRows, nCols, iWidth, oWidth, DFSM_MAX_nPERIOD, DFSM_MAX_nLMAC, DFSM_MAX_nSHFT, SSP_MAX_nPeriod, ...
                                QUABUF_MAX_nDATA, QUABUF_MAX_nCOL, QUABUF_MAX_nPERIOD, QUABUF_MAX_nREP, SINGBUF_MAX_nPERIOD, SINGBUF_MAX_nDATA, ...
                                name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/SystolicArray_v2.sv'; end
if ~exist('nBanks'), nBanks = 2; end
if ~exist('nRows'), nRows = 3; end
if ~exist('nCols'), nCols = 4; end
if ~exist('iWidth'), iWidth = 16; end
if ~exist('oWidth'), oWidth = 33; end
if ~exist('DFSM_MAX_nPERIOD'), DFSM_MAX_nPERIOD = 8; end
if ~exist('DFSM_MAX_nLMAC'), DFSM_MAX_nLMAC = 3*512*8; end
if ~exist('DFSM_MAX_nSHFT'), DFSM_MAX_nSHFT = 192; end
if ~exist('SSP_MAX_nPeriod'),  SSP_MAX_nPeriod = 512*512; end
if ~exist('QUABUF_MAX_nDATA'), QUABUF_MAX_nDATA = 1024; end % maximum depth of data
if ~exist('QUABUF_MAX_nCOL'),  QUABUF_MAX_nCOL = 3; end % fix to 3 (do not revised)
if ~exist('QUABUF_MAX_nPERIOD'),  QUABUF_MAX_nPERIOD = 64 * 1024; end
if ~exist('QUABUF_MAX_nREP'),  QUABUF_MAX_nREP = 1024; end
if ~exist('SINGBUF_MAX_nPERIOD'),  SINGBUF_MAX_nPERIOD = 64 * 1024; end
if ~exist('SINGBUF_MAX_nDATA'), SINGBUF_MAX_nDATA = 1024; end 


text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: SystolicArray_v2'];
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
text{end+1} = ['module SystolicArray_v2('];
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'clk,'];
text{end+1} = [char(9), 'clk_mem,'];
text{end+1} = [char(9), 'rst,'];
text{end+1} = [char(9), 'start,'];
for k = 1: nRows+nCols-1, text{end+1} = [char(9), 'data_obli_in_en_', num2str(k),',']; end
text{end+1} = [char(9), 'mode_conv_mm,'];
text{end+1} = [char(9), 'isac,'];
text{end+1} = [char(9), 'isrelu,'];
text{end+1} = [char(9), 'isbn,'];
text{end+1} = [char(9), 'dfsm_config,'];
text{end+1} = [char(9), 'ssp_config,'];
text{end+1} = [char(9), 'quabuf_config,'];
text{end+1} = [char(9), 'singbuf_config,'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'pe_config_', num2str(i), '_', num2str(j), ',']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'data_horz_', num2str(i), '_', num2str(j), ',']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'data_horz_in_en_', num2str(i), '_', num2str(j), ',']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'data_obli_', num2str(j), ',']; end
for i = 1:nBanks, text{end+1} = [char(9), 'data_bn_', num2str(i), ',']; end
for i = 1:nBanks, text{end+1} = [char(9), 'data_bn_wrdy_', num2str(i), ',']; end
for i = 1:nBanks, text{end+1} = [char(9), 'data_bn_we_', num2str(i), ',']; end
text{end+1} = [char(9), '// outputs'];
for i = 1:nBanks, text{end+1} = [char(9), 'dout_', num2str(i), ',']; end
for i = 1:nBanks text{end+1} = [char(9), 'dout_en_', num2str(i), ',']; end
for i = 1:nCols+nRows-1, text{end+1} = [char(9), 'data_obli_wrdy_', num2str(i), ',']; end
for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'data_horz_wrdy_', num2str(n), '_', num2str(i), ','];end, end
text{end+1} = [');'];
text{end+1} = [char(9), 'parameter nBanks = ', num2str(nBanks),';'];
text{end+1} = [char(9), 'parameter nCols = ', num2str(nCols),';'];
text{end+1} = [char(9), 'parameter nRows = ', num2str(nRows),';'];
text{end+1} = [char(9), 'parameter iWidth = ', num2str(iWidth),';'];
text{end+1} = [char(9), 'parameter oWidth = ', num2str(oWidth),';'];
text{end+1} = [char(9), 'parameter DFSM_MAX_nPERIOD = ', num2str(DFSM_MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter DFSM_MAX_nLMAC = ', num2str(DFSM_MAX_nLMAC),';'];
text{end+1} = [char(9), 'parameter DFSM_MAX_nSHFT = ', num2str(DFSM_MAX_nSHFT),';'];
text{end+1} = [char(9), 'parameter SSP_MAX_nPeriod = ', num2str(SSP_MAX_nPeriod),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nDATA = ', num2str(QUABUF_MAX_nDATA),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nCOL = ', num2str(QUABUF_MAX_nCOL),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nPERIOD = ', num2str(QUABUF_MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter QUABUF_MAX_nREP = ', num2str(QUABUF_MAX_nREP),';'];
text{end+1} = [char(9), 'parameter SINGBUF_MAX_nPERIOD = ', num2str(SINGBUF_MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter SINGBUF_MAX_nDATA = ', num2str(SINGBUF_MAX_nDATA),';'];
text{end+1} = [''];

text{end+1} = [char(9), 'localparam SSP_MAX_nData = nCols;'];
text{end+1} = [char(9), 'localparam DFSM_CONFIGBIT_WIDTH = $clog2(DFSM_MAX_nPERIOD) + $clog2(DFSM_MAX_nLMAC) + $clog2(DFSM_MAX_nSHFT);'];
text{end+1} = [char(9), 'localparam SSP_CONFIGBIT_WIDTH = $clog2(SSP_MAX_nData) + $clog2(SSP_MAX_nPeriod);'];
text{end+1} = [char(9), 'localparam QUABUF_CONFIGBIT_WIDTH = $clog2(QUABUF_MAX_nDATA) + $clog2(QUABUF_MAX_nCOL) + $clog2(QUABUF_MAX_nREP) + $clog2(QUABUF_MAX_nPERIOD);'];
text{end+1} = [char(9), 'localparam SINGBUF_CONFIGBIT_WIDTH = $clog2(SINGBUF_MAX_nDATA) + $clog2(SINGBUF_MAX_nPERIOD);'];
text{end+1} = [char(9), 'localparam MODE_CONV = 0; localparam MODE_MM = 1;'];
text{end+1} = [''];

% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'input clk, clk_mem, rst, start,  mode_conv_mm, isac, isrelu, isbn;'];
text{end+1} = [char(9), 'input [DFSM_CONFIGBIT_WIDTH-1:0] dfsm_config;'];
text{end+1} = [char(9), 'input [SSP_CONFIGBIT_WIDTH-1:0] ssp_config;'];
text{end+1} = [char(9), 'input [QUABUF_CONFIGBIT_WIDTH-1:0] quabuf_config;'];
text{end+1} = [char(9), 'input [SINGBUF_CONFIGBIT_WIDTH-1:0] singbuf_config;'];
for k = 1: nRows+nCols-1, text{end+1} = [char(9), 'input data_obli_in_en_', num2str(k),';']; end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'input pe_config_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'input [', num2str(iWidth-1),':0] data_horz_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'input data_horz_in_en_', num2str(i), '_', num2str(j), ';']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'input [', num2str(iWidth-1),':0] data_obli_', num2str(j), ';']; end
for i = 1:nBanks, text{end+1} = [char(9), 'input [', num2str(2*oWidth-1),':0] data_bn_', num2str(i), ';']; end
for i = 1:nBanks, text{end+1} = [char(9), 'input data_bn_we_', num2str(i), ';']; end
text{end+1} = [''];

text{end+1} = [char(9), '// outputs'];
for i = 1:nBanks, text{end+1} = [char(9), 'output [', num2str(oWidth-1),':0] dout_', num2str(i), ';']; end
for i = 1:nBanks text{end+1} = [char(9), 'output dout_en_', num2str(i), ';']; end
for i = 1:nCols+nRows-1, text{end+1} = [char(9), 'output data_obli_wrdy_', num2str(i), ';']; end
for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'output data_horz_wrdy_', num2str(n), '_', num2str(i), ';'];end, end
for i = 1:nBanks, text{end+1} = [char(9), 'output data_bn_wrdy_', num2str(i), ';']; end
text{end+1} = [''];

for i = 1:nCols text{end+1} = [char(9), 'logic A_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic B_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic C_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic D_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic E_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic F_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic G_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic H_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nCols+nRows-1, text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] data_obli_buf_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] data_horz_buf_', num2str(i), '_', num2str(j),';']; end, end
text{end+1} = [''];
for i = 1:nCols+nRows-1, text{end+1} = [char(9), 'logic data_obli_rrdy_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nCols, text{end+1} = [char(9), 'logic dfsm_data_en_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nCols, text{end+1} = [char(9), 'logic start_bypass_', num2str(i), ';']; end
text{end+1} = [''];
for k = 1: nRows+nCols-1, text{end+1} = [char(9), 'logic quabuf_re_mux_', num2str(k), ';']; end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'logic data_horz_rrdy_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'logic horz_fifo_empty_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nCols, text{end+1} = [char(9), 'logic [', num2str(oWidth-1),':0]dout_vert_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, text{end+1} = [char(9), 'logic [', num2str(nCols*oWidth-1),':0] dout_vert_buf_', num2str(n), ';']; end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nCols, text{end+1} = [char(9), 'logic vert_fifo_full_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nCols, text{end+1} = [char(9), 'logic vert_fifo_full_almost_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nCols, text{end+1} = [char(9), 'logic vert_fifo_re_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nCols, text{end+1} = [char(9), 'logic vert_fifo_we_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nCols, text{end+1} = [char(9), 'logic vert_fifo_empty_', num2str(n),'_', num2str(i), ';']; end, end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'logic horz_fifo_full_', num2str(n), '_', num2str(i), ';'];end, end
text{end+1} = [''];

text{end+1} = [char(9), 'logic quabuf_re;'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic horz_fifo_re;'];
text{end+1} = [''];

data_bn_rdy_cond = [];
for i = 1:nBanks, data_bn_rdy_cond = [data_bn_rdy_cond, 'data_bn_rrdy_', num2str(i), ' & ']; end
text{end+1} = [char(9), 'logic data_bn_re;']; 
text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if (~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'data_bn_re <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'data_bn_re <= G_1 & ', data_bn_rdy_cond,'1;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic data_bn_en;']; 
text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if (~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'data_bn_en <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'data_bn_en <= data_bn_re;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

for i = 1:nBanks, text{end+1} = [char(9), 'logic data_bn_rrdy_', num2str(i), ';']; end
text{end+1} = [''];

for i = 1:nBanks, text{end+1} = [char(9), 'logic [', num2str(2*oWidth-1),':0] data_bn_buf_', num2str(i), ';']; end
text{end+1} = [''];


text{end+1} = [char(9), 'reg [', num2str(nCols-2),':0] quabuf_re_dly;'];
text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if (~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'quabuf_re_dly <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'quabuf_re_dly <= {quabuf_re_dly[', num2str(nCols-3),':0], quabuf_re};'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

for i = 1:nBanks
    text{end+1} = [char(9), 'logic vert_shifter_load_', num2str(i), ';'];
    text{end+1} = [''];
    
    vert_shifter_load_cond = [];
    for k = 1:nCols, vert_shifter_load_cond = [vert_shifter_load_cond, '~vert_fifo_empty_', num2str(i), '_', num2str(k), ' & ']; end
    text{end+1} = [char(9), 'assign vert_shifter_load_', num2str(i), ' = ', vert_shifter_load_cond,'~shifting_', num2str(i),';'];
    text{end+1} = [''];
    
    for k = 1:nCols, text{end+1} = [char(9), 'assign vert_fifo_re_', num2str(i), '_', num2str(k), ' = vert_shifter_load_', num2str(i), ';']; end
    text{end+1} = [''];
    
    text{end+1} = [char(9), 'reg [', num2str(oWidth*nCols-1),':0] dout_vert_shifter_', num2str(i),';'];
    text{end+1} = [char(9), 'always@(posedge clk) begin'];
    text{end+1} = [char(9), char(9), 'if (~rst) begin'];
    text{end+1} = [char(9), char(9), char(9), 'dout_vert_shifter_', num2str(i),' <= 0;'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), char(9), 'else if (vert_shifter_load_', num2str(i),') begin'];
    text{end+1} = [char(9), char(9), char(9), 'dout_vert_shifter_', num2str(i),' <= dout_vert_buf_', num2str(i),';'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), char(9), 'else if (shifting_', num2str(i),') begin'];
    text{end+1} = [char(9), char(9), char(9), 'dout_vert_shifter_', num2str(i),' <= {', num2str(oWidth), char(39),'d0, dout_vert_shifter_', num2str(i),'[', num2str(nCols*oWidth-1),':', num2str(oWidth),']};'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), 'end'];
    text{end+1} = [''];
    
    text{end+1} = [char(9), 'logic shifting_', num2str(i),';'];
    text{end+1} = [char(9), 'always@(posedge clk) begin'];
    text{end+1} = [char(9), char(9), 'if (~rst) begin'];
    text{end+1} = [char(9), char(9), char(9), 'shifting_', num2str(i),' <= 0;'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), char(9), 'else if (vert_shifter_load_', num2str(i),') begin'];
    text{end+1} = [char(9), char(9), char(9), 'shifting_', num2str(i),' <= 1;'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), char(9), 'else if (shift_count_', num2str(i),' == ', num2str(nCols-1),') begin'];
    text{end+1} = [char(9), char(9), char(9), 'shifting_', num2str(i),' <= 0;'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), 'end'];
    text{end+1} = [''];
    
    text{end+1} = [char(9), 'logic [$clog2(nCols)-1:0] shift_count_', num2str(i),';'];
    text{end+1} = [char(9), 'always@(posedge clk) begin'];
    text{end+1} = [char(9), char(9), 'if (~rst) begin'];
    text{end+1} = [char(9), char(9), char(9), 'shift_count_', num2str(i),' <= 0;'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), char(9), 'else if (vert_shifter_load_', num2str(i),' || shifting_', num2str(i),') begin'];
    text{end+1} = [char(9), char(9), char(9), 'shift_count_', num2str(i),' <= (shift_count_', num2str(i),' < ', num2str(nCols-1),')? (shift_count_', num2str(i),' + 1): 0;'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), 'end'];
    text{end+1} = [''];
    
    text{end+1} = [char(9), 'assign ssp_data_in_en_', num2str(i),' = shifting_', num2str(i),' | vert_shifter_load_', num2str(i),';'];
    text{end+1} = [''];
end

for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'assign data_horz_wrdy_', num2str(n), '_', num2str(i), ' = ~horz_fifo_full_almost_', num2str(n), '_', num2str(i),';']; end, end
text{end+1} = [''];

for k = 1: nRows+nCols-1 
    if (k <= nRows-1)
        text{end+1} = [char(9), 'assign quabuf_re_mux_', num2str(k), ' = (mode_conv_mm == MODE_CONV)? quabuf_re: 0;']; 
    elseif (k == nRows)
        text{end+1} = [char(9), 'assign quabuf_re_mux_', num2str(k), ' = quabuf_re;']; 
    else
        text{end+1} = [char(9), 'assign quabuf_re_mux_', num2str(k), ' = (mode_conv_mm == MODE_CONV)? quabuf_re_dly[', num2str(k-nRows-1),']: 0;']; 
    end
end
text{end+1} = [''];

for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'assign data_horz_rrdy_', num2str(n),'_', num2str(i), ' = ~horz_fifo_empty_', num2str(n), '_', num2str(i),';']; end, end
text{end+1} = [''];

text{end+1} = [char(9), 'logic all_data_rdy;'];
text{end+1} = [char(9), 'logic data_preread;'];
all_rdy_cond = [];
for n = 1:nBanks, for i = 1:nRows, all_rdy_cond = [all_rdy_cond, 'data_horz_rrdy_', num2str(n),'_', num2str(i), ' & ']; end, end
for i = 1:nRows+nCols-1, all_rdy_cond = [all_rdy_cond, 'data_obli_rrdy_', num2str(i), ' & ']; end
all_rdy_cond = [all_rdy_cond, '1'];
text{end+1} = [char(9), 'assign all_data_rdy = ', all_rdy_cond, ';'];
text{end+1} = [char(9), 'assign quabuf_re = data_preread;'];
text{end+1} = [char(9), 'assign horz_fifo_re = data_preread;'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic array_data_en;'];
text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if (~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'array_data_en <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'array_data_en <= data_preread;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];


% Create SysBank
for i = 1:nBanks
    pe_config = [];
    data_horz = [];
    data_obli = [];
    A = []; B = []; C = []; D = []; E = []; F = []; G = []; H = [];
    dout = [];
    dout_en = [];
    for j = 1:nRows
        data_horz = [data_horz, '.data_in_horz_', num2str(j),'(data_horz_buf_', num2str(i), '_', num2str(j), '), '];
        pe_config = [pe_config, '.active_', num2str(j),'(pe_config_', num2str(i), '_', num2str(j), '), '];
    end
    for j = 1:(nRows+nCols-1)
        data_obli = [data_obli, '.data_in_obli_', num2str(j),'(data_obli_buf_', num2str(j), '), '];
    end
    for j = 1:nCols
        A = [A, '.A_', num2str(j), '(A_', num2str(j),'), '];
        B = [B, '.B_', num2str(j), '(B_', num2str(j),'), '];
        C = [C, '.C_', num2str(j), '(C_', num2str(j),'), '];
        D = [D, '.D_', num2str(j), '(D_', num2str(j),'), '];
        E = [E, '.E_', num2str(j), '(E_', num2str(j),'), '];
        F = [F, '.F_', num2str(j), '(F_', num2str(j),'), '];
        G = [G, '.G_', num2str(j), '(G_', num2str(j),'), '];
        H = [H, '.H_', num2str(j), '(H_', num2str(j),'), '];
        dout_en = [dout_en, '.dout_en_', num2str(j), '(vert_fifo_we_', num2str(i), '_', num2str(j),'), '];
        dout = [dout, '.dout_', num2str(j), '(dout_vert_', num2str(i), '_', num2str(j),'), '];
    end
    dout = dout(1:end-2);
    text{end+1} = [char(9), 'SystolicBank_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nRows(nRows), .nCols(nCols)) bank_', num2str(i), '('...
                   '.clk(clk), .rst(rst), .in_en(array_data_en), .conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), .bn_param_in_en(data_bn_en), ', ...
                   '.bn_param_in(data_bn_buf_', num2str(i),'),', ... 
                   pe_config, data_horz, data_obli, A, B, C, D, E, F, G, H, dout_en, dout ...
                   ,');'];
end
text{end+1} = [''];
% Create DFSM
for i = 1:nCols
    if i == 1
        text{end+1} = [char(9), 'DFSMv3 # (.MAX_nPERIOD(DFSM_MAX_nPERIOD), .MAX_nLMAC(DFSM_MAX_nLMAC), .MAX_nSHFT(DFSM_MAX_nSHFT)) fsm_', num2str(i), '('...
                       '.clk(clk), .rst(rst), .config_bits({mode_conv_mm, dfsm_config}), ', ...
                       '.all_data_rdy(all_data_rdy), .in_en(array_data_en), .start(start), .data_preread(data_preread), ', ...
                       '.in_en_bypass(dfsm_data_en_', num2str(i),'), ', ...
                       '.start_out(start_bypass_', num2str(i),'), ', ...
                       '.A(A_', num2str(i),'), ', ...
                       '.B(B_', num2str(i),'), ', ...
                       '.C(C_', num2str(i),'), ', ...
                       '.D(D_', num2str(i),'), ', ...
                       '.E(E_', num2str(i),'), ', ...
                       '.F(F_', num2str(i),'), ', ...
                       '.G(G_', num2str(i),'), ', ...
                       '.H(H_', num2str(i),')', ...
                       ');'];
    else
        text{end+1} = [char(9), 'DFSMv2 # (.MAX_nPERIOD(DFSM_MAX_nPERIOD), .MAX_nLMAC(DFSM_MAX_nLMAC), .MAX_nSHFT(DFSM_MAX_nSHFT)) fsm_', num2str(i), '('...
                       '.clk(clk), .rst(rst), .config_bits({mode_conv_mm, dfsm_config}), ', ...
                       '.in_en(dfsm_data_en_', num2str(i-1),'), ', ...
                       '.start(start_bypass_', num2str(i-1),'), ', ...
                       '.in_en_bypass(dfsm_data_en_', num2str(i),'), ', ...
                       '.start_out(start_bypass_', num2str(i),'), ', ...
                       '.A(A_', num2str(i),'), ', ...
                       '.B(B_', num2str(i),'), ', ...
                       '.C(C_', num2str(i),'), ', ...
                       '.D(D_', num2str(i),'), ', ...
                       '.E(E_', num2str(i),'), ', ...
                       '.F(F_', num2str(i),'), ', ...
                       '.G(G_', num2str(i),'), ', ...
                       '.H(H_', num2str(i),')', ...
                       ');'];
    end
end
text{end+1} = [''];

for k = 1: (nCols+nRows-1)
    text{end+1} = [char(9), 'QUADRABUFv1 # (.DATA_WIDTH(iWidth), .MAX_nDATA(QUABUF_MAX_nDATA), .MAX_nREP(QUABUF_MAX_nREP), .MAX_nPERIOD(QUABUF_MAX_nPERIOD)) quabuf_', num2str(k),'(', ...
                   '.clk(clk), .rst(rst), .config_bits(quabuf_config), .start(start), ', ...
                   '.data_in(data_obli_', num2str(k),'), ', ...
                   '.we(data_obli_in_en_',  num2str(k),'), ', ...
                   '.re(quabuf_re_mux_', num2str(k),'), ', ...
                   '.wrdy(data_obli_wrdy_', num2str(k),'), ', ...
                   '.rrdy(data_obli_rrdy_', num2str(k),'), ', ...
                   '.data_out(data_obli_buf_', num2str(k),')', ...
                   ');'];
end
text{end+1} = [''];

for i = 1:nBanks
    for j = 1:nRows
        text{end+1} = [char(9), 'FIFO # (.DSIZE(iWidth), .ASIZE(5)) data_horz_fifo_', num2str(i), '_', num2str(j),'(', ...
                       '.wclk(clk_mem), .rclk(clk), .wrst_n(rst), .rrst_n(rst), ', ...
                       '.winc(data_horz_in_en_', num2str(i), '_', num2str(j),'), ', ...
                       '.rinc(horz_fifo_re), ', ...
                       '.wfull(horz_fifo_full_', num2str(i), '_', num2str(j),'), ', ...
                       '.rempty(horz_fifo_empty_', num2str(i), '_', num2str(j),'), ', ...
                       '.wfull_almost(horz_fifo_full_almost_', num2str(i), '_', num2str(j),'), ', ...
                       '.rdata(data_horz_buf_', num2str(i), '_', num2str(j),'), ', ...
                       '.wdata(data_horz_', num2str(i), '_', num2str(j),')', ...
                       ');'];
    end
end
text{end+1} = [''];

for i = 1:nBanks
    for j = 1:nCols
        text{end+1} = [char(9), 'FIFO # (.DSIZE(oWidth), .ASIZE(5)) data_vert_fifo_', num2str(i), '_', num2str(j),'(', ...
                       '.wclk(clk), .rclk(clk), .wrst_n(rst), .rrst_n(rst), ', ...
                       '.winc(vert_fifo_we_', num2str(i), '_', num2str(j),'), ', ...
                       '.rinc(vert_fifo_re_', num2str(i), '_', num2str(j),'), ', ...
                       '.wfull(vert_fifo_full_', num2str(i), '_', num2str(j),'), ', ...
                       '.rempty(vert_fifo_empty_', num2str(i), '_', num2str(j),'), ', ...
                       '.wfull_almost(vert_fifo_full_almost_', num2str(i), '_', num2str(j),'), ', ...
                       '.rdata(dout_vert_buf_', num2str(i), '[', num2str((nCols-(j-1))*oWidth-1),':', num2str((nCols-(j-1))*oWidth-oWidth),']), ', ...
                       '.wdata(dout_vert_', num2str(i), '_', num2str(j),')', ...
                       ');'];
    end
end
text{end+1} = [''];

for i = 1:nBanks
    text{end+1} = [char(9), 'SSP # (.WIDTH(oWidth), .MAX_nData(SSP_MAX_nData), .MAX_nPeriod(SSP_MAX_nPeriod)) ssp_', num2str(i), '(', ...
                   '.clk(clk), .rst(rst), .config_bits(ssp_config), .start(start), ', ...
                   '.data_in_en(ssp_data_in_en_', num2str(i),'), ', ...
                   '.data_in(dout_vert_shifter_', num2str(i),'[', num2str(oWidth-1),':0]), ', ...
                   '.data_out(dout_', num2str(i),'), ', ...
                   '.data_out_en(dout_en_', num2str(i),')', ...
                   ');'];
end
text{end+1} = [''];

for i = 1:nBanks
    text{end+1} = [char(9), 'SINGBUFv1 # (.DATA_WIDTH(2*oWidth), .MAX_nDATA(SINGBUF_MAX_nDATA), .MAX_nPERIOD(SINGBUF_MAX_nPERIOD)) singbuf_', num2str(i), '(', ...
                   '.clk(clk), .rst(rst), .config_bits(singbuf_config), .start(start), ', ...
                   '.we(data_bn_we_', num2str(i),'), ', ...
                   '.re(data_bn_re), ', ...
                   '.data_in(data_bn_', num2str(i),'), ', ...
                   '.wrdy(data_bn_wrdy_', num2str(i),'), ', ...
                   '.rrdy(data_bn_rrdy_', num2str(i),'), ', ...
                   '.data_out(data_bn_buf_', num2str(i),')', ...
                   ');'];
end
text{end+1} = [''];

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);