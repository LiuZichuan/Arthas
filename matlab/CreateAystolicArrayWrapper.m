%% Create a wrapper of systolic array for hardware utilization evaluation.
root = 'D:/Arthas/arthas/src/building_blocks/';
name = [root, 'SystolicArrayWrapper.sv'];
version = '1';
nBanks = 11;
nRows = 3; 
nCols = 32;
iWidth = 16; 
oWidth = 33; 
MAX_nPERIOD = 8; 
MAX_nLMAC = 3*512*8; 
MAX_nSHFT = 192; 
CreateSystolicArray(nBanks, nRows, nCols, iWidth, oWidth, MAX_nPERIOD, MAX_nLMAC, MAX_nSHFT);
CreateSystolicBank(nRows, nCols, iWidth, oWidth)
text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Author: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: SystolicArray'];
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
text{end+1} = ['module SystolicArrayWrapper('];
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'clk,'];
text{end+1} = [char(9), 'rst,'];
text{end+1} = [char(9), 'start,'];
text{end+1} = [char(9), 'in_en,'];
text{end+1} = [char(9), 'dfsm_config_en,'];
text{end+1} = [char(9), 'dfsm_config,'];
text{end+1} = [char(9), 'pe_config,'];
text{end+1} = [char(9), 'pe_config_load,'];
text{end+1} = [char(9), 'weight,'];
text{end+1} = [char(9), 'feature,']; 
text{end+1} = [char(9), '// outputs'];
for i = 1:nCols text{end+1} = [char(9), 'dout_en_', num2str(i), ',']; end
text{end+1} = [char(9), 'dout'];
text{end+1} = [');'];
text{end+1} = [char(9), 'parameter nBanks = ', num2str(nBanks),';'];
text{end+1} = [char(9), 'parameter nCols = ', num2str(nCols),';'];
text{end+1} = [char(9), 'parameter nRows = ', num2str(nRows),';'];
text{end+1} = [char(9), 'parameter iWidth = ', num2str(iWidth),';'];
text{end+1} = [char(9), 'parameter oWidth = ', num2str(oWidth),';'];
text{end+1} = [char(9), 'parameter MAX_nPERIOD = ', num2str(MAX_nPERIOD),';'];
text{end+1} = [char(9), 'parameter MAX_nLMAC = ', num2str(MAX_nLMAC),';'];
text{end+1} = [char(9), 'parameter MAX_nSHFT = ', num2str(MAX_nSHFT),';'];
text{end+1} = [''];
% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'input clk, rst, start, in_en, pe_config, pe_config_load, dfsm_config_en, dfsm_config;'];
text{end+1} = [char(9), 'input [', num2str(iWidth-1),':0] weight;'];
text{end+1} = [char(9), 'input [', num2str(iWidth-1),':0] feature;'];

text{end+1} = [char(9), '// outputs'];
for i = 1:nCols text{end+1} = [char(9), 'output dout_en_', num2str(i), ';']; end
text{end+1} = [char(9), 'output [',num2str(oWidth-1), ':0] dout;'];
text{end+1} = [''];

sumstr = [];
for i = 1:nBanks, for j = 1:nCols, sumstr = [sumstr, 'dout_', num2str(i), '_', num2str(j), ' + ']; end, end
text{end+1} = [char(9), 'assign dout = ', sumstr(1:end-2),';'];
text{end+1} = [''];

for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), '(* KEEP = "TRUE" *) logic pe_config_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), '(* KEEP = "TRUE" *) logic [', num2str(iWidth-1),':0] weight_', num2str(i), '_', num2str(j), ';']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), '(* KEEP = "TRUE" *) logic [', num2str(iWidth-1),':0] feature_', num2str(j), ';']; end
text{end+1} = [''];
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), '(* KEEP = "TRUE" *) logic [', num2str(oWidth-1),':0] dout_', num2str(i), '_', num2str(j), ';']; end, end
text{end+1} = [''];

for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'assign pe_config_', num2str(i), '_', num2str(j), ' = pe_config;']; end, end
text{end+1} = [''];

for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'assign weight_', num2str(i), '_', num2str(j), ' = weight;']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'assign feature_', num2str(j), ' = feature;']; end
text{end+1} = [''];

% % Create SysArray
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

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);