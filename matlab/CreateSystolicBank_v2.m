%% Create a system verilog file of a synthesizable Systolic Array Bank v2(SAB)
function CreateSystolicBank_v2(nRows, nCols, iWidth, oWidth, name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/SystolicBank_v2.sv'; end
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
text{end+1} = ['// Module Name: SystolicBank_v2'];
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
text{end+1} = ['module SystolicBank_v2('];
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'clk,'];
text{end+1} = [char(9), 'rst,'];
text{end+1} = [char(9), 'in_en,'];
text{end+1} = [char(9), 'conv_mm,'];
text{end+1} = [char(9), 'isac,'];
text{end+1} = [char(9), 'isrelu,'];
text{end+1} = [char(9), 'isbn,'];
for i = 1:nRows text{end+1} = [char(9), 'active_', num2str(i), ',']; end
for i = 1:nRows text{end+1} = [char(9), 'data_in_horz_', num2str(i), ',']; end
for i = 1:(nRows+nCols-1) text{end+1} = [char(9), 'data_in_obli_', num2str(i), ',']; end
text{end+1} = [char(9), 'bn_param_in,'];
text{end+1} = [char(9), 'bn_param_in_en,'];
for i = 1:nCols text{end+1} = [char(9), 'A_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'B_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'C_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'D_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'E_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'F_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'G_', num2str(i), ',']; end
for i = 1:nCols text{end+1} = [char(9), 'H_', num2str(i), ',']; end
text{end+1} = [char(9), '// outputs'];
for i = 1:nCols, text{end+1} = [char(9), 'dout_en_', num2str(i), ',']; end
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

text{end+1} = [char(9), 'localparam MODE_CONV = 0; localparam MODE_MM = 1;'];
text{end+1} = [''];
    
% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'input clk, rst, in_en, conv_mm, isac, isrelu, isbn;'];
for i = 1:nRows text{end+1} = [char(9), 'input active_', num2str(i), ';']; end
for i = 1:nRows text{end+1} = [char(9), 'input [', num2str(iWidth-1), ':0] data_in_horz_', num2str(i), ';']; end
for i = 1:(nRows+nCols-1) text{end+1} = [char(9), 'input [', num2str(iWidth-1), ':0] data_in_obli_', num2str(i), ';']; end
text{end+1} = [char(9), 'input [', num2str(2*oWidth-1),':0] bn_param_in;'];
text{end+1} = [char(9), 'input bn_param_in_en;'];
for i = 1:nCols text{end+1} = [char(9), 'input A_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input B_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input C_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input D_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input E_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input F_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input G_', num2str(i), ';']; end
for i = 1:nCols text{end+1} = [char(9), 'input H_', num2str(i), ';']; end
text{end+1} = [''];
text{end+1} = [char(9), '// outputs'];
for i = 1:nCols text{end+1} = [char(9), 'output [', num2str(oWidth-1), ':0] dout_', num2str(i), ';']; end
text{end+1} = [''];
for i = 1:nCols, text{end+1} = [char(9), 'output dout_en_', num2str(i), ';']; end
text{end+1} = [''];
% bypass_en
for i = 1:nRows
    for j = 0:nCols
        text{end+1} = [char(9), 'logic bypass_en_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];

% psum
for i = 1:nRows+1
    for j = 1:nCols
        text{end+1} = [char(9), 'logic [', num2str(oWidth-1),':0] data_in_vert_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];

% data_horz 
for i = 1:nRows+1
    for j = 0:nCols
        text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] data_in_horz_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];
% date_obli 
for i = 1:nRows+1
    for j = 0:nCols
        text{end+1} = [char(9), 'logic [', num2str(iWidth-1),':0] data_in_obli_', num2str(i), '_', num2str(j), ';'];
    end
end
text{end+1} = [''];

for i = 1:nCols
    text{end+1} = [char(9), 'logic [', num2str(oWidth*2-1),':0] bn_param_out_', num2str(i), ';'];
end
text{end+1} = [''];

for i = 1:nCols
    text{end+1} = [char(9), 'logic bn_param_out_en_', num2str(i), ';'];
end
text{end+1} = [''];

k = nRows;
for i = 1: nCols
    text{end+1} = [char(9),'assign data_in_vert_', num2str(nRows+1), '_', num2str(i),' = (conv_mm == MODE_CONV)? 0: data_in_obli_', num2str(k),';'];
    k = k + 1;
end
text{end+1} = [''];

