%% Create a testbench file of a synthesizable Systolic Array (SA)
function CreateSystolicArrayTb(nBanks, nRows, nCols, iWidth, oWidth, CLK_PERIOD, PROCESSING_CYC, wPaths, fPaths, enPath, oPaths, name)
addpath('utils')
if ~exist('name'), name = 'D:/Arthas/arthas/src/sim/SystolicArray_tb.sv'; end
if ~exist('wPaths'), wPaths = 'D:/tmp/arthas/weights'; end
if ~exist('fPaths'), fPaths = 'D:/tmp/arthas/features'; end
if ~exist('enPath'), enPath = 'D:/tmp/arthas/in_en.dat'; end
if ~exist('oPaths'), oPaths = 'D:/tmp/arthas/output'; end
nBanks = 2;
nRows = 3;
nCols = 4;
iWidth = 16;
oWidth = 33;
MAX_nPERIOD = 8;
MAX_nLMAC = 3*512*8;
MAX_nSHFT = 192;
CLK_PERIOD = 10;
PROCESSING_CYC = 2000;
CONF_REG_LEN = ceil(log2(MAX_nPERIOD) + log2(MAX_nLMAC) + log2(MAX_nSHFT));
dfsm_config_nPreiod = 2; % number of output features
assert(dfsm_config_nPreiod < 2^(ceil(log2(MAX_nPERIOD))));
dfsm_config_nLMAC = 9; % number of MAC input 
assert(dfsm_config_nLMAC < 2^(ceil(log2(MAX_nLMAC))));
dfsm_config_nSHFT = 3; % number of window size
assert(dfsm_config_nSHFT < 2^(ceil(log2(MAX_nSHFT))));
dfsm_config_bit = dfsm_config_nSHFT + dfsm_config_nLMAC * 2^(ceil(log2(MAX_nSHFT))) ... 
                 + dfsm_config_nPreiod * 2^(ceil(log2(MAX_nSHFT)) + ceil(log2(MAX_nLMAC)));
text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['module SystolicArray_tb();'];
text{end+1} = [char(9), 'parameter nBanks = ', num2str(nBanks),';'];
text{end+1} = [char(9), 'parameter nCols = ', num2str(nCols),';'];
text{end+1} = [char(9), 'parameter nRows = ', num2str(nRows),';'];
text{end+1} = [char(9), 'parameter iWidth = ', num2str(iWidth),';'];
text{end+1} = [char(9), 'parameter oWidth = ', num2str(oWidth),';'];
text{end+1} = [char(9), 'parameter MAX_nPERIOD = ', num2str(MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter MAX_nLMAC = ', num2str(MAX_nLMAC),';'];
text{end+1} = [char(9), 'parameter MAX_nSHFT = ', num2str(MAX_nSHFT),';'];
text{end+1} = [char(9), 'parameter CLK_PERIOD = ', num2str(CLK_PERIOD),';'];
text{end+1} = [char(9), 'parameter PROCESSING_CYC = ', num2str(PROCESSING_CYC),';'];
text{end+1} = [char(9), 'parameter CONF_REG_LEN = ', num2str(CONF_REG_LEN),';'];
text{end+1} = [char(9), 'parameter dfsm_config_nPreiod = ', num2str(dfsm_config_nPreiod),';'];
text{end+1} = [char(9), 'parameter dfsm_config_nLMAC = ', num2str(dfsm_config_nLMAC),';'];
text{end+1} = [char(9), 'parameter dfsm_config_nSHFT = ', num2str(dfsm_config_nSHFT),';'];
text{end+1} = [char(9), 'parameter dfsm_config_bit = ', num2str(dfsm_config_bit),';'];
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'reg clk, rst, start, in_en, pe_config_load, dfsm_config_en, dfsm_config;'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'reg pe_config_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'reg [', num2str(iWidth-1),':0] weight_', num2str(i), '_', num2str(j), ';']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'reg [', num2str(iWidth-1),':0] feature_', num2str(j), ';']; end
text{end+1} = [''];
text{end+1} = [char(9), '// outputs'];
text{end+1} = [char(9), 'wire [', num2str(oWidth-1),':0] dout;'];
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), 'wire [', num2str(oWidth-1),':0] dout_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nCols text{end+1} = [char(9), 'wire dout_en_', num2str(i), ';']; end
text{end+1} = [''];

% behavior
text{end+1} = [char(9), '// clk'];
text{end+1} = [char(9), 'always #(CLK_PERIOD/2) clk = ~clk;'];

text{end+1} = [''];
% initial
text{end+1} = [char(9), 'reg processing;'];
text{end+1} = [char(9), 'integer inEnId;'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'integer featureId_', num2str(j),';'];end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'integer weightId_', num2str(i),'_', num2str(j),';'];end, end
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), 'integer outputId_', num2str(i), '_', num2str(j), ';']; end,end
text{end+1} = [''];
text{end+1} = [char(9), 'initial begin'];
text{end+1} = [char(9), char(9), 'clk = 0; rst = 0; in_en = 0; start = 0; processing = 0;'];
text{end+1} = [char(9), char(9), 'pe_config_load = 0; dfsm_config_en = 0; dfsm_config = 0;'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), 'feature_', num2str(j), ' = 0;']; end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), 'weight_', num2str(i), '_', num2str(j), ' = 0;']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), 'pe_config_', num2str(i), '_', num2str(j), ' = 1;']; end, end
text{end+1} = [char(9), char(9), 'inEnId = $fopen("', enPath,'", "r");'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), 'weightId_', num2str(i), '_', num2str(j),' = $fopen("', wPaths,'_', num2str(i),'_', num2str(j),'.dat", "r");'];end,end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), 'featureId_', num2str(j),' = $fopen("', fPaths, '_', num2str(j),'.dat", "r");']; end
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), char(9), 'outputId_', num2str(i), '_', num2str(j),' = $fopen("', oPaths, '_', num2str(i), '_', num2str(j), '.rst", "wt");']; end,end
for i = 1:nCols, text{end+1} = [char(9), char(9), 'force U.fsm_', num2str(i),'.configs[', num2str(CONF_REG_LEN-1),':0] = ', num2str(CONF_REG_LEN), char(39), 'd', num2str(dfsm_config_bit),';']; end
for n = 1:nBanks, for i = 1:nRows, for j=1:nCols,  text{end+1} = [char(9), char(9), 'force U.bank_', num2str(n),'.p_', num2str(i),'_', num2str(j),'.active = 1;']; end, end, end
text{end+1} = [char(9), char(9), '#(10*CLK_PERIOD)'];
text{end+1} = [char(9), char(9), 'rst = 1; start = 1;'];
text{end+1} = [char(9), char(9), '#(CLK_PERIOD)'];
text{end+1} = [char(9), char(9), 'start = 0;'];
text{end+1} = [char(9), char(9), 'processing = 1;'];
text{end+1} = [char(9), char(9), '# (PROCESSING_CYC*CLK_PERIOD)'];
text{end+1} = [char(9), char(9), 'processing = 0;'];
text{end+1} = [char(9), char(9), '$fclose(inEnId);'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), '$fclose(weightId_', num2str(i), '_', num2str(j), ');'];end,end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), '$fclose(featureId_', num2str(j),');']; end
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), char(9), '$fclose(outputId_', num2str(i), '_', num2str(j),');']; end,end
text{end+1} = [char(9), 'end'];
text{end+1} = [char(9), ''];

