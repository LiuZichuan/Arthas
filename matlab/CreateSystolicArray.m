%% Create a system verilog file of a synthesizable Systolic Array (SA)
function CreateSystolicArray(nBanks, nRows, nCols, iWidth, oWidth, MAX_nPERIOD, MAX_nLMAC, MAX_nSHFT, name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/SystolicArray.sv'; end
if ~exist('nBanks'), nBanks = 2; end
if ~exist('nRows'), nRows = 3; end
if ~exist('nCols'), nCols = 4; end
if ~exist('iWidth'), iWidth = 16; end
if ~exist('oWidth'), oWidth = 33; end
if ~exist('MAX_nPERIOD'), MAX_nPERIOD = 8; end
if ~exist('MAX_nLMAC'), MAX_nLMAC = 3*512*8; end
if ~exist('MAX_nSHFT'), MAX_nSHFT = 192; end
text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
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
text{end+1} = ['module SystolicArray('];
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'clk,'];
text{end+1} = [char(9), 'rst,'];
text{end+1} = [char(9), 'start,'];
text{end+1} = [char(9), 'in_en,'];
text{end+1} = [char(9), 'dfsm_config_en,'];
text{end+1} = [char(9), 'dfsm_config,'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'pe_config_', num2str(i), '_', num2str(j), ',']; end, end
text{end+1} = [char(9), 'pe_config_load,'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'weight_', num2str(i), '_', num2str(j), ',']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'feature_', num2str(j), ',']; end
text{end+1} = [char(9), '// outputs'];
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), 'dout_', num2str(i), '_', num2str(j), ',']; end, end
for i = 1:nCols text{end+1} = [char(9), 'dout_en_', num2str(i), ',']; end
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
text{end+1} = [char(9), 'input clk, rst, start, in_en, pe_config_load, dfsm_config_en, dfsm_config;'];
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'input pe_config_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nBanks, for j = 1:nRows, text{end+1} = [char(9), 'input [', num2str(iWidth-1),':0] weight_', num2str(i), '_', num2str(j), ';']; end, end
for j = 1:(nRows+nCols-1), text{end+1} = [char(9), 'input [', num2str(iWidth-1),':0] feature_', num2str(j), ';']; end
text{end+1} = [''];
text{end+1} = [char(9), '// outputs'];
for i = 1:nBanks, for j = 1:nCols, text{end+1} = [char(9), 'output [', num2str(oWidth-1),':0] dout_', num2str(i), '_', num2str(j), ';']; end, end
for i = 1:nCols text{end+1} = [char(9), 'output dout_en_', num2str(i), ';']; end
text{end+1} = [''];
text{end+1} = [''];
for i = 1:nCols text{end+1} = [char(9), 'logic A_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic B_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic C_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic D_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic E_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic F_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'logic G_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nCols text{end+1} = [char(9), 'logic dfsm_data_en_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nCols text{end+1} = [char(9), 'logic start_bypass_', num2str(i), ';']; end
text{end+1} = [''];
% Create SysBank
for i = 1:nBanks
    pe_config = [];
    weight = [];
    feature = [];
    A = []; B = []; C = []; D = []; E = []; F = []; G = [];
    dout = [];
    for j = 1:nRows
        weight = [weight, '.weight_', num2str(j),'(weight_', num2str(i), '_', num2str(j), '), '];
        pe_config = [pe_config, '.iconfig_', num2str(j),'(pe_config_', num2str(i), '_', num2str(j), '), '];
    end
    for j = 1:(nRows+nCols-1)
        feature = [feature, '.feature_', num2str(j),'(feature_', num2str(j), '), '];
    end
    for j = 1:nCols
        A = [A, '.A_', num2str(j), '(A_', num2str(j),'), '];
        B = [B, '.B_', num2str(j), '(B_', num2str(j),'), '];
        C = [C, '.C_', num2str(j), '(C_', num2str(j),'), '];
        D = [D, '.D_', num2str(j), '(D_', num2str(j),'), '];
        E = [E, '.E_', num2str(j), '(E_', num2str(j),'), '];
        F = [F, '.F_', num2str(j), '(F_', num2str(j),'), '];
        G = [G, '.G_', num2str(j), '(G_', num2str(j),'), '];
        dout = [dout, '.dout_', num2str(j), '(dout_', num2str(i), '_', num2str(j),'), '];
    end
    dout = dout(1:end-2);
    text{end+1} = [char(9), 'SystolicBank # (.iWidth(iWidth), .oWidth(oWidth), .nRows(nRows), .nCols(nCols)) bank_', num2str(i), '('...
                   '.clk(clk), .rst(rst), .in_en(in_en), .config_load(pe_config_load), ', ...
                   pe_config, weight, feature, A, B, C, D, E, F, G, dout ...
                   ,');'];
end
text{end+1} = [''];
% Create DFSM
for i = 1:nCols
    if i == 1
        text{end+1} = [char(9), 'DFSM # (.MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) fsm_', num2str(i), '('...
                       '.clk(clk), .rst(rst), .config_en(dfsm_config_en), .iconfig(dfsm_config), ', ...
                       '.in_en(in_en), .start(start), ', ...
                       '.in_en_bypass(dfsm_data_en_', num2str(i),'), ', ...
                       '.out_en(dout_en_', num2str(i),'), ', ...
                       '.start_out(start_bypass_', num2str(i),'), ', ...
                       '.A(A_', num2str(i),'), ', ...
                       '.B(B_', num2str(i),'), ', ...
                       '.C(C_', num2str(i),'), ', ...
                       '.D(D_', num2str(i),'), ', ...
                       '.E(E_', num2str(i),'), ', ...
                       '.F(F_', num2str(i),'), ', ...
                       '.G(G_', num2str(i),')', ...
                       ');'];
    else
        text{end+1} = [char(9), 'DFSM # (.MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) fsm_', num2str(i), '('...
                       '.clk(clk), .rst(rst), .config_en(dfsm_config_en), .iconfig(dfsm_config), ', ...
                       '.in_en(dfsm_data_en_', num2str(i-1),'), ', ...
                       '.start(start_bypass_', num2str(i-1),'), ', ...
                       '.in_en_bypass(dfsm_data_en_', num2str(i),'), ', ...
                       '.out_en(dout_en_', num2str(i),'), ', ...
                       '.start_out(start_bypass_', num2str(i),'), ', ...
                       '.A(A_', num2str(i),'), ', ...
                       '.B(B_', num2str(i),'), ', ...
                       '.C(C_', num2str(i),'), ', ...
                       '.D(D_', num2str(i),'), ', ...
                       '.E(E_', num2str(i),'), ', ...
                       '.F(F_', num2str(i),'), ', ...
                       '.G(G_', num2str(i),')', ...
                       ');'];
    end
end
text{end+1} = [''];
% add = [];
% for i = 1:nBanks
%     for j = 1:nCols
%         add = [add, ' + dout_', num2str(i), '_', num2str(j)]; 
%     end 
% end
% text{end+1} = [char(9), 'assign dout = 0', add, ';'];
text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);