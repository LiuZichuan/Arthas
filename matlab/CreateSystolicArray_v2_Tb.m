%% Create a testbench file of a synthesizable Systolic Array (SA)
function CreateSystolicArray_v2_Tb(nBanks, nRows, nCols, iWidth, oWidth, CLK_PERIOD, PROCESSING_CYC, wPaths, fPaths, enPath, oPaths, name)
addpath('utils')
if ~exist('name'), name = 'D:/Arthas/arthas/src/sim/SystolicArray_v2_tb.sv'; end
if ~exist('wPaths'), wPaths = 'D:/tmp/arthas/weights'; end
if ~exist('fPaths'), fPaths = 'D:/tmp/arthas/features'; end
if ~exist('bnPaths'), bnPaths = 'D:/tmp/arthas/batchnorms'; end
if ~exist('enPath'), weightEnPath = 'D:/tmp/arthas/w_in_en.dat'; end
if ~exist('enPath'), featureEnPath = 'D:/tmp/arthas/f_in_en.dat'; end
if ~exist('enPath'), batchnormEnPath = 'D:/tmp/arthas/bn_in_en.dat'; end
if ~exist('oPaths'), oPaths = 'D:/tmp/arthas/output'; end

if ~exist('nBanks'), nBanks = 2; end
if ~exist('nRows'), nRows = 3; end
if ~exist('nCols'), nCols = 4; end
if ~exist('iWidth'), iWidth = 16; end
if ~exist('oWidth'), oWidth = 33; end
if ~exist('DFSM_MAX_nPERIOD'), DFSM_MAX_nPERIOD = 512; end
if ~exist('DFSM_MAX_nLMAC'), DFSM_MAX_nLMAC = 3*1024; end
if ~exist('DFSM_MAX_nSHFT'), DFSM_MAX_nSHFT = 3; end
if ~exist('SSP_MAX_nPeriod'),  SSP_MAX_nPeriod = 512*512; end
if ~exist('QUABUF_MAX_nDATA'), QUABUF_MAX_nDATA = 1024; end % maximum depth of data
if ~exist('QUABUF_MAX_nCOL'),  QUABUF_MAX_nCOL = 3; end % fix to 3 (do not revised)
if ~exist('QUABUF_MAX_nPERIOD'),  QUABUF_MAX_nPERIOD = 64 * 1024; end
if ~exist('QUABUF_MAX_nREP'),  QUABUF_MAX_nREP = 1024; end
if ~exist('SINGBUF_MAX_nPERIOD'),  SINGBUF_MAX_nPERIOD = 64 * 1024; end
if ~exist('SINGBUF_MAX_nDATA'), SINGBUF_MAX_nDATA = 1024; end 

% testing data size and filter size
mode_conv_mm = 0; % convolution
featureSize = [6, 6, 8]; % [input_rows, input_cols, input_depth]
weightSize = [2, 3, 3, 8]; % [output_depth, height, width input_depth]
zero_pad = 1;
assert(featureSize(3) == weightSize(4));
assert(featureSize(1) == nRows+nCols-1);

if ~exist('quabuf_nCol'), quabuf_nCol = 3; end
if ~exist('quabuf_nRep'), quabuf_nRep = weightSize(1)/nBanks; end
if ~exist('quabuf_nPeriod'), quabuf_nPeriod = featureSize(2)-2*zero_pad; end
if ~exist('quabuf_nData'), quabuf_nData = weightSize(4); end
if ~exist('QUABUF_CONFIGBIT_WIDTH'), QUABUF_CONFIGBIT_WIDTH = ceil(log2(QUABUF_MAX_nDATA)) + ceil(log2(QUABUF_MAX_nCOL)) + ceil(log2(QUABUF_MAX_nREP)) + ceil(log2(QUABUF_MAX_nPERIOD)); end
quabuf_config = quabuf_nData + ...
                quabuf_nPeriod * 2^ceil(log2(QUABUF_MAX_nDATA)) + ...
                quabuf_nRep * 2^(ceil(log2(QUABUF_MAX_nDATA)) + ceil(log2(QUABUF_MAX_nPERIOD))) + ...
                quabuf_nCol * 2^(ceil(log2(QUABUF_MAX_nDATA)) + ceil(log2(QUABUF_MAX_nPERIOD)) + ceil(log2(QUABUF_MAX_nREP)));


if ~exist('dfsm_nPeriod'),  dfsm_nPeriod = weightSize(1) * (featureSize(2)-2*zero_pad)/nBanks; end
assert(dfsm_nPeriod < 2^(ceil(log2(DFSM_MAX_nPERIOD))));
if ~exist('dfsm_nMAC'),  dfsm_nMAC = weightSize(3) * weightSize(4); end
assert(dfsm_nMAC < 2^(ceil(log2(DFSM_MAX_nLMAC))));
if ~exist('dfsm_nShift')  
    if (mode_conv_mm == 0)
        dfsm_nShift = weightSize(2); 
    else
        dfsm_nShift = 1; 
    end