for i = 1: nRows
    text{end+1} = [char(9),'assign bypass_en_', num2str(i), '_0 = in_en;'];
end
text{end+1} = [''];

for i = 1: nRows+1
    if i <= nRows
        text{end+1} = [char(9),'assign data_in_horz_', num2str(i), '_0 = data_in_horz_', num2str(i), ';'];
    end
end
text{end+1} = [''];
k = 1;
for i = 1:nRows-1
    text{end+1} = [char(9),'assign data_in_obli_', num2str(i+1), '_0 = (conv_mm == MODE_CONV)? data_in_obli_', num2str(k), ': 0;'];
    k = k + 1;
end
for j = 1:nCols
    text{end+1} = [char(9),'assign data_in_obli_', num2str(nRows+1), '_', num2str(j-1) ,' = (conv_mm == MODE_CONV)? data_in_obli_', num2str(k), ': 0;'];
    k = k + 1;
end
text{end+1} = [''];

% creating PEs
for i = 1:nRows
    for j = 1:nCols
        text{end+1} = [char(9), 'PEv3 # (.iWIDTH(iWidth), .oWIDTH(oWidth)) p_', num2str(i), '_', num2str(j), ... 
                       '(.clk(clk), .rst(rst), .in_en(bypass_en_', num2str(i), '_', num2str(j-1), '), ', ...
                       '.data_vert(data_in_vert_', num2str(i+1), '_', num2str(j), '), ', ... 
                       '.active(active_', num2str(i), '), ', ... 
                       '.data_horz(data_in_horz_', num2str(i), '_', num2str(j-1),'), ', ...
                       '.data_obli(data_in_obli_', num2str(i+1), '_', num2str(j-1),'), ', ...
                       '.A(A_', num2str(j), '), ', ... 
                       '.B(B_', num2str(j), '), ', ...
                       '.C(C_', num2str(j), '), ', ...
                       '.D(D_', num2str(j), '), ', ...
                       '.E(E_', num2str(j), '), ', ...
                       '.H(H_', num2str(j), '), ', ...
                       '.horz_out(data_in_horz_', num2str(i), '_', num2str(j), '), ', ...
                       '.obli_out(data_in_obli_', num2str(i), '_', num2str(j), '), ', ...
                       '.bypass_en(bypass_en_', num2str(i), '_', num2str(j), '), ', ...
                       '.opsum(data_in_vert_', num2str(i), '_', num2str(j), '));'];
    end
end

text{end+1} =[''];

% creating ACs
for j = 1:nCols
    if j == 1
        text{end+1} = [char(9), 'ACv2 # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth), .BN_SCALE_WIDTH(oWidth), .BN_SHIFT_WIDTH(oWidth)) ac_', num2str(j), ... 
                       '(.clk(clk), .rst(rst), .config_bits({isac, isrelu, isbn}), .in_en(G_', num2str(j), '), ', ...
                       '.ipsum(data_in_vert_', num2str(1), '_', num2str(j), '), ', ... 
                       '.F(F_', num2str(j), '), ', ...
                       '.bn_param_in_en(bn_param_in_en), ', ...
                       '.bn_param_in(bn_param_in), ', ...
                       '.bn_param_out(bn_param_out_', num2str(j),'), ', ...
                       '.bn_param_out_en(bn_param_out_en_', num2str(j),'), ', ...
                       '.data_out_en(dout_en_', num2str(j),'), ', ...
                       '.data_out(dout_', num2str(j), '));'];
    else
        text{end+1} = [char(9), 'ACv2 # (.IN_WIDTH(oWidth), .ACC_WIDTH(oWidth), .BN_SCALE_WIDTH(oWidth), .BN_SHIFT_WIDTH(oWidth)) ac_', num2str(j), ... 
                       '(.clk(clk), .rst(rst), .config_bits({isac, isrelu, isbn}), .in_en(G_', num2str(j), '), ', ...
                       '.ipsum(data_in_vert_', num2str(1), '_', num2str(j), '), ', ... 
                       '.F(F_', num2str(j), '), ', ...
                       '.bn_param_in_en(bn_param_out_en_', num2str(j-1),'), ', ...
                       '.bn_param_in(bn_param_out_', num2str(j-1),'), ', ...
                       '.bn_param_out(bn_param_out_', num2str(j),'), ', ...
                       '.bn_param_out_en(bn_param_out_en_', num2str(j),'), ', ...
                       '.data_out_en(dout_en_', num2str(j),'), ', ...
                       '.data_out(dout_', num2str(j), '));'];
    end
end

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);