%% Create a system config registerr file (SCRF) with pre-defined configurations
function CreateSysConfigRegFile(sess, nRows, nCols, nBanks, iWidth, oWidth, rAddrWidth, rDataWidth, rReqWidth, wAddrWidth, wDataWidth, wReqWidth, ...
                                QUABUF_MAX_nDATA, QUABUF_MAX_nCOL, QUABUF_MAX_nREP, QUABUF_MAX_nPERIOD, ...
                                DFSM_MAX_nPERIOD, DFSM_MAX_nLMAC, DFSM_MAX_nSHFT, ...
                                SSP_MAX_nData, SSP_MAX_nPeriod, SINGBUF_MAX_nDATA, SINGBUF_MAX_nPERIOD, name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/SCRF.sv'; end

% session configurations
mode_conv_mm = sess.mode_conv_mm; % convolution
featureSize = sess.featureSize; % [input_rows, input_cols, input_depth]
weightSize = sess.weightSize; % [output_depth, height, width input_depth]
zero_pad = sess.zero_pad;
horz_data_addr_base = sess.horz_data_addr_base;
obli_data_addr_base = sess.obli_data_addr_base;
out_data_addr_base = sess.out_data_addr_base;
horz_data_addr_block_stride = sess.horz_data_addr_block_stride;
horz_data_addr_block_num = sess.horz_data_addr_block_num;
obli_data_addr_block_stride = sess.obli_data_addr_block_stride;
obli_data_addr_block_num = sess.obli_data_addr_block_num;
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
assert(quabuf_config <= 2^QUABUF_CONFIGBIT_WIDTH-1)

if ~exist('DFSM_CONFIGBIT_WIDTH'), DFSM_CONFIGBIT_WIDTH = ceil(log2(DFSM_MAX_nPERIOD)) + ceil(log2(DFSM_MAX_nLMAC)) + ceil(log2(DFSM_MAX_nSHFT)); end
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
assert(dfsm_config <= 2^DFSM_CONFIGBIT_WIDTH-1)

if ~exist('SSP_CONFIGBIT_WIDTH'), SSP_CONFIGBIT_WIDTH = ceil(log2(SSP_MAX_nData)) + ceil(log2(SSP_MAX_nPeriod)); end
if ~exist('ssp_nData'), ssp_nData = featureSize(2)-2*zero_pad; end
if ~exist('ssp_nPeriod'), ssp_nPeriod = (featureSize(2)-2*zero_pad)/2; end
ssp_config = ssp_nData + ssp_nPeriod * 2^ceil(log2(nCols));
assert(ssp_config <= 2^SSP_CONFIGBIT_WIDTH-1);

if ~exist('SINGBUF_CONFIGBIT_WIDTH'), SINGBUF_CONFIGBIT_WIDTH = ceil(log2(SINGBUF_MAX_nDATA)) + ceil(log2(SINGBUF_MAX_nPERIOD)); end
if ~exist('singbuf_nData'), singbuf_nData = weightSize(1)/nBanks; end
if ~exist('singbuf_nPeriod'), singbuf_nPeriod = (featureSize(2)-2*zero_pad); end
singbuf_config = singbuf_nData + singbuf_nPeriod * 2^ceil(log2(SINGBUF_MAX_nDATA));
assert(singbuf_config <= 2^SINGBUF_CONFIGBIT_WIDTH-1);

if ~exist('isac'), isac = 1; end
if ~exist('isrelu'), isrelu = 1; end
if ~exist('isbn'), isbn = 1; end

% iport configurations
obli_data_addr_block_base = obli_data_addr_base + obli_data_addr_block_stride * [0:obli_data_addr_block_num-1];
obli_data_iport_configbits = obli_data_addr_block_base * 2^rAddrWidth + obli_data_addr_block_stride;
horz_data_addr_block_base = horz_data_addr_base + horz_data_addr_block_stride * [0:horz_data_addr_block_num-1];
horz_data_iport_configbits = horz_data_addr_block_base * 2^rAddrWidth + horz_data_addr_block_stride;
if ~exist('iport_configbits'), iport_configbits = [obli_data_iport_configbits, horz_data_iport_configbits]; end
if ~exist('oport_configbits'), oport_configbits = 1; end

text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: System Config Registerr File (SCRF)'];
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
text{end+1} = ['module SCRF('];
text{end+1} = [char(9), 'dfsm_config,'];
text{end+1} = [char(9), 'ssp_config,'];
text{end+1} = [char(9), 'quabuf_config,'];
text{end+1} = [char(9), 'singbuf_config,'];
text{end+1} = [char(9), 'mode_conv_mm,'];
text{end+1} = [char(9), 'isac,'];
text{end+1} = [char(9), 'isrelu,'];
text{end+1} = [char(9), 'isbn,'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'pe_config_', num2str(i), '_', num2str(j), ',']; end, end
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'iport_configbts_', num2str(i), ',']; end
for i = 0:nBanks-1, text{end+1} = [char(9), 'oport_configbits_', num2str(i), ',']; end
text{end+1} = [');'];
text{end+1} = [''];

text{end+1} = [char(9), 'output [', num2str(DFSM_CONFIGBIT_WIDTH-1), ':0] dfsm_config;'];
text{end+1} = [char(9), 'output [', num2str(SSP_CONFIGBIT_WIDTH-1), ':0] ssp_config;'];
text{end+1} = [char(9), 'output [', num2str(QUABUF_CONFIGBIT_WIDTH-1), ':0] quabuf_config;'];
text{end+1} = [char(9), 'output [', num2str(SINGBUF_CONFIGBIT_WIDTH-1), ':0] singbuf_config;'];
text{end+1} = [char(9), 'output mode_conv_mm;'];
text{end+1} = [char(9), 'output isac;'];
text{end+1} = [char(9), 'output isrelu;'];
text{end+1} = [char(9), 'output isbn;'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'output pe_config_', num2str(i), '_', num2str(j), ';']; end, end
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'output [', num2str(2*rAddrWidth-1),':0] iport_configbts_', num2str(i), ';']; end
for i = 0:nBanks-1, text{end+1} = [char(9), 'output [', num2str(2*wAddrWidth-1),':0] oport_configbits_', num2str(i), ';']; end
text{end+1} = [''];

text{end+1} = [char(9), 'assign dfsm_config = ', num2str(dfsm_config),';'];
text{end+1} = [char(9), 'assign quabuf_config = ', num2str(QUABUF_CONFIGBIT_WIDTH), char(39), 'd', num2str(quabuf_config),';'];
text{end+1} = [char(9), 'assign ssp_config = ', num2str(ssp_config),';'];
text{end+1} = [char(9), 'assign singbuf_config = ', num2str(singbuf_config),';'];
text{end+1} = [char(9), 'assign mode_conv_mm = ', num2str(mode_conv_mm),';'];
text{end+1} = [char(9), 'assign isac = ', num2str(isac),';'];
text{end+1} = [char(9), 'assign isrelu = ', num2str(isrelu),';'];
text{end+1} = [char(9), 'assign isbn = ', num2str(isbn),';'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'assign pe_config_', num2str(i), '_', num2str(j), ' = 1;']; end, end
for i = 0:nRows+nCols-1+nRows*nBanks-1, text{end+1} = [char(9), 'assign iport_configbts_', num2str(i), ' = ', num2str(2*rAddrWidth-1), char(39), 'd', num2str(iport_configbits(i+1)),';']; end
% for i = 0:nBanks-1, text{end+1} = [char(9), 'assign oport_configbits_', num2str(i), ' = ', num2str(oport_configbits(i+1,:)),';']; end
text{end+1} = [''];

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);
end