% weights, feature and in_en
text{end+1} = [char(9), 'reg in_en_rd;'];
text{end+1} = [char(9), 'integer status;'];
text{end+1} = [char(9), 'always@(posedge clk) begin'];
text{end+1} = [char(9), char(9), 'if(~rst) begin'];
text{end+1} = [char(9), char(9), char(9), 'in_en <= 0;'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), 'feature_', num2str(j), ' <= 0;']; end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), 'weight_', num2str(i), '_', num2str(j), ' <= 0;']; end, end
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else begin'];
text{end+1} = [char(9), char(9), char(9), 'if (processing && !$feof(inEnId)) begin'];
text{end+1} = [char(9), char(9), char(9), char(9), 'status = $fscanf(inEnId, "%b\n", in_en_rd);'];
text{end+1} = [char(9), char(9), char(9), char(9), 'in_en <= in_en_rd;'];
text{end+1} = [char(9), char(9), char(9), char(9), 'if (in_en_rd) begin'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'status = $fscanf(featureId_', num2str(j),', "%b\n", feature_', num2str(j),');'];end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'status = $fscanf(weightId_', num2str(i),'_', num2str(j),', "%b\n", weight_', num2str(i),'_', num2str(j),');'];end, end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), char(9), 'else begin'];
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'feature_', num2str(j),' <= 0;'];end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), char(9), char(9), char(9), char(9), 'weight_', num2str(i),'_', num2str(j),' <= 0;']; end, end
text{end+1} = [char(9), char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

for i = 1:nBanks
    for j = 1:nCols
        text{end+1} = [char(9), 'always@(posedge clk) begin'];
        text{end+1} = [char(9), char(9), 'if (dout_en_', num2str(j), ') begin'];
        text{end+1} = [char(9), char(9), char(9), '$fwrite(outputId_', num2str(i), '_', num2str(j),',"%b\n", dout_', num2str(i), '_', num2str(j), ');'];
        text{end+1} = [char(9), char(9), 'end'];
        text{end+1} = [char(9), 'end'];
        text{end+1} = [''];
    end
end

% Create SysArray
pe_config = [];
weight = [];
feature = [];
dout = [];
dout_en = [];
for i = 1:nBanks
    for j = 1:nRows
        weight = [weight, '.weight_', num2str(i), '_', num2str(j),'(weight_', num2str(i), '_', num2str(j), '), '];
        pe_config = [pe_config, '.pe_config_', num2str(i), '_', num2str(j),'(pe_config_', num2str(i), '_', num2str(j), '), '];
    end
end
for j = 1:(nRows+nCols-1)
    feature = [feature, '.feature_', num2str(j),'(feature_', num2str(j), '), '];
end
for i = 1:nBanks
    for j = 1:nCols
        dout = [dout, '.dout_', num2str(i), '_', num2str(j), '(dout_', num2str(i), '_', num2str(j),'), '];
    end
end
for j = 1:nCols
    dout_en = [dout_en, '.dout_en_', num2str(j), '(dout_en_', num2str(j),'), '];
end
text{end+1} = [char(9), 'SystolicArray # (.iWidth(iWidth), .oWidth(oWidth), .nBanks(nBanks), .nRows(nRows), ', ...
               '.nCols(nCols), .MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) U ('...
               '.clk(clk), .rst(rst), .in_en(in_en), .start(start), ', ...
               pe_config, weight, feature, dout, dout_en, ...
               '.dfsm_config_en(dfsm_config_en), .dfsm_config(dfsm_config), ', ...
               '.pe_config_load(pe_config_load)' ...
               ,');'];
text{end+1} = [''];

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);