end
assert(dfsm_nShift < 2^(ceil(log2(DFSM_MAX_nSHFT))));
dfsm_config = dfsm_nShift + dfsm_nMAC * 2^(ceil(log2(DFSM_MAX_nSHFT))) ... 
             + dfsm_nPeriod * 2^(ceil(log2(DFSM_MAX_nSHFT)) + ceil(log2(DFSM_MAX_nLMAC))) ... 
             + mode_conv_mm * 2^(ceil(log2(DFSM_MAX_nSHFT)) + ceil(log2(DFSM_MAX_nLMAC)) + ceil(log2(DFSM_MAX_nPERIOD)));
         
if ~exist('ssp_nData'), ssp_nData = featureSize(2)-2*zero_pad; end
if ~exist('ssp_nPeriod'), ssp_nPeriod = (featureSize(2)-2*zero_pad)/2; end
ssp_config = ssp_nData + ssp_nPeriod * 2^ceil(log2(nCols));

if ~exist('singbuf_nData'), singbuf_nData = weightSize(1)/nBanks; end
if ~exist('singbuf_nPeriod'), singbuf_nPeriod = (featureSize(2)-2*zero_pad); end
singbuf_config = singbuf_nData + singbuf_nPeriod * 2^ceil(log2(SINGBUF_MAX_nDATA));

if ~exist('isac'), isac = 1; end
if ~exist('isrelu'), isrelu = 1; end
if ~exist('isbn'), isbn = 1; end
CLK_PERIOD = 10;
PROCESSING_CYC = 2000;

text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['module SystolicArray_v2_tb();'];
text{end+1} = [char(9), 'parameter CLK_PERIOD = ', num2str(CLK_PERIOD),';'];
text{end+1} = [char(9), 'parameter PROCESSING_CYC = ', num2str(PROCESSING_CYC),';'];
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

% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'logic clk, clk_mem, rst, start,  mode_conv_mm, isac, isrelu, isbn, w_in_en, f_in_en, bn_in_en;'];
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
text{end+1} = [''];

text{end+1} = [char(9), '// outputs'];
for i = 1:nBanks, text{end+1} = [char(9), 'logic [', num2str(oWidth-1),':0] dout_', num2str(i), ';']; end
for i = 1:nBanks text{end+1} = [char(9), 'logic dout_en_', num2str(i), ';']; end
for i = 1:nCols+nRows-1, text{end+1} = [char(9), 'logic data_obli_wrdy_', num2str(i), ';']; end
for n = 1:nBanks, for i = 1:nRows, text{end+1} = [char(9), 'logic data_horz_wrdy_', num2str(n), '_', num2str(i), ';'];end, end
for i = 1:nBanks, text{end+1} = [char(9), 'logic data_bn_wrdy_', num2str(i), ';']; end
text{end+1} = [''];

% behavior
text{end+1} = [char(9), '// clk'];
text{end+1} = [char(9), 'always #(CLK_PERIOD/2) clk = ~clk;'];

text{end+1} = [''];
% initial
text{end+1} = [char(9), 'reg processing;'];
text{end+1} = [char(9), 'integer wInEnId;'];
text{end+1} = [char(9), 'integer fInEnId;'];
text{end+1} = [char(9), 'integer bnInEnId;'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'integer featureId_', num2str(j),';'];end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'integer weightId_', num2str(i),'_', num2str(j),';'];end, end
for j = 1:nBanks, text{end+1} = [char(9), 'integer batchnormId_', num2str(j),';'];end
for i = 1:nBanks, text{end+1} = [char(9), 'integer outputId_', num2str(i), ';']; end
text{end+1} = [char(9), 'integer nWread;'];
text{end+1} = [char(9), 'integer nFread;'];
text{end+1} = [char(9), 'integer nBNread;'];
text{end+1} = [''];
text{end+1} = [char(9), 'initial begin'];
text{end+1} = [char(9), char(9), 'clk = 0; rst = 0; clk_mem = 0; start = 0; processing = 0; nWread = 0; nFread = 0; nBNread = 0;'];
text{end+1} = [char(9), char(9), 'dfsm_config = ', num2str(dfsm_config),';'];
text{end+1} = [char(9), char(9), 'quabuf_config = ', num2str(QUABUF_CONFIGBIT_WIDTH), char(39), 'd', num2str(quabuf_config),';'];
text{end+1} = [char(9), char(9), 'ssp_config = ', num2str(ssp_config),';'];
text{end+1} = [char(9), char(9), 'singbuf_config = ', num2str(singbuf_config),';'];
text{end+1} = [char(9), char(9), 'mode_conv_mm = ', num2str(mode_conv_mm),';'];
text{end+1} = [char(9), char(9), 'isac = ', num2str(isac),';'];
text{end+1} = [char(9), char(9), 'isrelu = ', num2str(isrelu),';'];
text{end+1} = [char(9), char(9), 'isbn = ', num2str(isbn),';'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), 'pe_config_', num2str(i), '_', num2str(j), ' = 1;']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), 'data_obli_', num2str(j), ' = 0;']; end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), 'data_horz_', num2str(i), '_', num2str(j), ' = 0;']; end, end
for i = 1:nBanks, text{end+1} = [char(9), char(9), 'data_bn_', num2str(i), ' = 0;']; end

