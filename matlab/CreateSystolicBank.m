%% Create a system verilog file of a synthesizable Systolic Array Bank (SAB)
function CreateSystolicBank(nRows, nCols, iWidth, oWidth, name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/SystolicBank.sv'; end
if ~exist('nRows'), nRows = 3; end
if ~exist('nCols'), nCols = 4; end
if ~exist('iWidth'), iWidth = 16; end
if ~exist('oWidth'), oWidth = 33; end
text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: SystolicBank'];
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
text{end+1} = ['module SystolicBank('];
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'clk,'];
text{end+1} = [char(9), 'rst,'];
text{end+1} = [char(9), 'in_en,'];
for i = 1:nRows text{end+1} = [char(9), 'iconfig_', num2str(i), ',']; end
text{end+1} = [char(9), 'config_load,'];
for i = 1:nRows text{end+1} = [char(9), 'weight_', num2str(i), ',']; end
for i = 1:(nRows+nCols-1) text{end+1} = [char(9), 'feature_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'A_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'B_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'C_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'D_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'E_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'F_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'G_', num2str(i), ',']; end
text{end+1} = [char(9), '// outputs'];
for i = 1:nCols 
    if i ~= nCols 
        text{end+1} = [char(9), 'dout_', num2str(i), ','];
    else 
        text{end+1} = [char(9), 'dout_', num2str(i)]; 
    end
end
text{end+1} = [');'];
text{end+1} = [char(9), 'parameter nCols = ', num2str(nCols),';'];
text{end+1} = [char(9), 'parameter nRows = ', num2str(nRows),';'];
text{end+1} = [char(9), 'parameter iWidth = ', num2str(iWidth),';'];
text{end+1} = [char(9), 'parameter oWidth = ', num2str(oWidth),';'];
text{end+1} = [''];

    
% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'input clk, rst, in_en, config_load;'];
for i = 1:nRows text{end+1} = [char(9), 'input iconfig_', num2str(i), ';']; end
for i = 1:nRows text{end+1} = [char(9), 'input [', num2str(iWidth-1), ':0] weight_', num2str(i), ';']; end
for i = 1:(nRows+nCols-1) text{end+1} = [char(9), 'input [', num2str(iWidth-1), ':0] feature_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input A_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input B_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input C_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input D_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input E_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input F_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input G_', num2str(i), ';']; end
text{end+1} = [''];
text{end+1} = [char(9), '// outputs'];
for i = 1:nCols text{end+1} = [char(9), 'output [', num2str(oWidth-1), ':0] dout_', num2str(i), ';']; end
text{end+1} = [''];
% wf_en
for i = 1:nRows
    for j = 0:nCols
        text{end+1} = [char(9), 'logic wf_en_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];

% psum
for i = 1:nRows+1
    for j = 1:nCols
        text{end+1} = [char(9), 'logic [', num2str(oWidth-1),':0] psum_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];

% weight 
for i = 1:nRows+1
    for j = 0:nCols
        text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] weight_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];
% feature 
for i = 1:nRows+1
    for j = 0:nCols
        text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] feature_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];

for i = 1: nCols
    text{end+1} = [char(9),'assign psum_', num2str(nRows+1), '_', num2str(i),' = 0;'];
end
text{end+1} = [''];

for i = 1: nRows
    text{end+1} = [char(9),'assign wf_en_', num2str(i), '_0 = in_en;'];
end
text{end+1} = [''];

for i = 1: nRows+1
    if i <= nRows
        text{end+1} = [char(9),'assign weight_', num2str(i), '_0 = weight_', num2str(i), ';'];
    end
end
text{end+1} = [''];
k = 1;
for i = 1:nRows
    text{end+1} = [char(9),'assign feature_', num2str(i+1), '_0 = feature_', num2str(k), ';'];
    k = k + 1;
end
for j = 2:nCols
    text{end+1} = [char(9),'assign feature_', num2str(nRows+1), '_', num2str(j-1) ,' = feature_', num2str(k), ';'];
    k = k + 1;
end
text{end+1} = [''];

% creating PEs
for i = 1:nRows
    for j = 1:nCols
        text{end+1} = [char(9), 'PEv2 # (.WIDTH(iWidth)) p_', num2str(i), '_', num2str(j), ... 
                       '(.clk(clk), .rst(rst), .in_en(wf_en_', num2str(i), '_', num2str(j-1), '), ', ...
                       '.ipsum(psum_', num2str(i+1), '_', num2str(j), '), ', ... 
                       '.iconfig(iconfig_', num2str(i), '), ', ... 
                       '.weight(weight_', num2str(i), '_', num2str(j-1),'), ', ...
                       '.feature(feature_', num2str(i+1), '_', num2str(j-1),'), ', ...
                       '.config_load(config_load), ', ...
                       '.A(A_', num2str(j), '), ', ... 
                       '.B(B_', num2str(j), '), ', ...
                       '.C(C_', num2str(j), '), ', ...
                       '.D(D_', num2str(j), '), ', ...
                       '.E(E_', num2str(j), '), ', ...
                       '.w_out(weight_', num2str(i), '_', num2str(j), '), ', ...
                       '.f_out(feature_', num2str(i), '_', num2str(j), '), ', ...
                       '.wf_en(wf_en_', num2str(i), '_', num2str(j), '), ', ...
                       '.opsum(psum_', num2str(i), '_', num2str(j), '));'];
    end
end

text{end+1} =[''];

% creating ACs
for j = 1:nCols
    text{end+1} = [char(9), 'AC # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth)) ac_', num2str(j), ... 
                   '(.clk(clk), .rst(rst), .in_en(G_', num2str(j), '), ', ...
                   '.ipsum(psum_', num2str(1), '_', num2str(j), '), ', ... 
                   '.F(F_', num2str(j), '), ', ...
                   '.data_out(dout_', num2str(j), '));'];
end

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);