text{end+1} = [char(9), char(9), 'wInEnId = $fopen("', weightEnPath,'", "r");'];
text{end+1} = [char(9), char(9), 'fInEnId = $fopen("', featureEnPath,'", "r");'];
text{end+1} = [char(9), char(9), 'bnInEnId = $fopen("', batchnormEnPath,'", "r");'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), 'weightId_', num2str(i), '_', num2str(j),' = $fopen("', wPaths,'_', num2str(i),'_', num2str(j),'.dat", "r");'];end,end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), 'featureId_', num2str(j),' = $fopen("', fPaths, '_', num2str(j),'.dat", "r");']; end
for i = 1:nBanks, text{end+1} = [char(9), char(9), 'batchnormId_', num2str(i), ' = $fopen("', bnPaths,'_', num2str(i), '.dat", "r");']; end
for i = 1:nBanks, text{end+1} = [char(9), char(9), 'outputId_', num2str(i), ' = $fopen("', oPaths, '_', num2str(i), '.rst", "wt");']; end
text{end+1} = [char(9), char(9), '#(10*CLK_PERIOD)'];
text{end+1} = [char(9), char(9), 'rst = 1; start = 1;'];
text{end+1} = [char(9), char(9), '#(CLK_PERIOD)'];
text{end+1} = [char(9), char(9), 'start = 0;'];
text{end+1} = [char(9), char(9), 'processing = 1;'];
text{end+1} = [char(9), char(9), '# (PROCESSING_CYC*CLK_PERIOD)'];
text{end+1} = [char(9), char(9), 'processing = 0;'];
text{end+1} = [char(9), char(9), '$fclose(wInEnId);'];
text{end+1} = [char(9), char(9), '$fclose(fInEnId);'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), '$fclose(weightId_', num2str(i), '_', num2str(j), ');'];end,end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), '$fclose(featureId_', num2str(j),');']; end
for i = 1:nBanks, text{end+1} = [char(9), char(9), '$fclose(batchnormId_', num2str(i), ');']; end
for i = 1:nBanks, text{end+1} = [char(9), char(9), '$fclose(outputId_', num2str(i),');']; end
text{end+1} = [char(9), 'end'];
text{end+1} = [char(9), ''];

% weights, feature and in_en
feature_buffer_wrdy_cond = [];
weight_buffer_wrdy_cond = [];
batchnorm_buffer_wrdy_cond = [];
for n = 1:nBanks, for i = 1:nRows, weight_buffer_wrdy_cond = [weight_buffer_wrdy_cond, 'data_horz_wrdy_', num2str(n), '_', num2str(i), ' & ']; end, end
for i = 1:nCols+nRows-1, feature_buffer_wrdy_cond = [feature_buffer_wrdy_cond, 'data_obli_wrdy_', num2str(i), ' & ']; end
for n = 1:nBanks, batchnorm_buffer_wrdy_cond = [batchnorm_buffer_wrdy_cond, 'data_bn_wrdy_', num2str(n), ' & ']; end
text{end+1} = [''];
text{end+1} = [char(9), 'reg w_in_en_rd;'];
text{end+1} = [char(9), 'reg f_in_en_rd;'];
text{end+1} = [char(9), 'reg bn_in_en_rd;'];
for i = 1:nBanks, text{end+1} = [char(9), 'reg [', num2str(2*oWidth-1),':0] data_bn_rd_', num2str(i), ';']; end
text{end+1} = [''];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'reg [', num2str(iWidth-1),':0] data_obli_rd_', num2str(j),';'];end
text{end+1} = [''];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'reg [', num2str(iWidth),':0] data_horz_rd_', num2str(i),'_', num2str(j),';']; end, end
text{end+1} = [''];
text{end+1} = [char(9), 'integer status;'];
text{end+1} = [''];
text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if(~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'w_in_en <= 0;'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), 'data_horz_', num2str(i), '_', num2str(j), ' <= 0;']; end, end
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'if (', weight_buffer_wrdy_cond, 'processing && !$feof(wInEnId)) begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'status = $fscanf(wInEnId, "%b\n", w_in_en_rd);'];
text{end+1} = [char(9), char(9), char(9), char(9), 'w_in_en <= w_in_en_rd;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'nWread = nWread + 1;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'if (w_in_en_rd) begin'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'status = $fscanf(weightId_', num2str(i),'_', num2str(j),', "%b\n", data_horz_rd_', num2str(i),'_', num2str(j),');'];end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'data_horz_', num2str(i),'_', num2str(j),' <= data_horz_rd_', num2str(i), '_', num2str(j),';']; end, end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), char(9), 'else begin'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'data_horz_', num2str(i),'_', num2str(j),' <= 0;']; end, end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'w_in_en', ' <= 0;'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if(~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'f_in_en <= 0;'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), 'data_obli_', num2str(j), ' <= 0;']; end
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'if (', feature_buffer_wrdy_cond, 'processing && !$feof(fInEnId)) begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'status = $fscanf(fInEnId, "%b\n", f_in_en_rd);'];
text{end+1} = [char(9), char(9), char(9), char(9), 'f_in_en <= f_in_en_rd;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'nFread = nFread + 1;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'if (f_in_en_rd) begin'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'status = $fscanf(featureId_', num2str(j),', "%b\n", data_obli_rd_', num2str(j),');'];end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), char(9),char(9), 'data_obli_', num2str(j),' <= data_obli_rd_', num2str(j),';'];end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), char(9), 'else begin'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'data_obli_', num2str(j),' <= 0;'];end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'f_in_en', ' <= 0;'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if(~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'bn_in_en <= 0;'];
for j = 1:nBanks, text{end+1} = [char(9), char(9), char(9), 'data_bn_', num2str(j), ' <= 0;']; end
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'if (', batchnorm_buffer_wrdy_cond, 'processing && !$feof(bnInEnId)) begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'status = $fscanf(bnInEnId, "%b\n", bn_in_en_rd);'];
text{end+1} = [char(9), char(9), char(9), char(9), 'bn_in_en <= bn_in_en_rd;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'nBNread = nBNread + 1;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'if (bn_in_en_rd) begin'];
for j = 1:nBanks, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'status = $fscanf(batchnormId_', num2str(j),', "%b\n", data_bn_rd_', num2str(j),');'];end
for j = 1:nBanks, text{end+1} = [char(9), char(9), char(9), char(9),char(9), 'data_bn_', num2str(j),' <= data_bn_rd_', num2str(j),';'];end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), char(9), 'else begin'];
for j = 1:nBanks, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'data_bn_', num2str(j),' <= 0;'];end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'bn_in_en', ' <= 0;'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

for i = 1:nBanks
    text{end+1} = [char(9), 'always@(posedge clk) begin'];
    text{end+1} = [char(9), char(9), 'if (dout_en_', num2str(i), ') begin'];
    text{end+1} = [char(9), char(9), char(9), '$fwrite(outputId_', num2str(i), ',"%b\n", dout_', num2str(i), ');'];
    text{end+1} = [char(9), char(9), 'end'];
    text{end+1} = [char(9), 'end'];
    text{end+1} = [''];
end

% Create SysArray
pe_config = [];
data_horz = [];
data_horz_wrdy = [];
data_horz_in_en = [];
data_obli_wrdy = [];
data_obli = [];
data_obli_in_en = [];
dout = [];
dout_en = [];
data_bn = [];
data_bn_en = [];
data_bn_wrdy = [];
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

text{end+1} = [char(9), 'SystolicArray_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nBanks(nBanks), .nRows(nRows), ', ...
               '.nCols(nCols), .DFSM_MAX_nPERIOD(DFSM_MAX_nPERIOD), .DFSM_MAX_nLMAC(DFSM_MAX_nLMAC), .DFSM_MAX_nSHFT(DFSM_MAX_nSHFT), ', ...
               '.SSP_MAX_nPeriod(SSP_MAX_nPeriod), .QUABUF_MAX_nDATA(QUABUF_MAX_nDATA), .QUABUF_MAX_nCOL(QUABUF_MAX_nCOL), ', ...
               '.QUABUF_MAX_nPERIOD(QUABUF_MAX_nPERIOD), .QUABUF_MAX_nREP(QUABUF_MAX_nREP), .SINGBUF_MAX_nPeriod(SINGBUF_MAX_nPERIOD), .SINGBUF_MAX_nDATA(SINGBUF_MAX_nDATA)) U ('...
               '.clk(clk), .clk_mem(clk), .rst(rst), .start(start), .mode_conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), ', ...
               pe_config, data_horz, data_horz_in_en, data_obli, data_obli_in_en, data_horz_wrdy, data_obli_wrdy, dout, dout_en, data_bn, data_bn_en, data_bn_wrdy, ...
               '.dfsm_config(dfsm_config), .ssp_config(ssp_config), .quabuf_config(quabuf_config), .singbuf_config(singbuf_config)', ...
               ');'];
text{end+1} = [''];

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);