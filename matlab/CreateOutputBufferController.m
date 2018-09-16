%% Create a system verilog file of a synthesizable Output Buffer Controller (OBC)
function CreateOutputBufferController(nPorts, wAddrWidth, wDataWidth, name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/OBC.sv'; end
if ~exist('nPorts'), nPorts = 7; end
if ~exist('wAddrWidth'), wAddrWidth = 28; end
if ~exist('wDataWidth'), wDataWidth = 64; end
if ~exist('wMaskWidth'), wMaskWidth = 8; end
WIDTH_P_ID = 6;
if ~exist('wReqWidth'), wReqWidth = wAddrWidth + wDataWidth + wMaskWidth + WIDTH_P_ID; end

text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: Output Buffer Controller'];
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
text{end+1} = ['module OBC('];
text{end+1} = [char(9), '// inputs from PC'];
text{end+1} = [char(9), 'clk_bus,'];
text{end+1} = [char(9), 'rst_bus,'];
text{end+1} = [char(9), 'w_req,'];
text{end+1} = [char(9), 'w_req_en,'];
for i = 0: nPorts-1, text{end+1} = [char(9), 'tk_out_', num2str(i), ',']; end
text{end+1} = [char(9), '// inputs from MIF'];
text{end+1} = [char(9), 'mem2obc_en,'];
text{end+1} = [char(9), '// outputs to MIF'];
text{end+1} = [char(9), 'obc2mem_w_addr,'];
text{end+1} = [char(9), 'obc2mem_w_vld,']; 
text{end+1} = [char(9), 'obc2mem_w_data,']; 
text{end+1} = [');'];
text{end+1} = [''];

text{end+1} = [char(9), 'parameter nPorts = ', num2str(nPorts),';'];
text{end+1} = [char(9), 'parameter wAddrWidth = ', num2str(wAddrWidth),';'];
text{end+1} = [char(9), 'parameter wDataWidth = ', num2str(wDataWidth),';'];
text{end+1} = [char(9), 'parameter wReqWidth = ', num2str(wReqWidth),';'];
text{end+1} = [char(9), 'parameter wMaskWidth = ', num2str(wMaskWidth),';'];
text{end+1} = [''];

text{end+1} = [char(9), 'localparam FIFO_ASIZE = ($clog2(nPorts) > 2)? $clog2(nPorts) : 2;'];
text{end+1} = [''];

% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'input clk_bus, rst_bus, w_req_en, mem2obc_en;'];
text{end+1} = [char(9), 'input [wReqWidth-1:0] w_req;'];
text{end+1} = [''];

text{end+1} = [char(9), '// outputs'];
for i = 0: nPorts-1, text{end+1} = [char(9), 'output tk_out_', num2str(i), ';']; end
text{end+1} = [char(9), 'output [wAddrWidth-1:0] obc2mem_w_addr;'];
text{end+1} = [char(9), 'output [wDataWidth-1:0] obc2mem_w_data;'];
text{end+1} = [char(9), 'output obc2mem_w_vld;'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic [wAddrWidth-1:0] pc2obc_addr;'];
text{end+1} = [char(9), 'assign pc2obc_addr = w_req[wDataWidth+wMaskWidth+wAddrWidth-1:wDataWidth+wMaskWidth];'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic [wDataWidth-1:0] pc2obc_data_mask;'];
text{end+1} = [char(9), 'assign pc2obc_data_mask = w_req[wDataWidth+wMaskWidth-1:wDataWidth];'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic [wDataWidth-1:0] pc2obc_data;'];
text{end+1} = [char(9), 'assign pc2obc_data = w_req[wDataWidth-1:0];'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign obc2mem_w_data = (fifo_sel)? obc2mem_data_1: obc2mem_data_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'assign obc2mem_w_addr = (fifo_sel)? obc2mem_addr_1: obc2mem_addr_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'assign obc2mem_w_vld = ~w_addr_fifo_empty;'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic tk_count;'];
text{end+1} = [char(9), 'always@(posedge clk_bus) begin'];
text{end+1} = [char(9), char(9), 'if (~rst_bus) begin'];
text{end+1} = [char(9), char(9), char(9), 'tk_count <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else if (~(w_addr_fifo_full_almost || w_addr_fifo_full)) begin'];
text{end+1} = [char(9), char(9), char(9), 'tk_count = (tk_count < nPorts-1)? tk_count + 1 : 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic fifo_sel;'];
text{end+1} = [char(9), 'always@(posedge clk_bus) begin'];
text{end+1} = [char(9), char(9), 'if (~rst_bus) begin'];
text{end+1} = [char(9), char(9), char(9), 'fifo_sel <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else if ((w_addr_fifo_full_almost || w_addr_fifo_full) && w_req_en && fifo_sel == 0) begin'];
text{end+1} = [char(9), char(9), char(9), 'fifo_sel = ~fifo_sel;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else if ((w_addr_fifo_full_almost || w_addr_fifo_full) && w_req_en && fifo_sel == 1) begin'];
text{end+1} = [char(9), char(9), char(9), 'fifo_sel = ~fifo_sel;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic w_addr_fifo_full;'];
text{end+1} = [char(9), 'assign w_addr_fifo_full = (~fifo_sel)? w_addr_fifo_full_1: w_addr_fifo_full_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic w_addr_fifo_empty;'];
text{end+1} = [char(9), 'assign w_addr_fifo_empty = (fifo_sel)? w_addr_fifo_empty_1: w_addr_fifo_empty_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic w_addr_fifo_full_almost;'];
text{end+1} = [char(9), 'assign w_addr_fifo_full_almost = (~fifo_sel)? w_addr_fifo_full_almost_1: w_addr_fifo_full_almost_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic [wAddrWidth-1:0] pc2ibc_addr;'];
text{end+1} = [char(9), 'assign obc2mem_addr = (fifo_sel)? obc2mem_addr_1: obc2mem_addr_2;'];
text{end+1} = [''];

text{end+1} = [char(9), '// w_addr_fifo_1'];
text{end+1} = [char(9), 'logic w_addr_fifo_full_1;'];
text{end+1} = [char(9), 'logic w_addr_fifo_empty_1;'];
text{end+1} = [char(9), 'logic w_addr_fifo_full_almost_1;'];
text{end+1} = [char(9), 'logic mem2obc_addr_en_1;'];
text{end+1} = [char(9), 'logic w_req_en_1;'];
text{end+1} = [char(9), 'logic [wAddrWidth-1:0] obc2mem_addr_1;'];
text{end+1} = [char(9), 'logic [wAddrWidth-1:0] pc2obc_addr_1;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign w_req_en_1 = (~fifo_sel)? w_req: 0;'];
text{end+1} = [char(9), 'assign mem2obc_addr_en_1 = (fifo_sel)? mem2obc_en: 0;'];
text{end+1} = [char(9), 'assign pc2obc_addr_1 = (~fifo_sel)? pc2obc_addr: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(wAddrWidth), .ASIZE(FIFO_ASIZE)) w_addr_fifo_1(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(w_req_en_1), ', ...
                       '.rinc(mem2obc_addr_en_1), ', ...
                       '.wfull(w_addr_fifo_full_1), ', ...
                       '.rempty(w_addr_fifo_empty_1), ', ...
                       '.wfull_almost(w_addr_fifo_full_almost_1), ', ...
                       '.rdata(obc2mem_addr_1), ', ...
                       '.wdata(pc2obc_addr_1)', ...
                       ');'];
text{end+1} = [''];
 
text{end+1} = [char(9), '// w_addr_fifo_2'];                  
text{end+1} = [char(9), 'logic w_addr_fifo_full_2;'];
text{end+1} = [char(9), 'logic w_addr_fifo_empty_2;'];
text{end+1} = [char(9), 'logic w_addr_fifo_full_almost_2;'];
text{end+1} = [char(9), 'logic mem2obc_addr_en_2;'];
text{end+1} = [char(9), 'logic w_req_en_2;'];
text{end+1} = [char(9), 'logic [wAddrWidth-1:0] obc2mem_addr_2;'];
text{end+1} = [char(9), 'logic [wAddrWidth-1:0] pc2obc_addr_2;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign w_req_en_2 = (fifo_sel)? w_req: 0;'];
text{end+1} = [char(9), 'assign mem2obc_addr_en_2 = (~fifo_sel)? mem2obc_en: 0;'];
text{end+1} = [char(9), 'assign pc2obc_addr_2 = (fifo_sel)? pc2obc_addr: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(wAddrWidth), .ASIZE(FIFO_ASIZE)) w_addr_fifo_2(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(w_req_en_2), ', ...
                       '.rinc(mem2obc_addr_en_2), ', ...
                       '.wfull(w_addr_fifo_full_2), ', ...
                       '.rempty(w_addr_fifo_empty_2), ', ...
                       '.wfull_almost(w_addr_fifo_full_almost_2), ', ...
                       '.rdata(obc2mem_addr_2), ', ...
                       '.wdata(pc2obc_addr_2)', ...
                       ');'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic data_fifo_full;'];
text{end+1} = [char(9), 'assign data_fifo_full = (~fifo_sel)? data_fifo_full_1: data_fifo_full_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic data_fifo_empty;'];
text{end+1} = [char(9), 'assign data_fifo_empty = (~fifo_sel)? data_fifo_empty_1: data_fifo_empty_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic data_fifo_full_almost;'];
text{end+1} = [char(9), 'assign data_fifo_full_almost = (~fifo_sel)? data_fifo_full_almost_1: data_fifo_full_almost_2;'];
text{end+1} = [''];
% text{end+1} = [char(9), 'assign obc2mem_data = (~fifo_sel)? obc2mem_data_1: obc2mem_data_2;'];
% text{end+1} = [''];

text{end+1} = [char(9), '// data_fifo_1'];   
text{end+1} = [char(9), 'logic data_fifo_full_1;'];
text{end+1} = [char(9), 'logic data_fifo_empty_1;'];
text{end+1} = [char(9), 'logic data_fifo_full_almost_1;'];
text{end+1} = [char(9), 'logic mem2obc_data_en_1;'];
text{end+1} = [char(9), 'logic [wDataWidth-1:0] obc2mem_data_1;'];
text{end+1} = [char(9), 'logic [wDataWidth-1:0] pc2obc_data_1;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign pc2obc_data_1 = (~fifo_sel)? pc2obc_data: 0;'];
text{end+1} = [char(9), 'assign mem2obc_data_en_1 = (fifo_sel)? mem2obc_en: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(wReqWidth-wAddrWidth), .ASIZE(FIFO_ASIZE)) data_fifo_1(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(w_req_en_1), ', ...
                       '.rinc(mem2obc_data_en_1), ', ...
                       '.wfull(data_fifo_full_1), ', ...
                       '.rempty(data_fifo_empty_1), ', ...
                       '.wfull_almost(data_fifo_full_almost_1), ', ...
                       '.rdata(obc2mem_data_1), ', ...
                       '.wdata(pc2obc_data_1)', ...
                       ');'];
text{end+1} = [''];

text{end+1} = [char(9), '// data_fifo_2'];   
text{end+1} = [char(9), 'logic data_fifo_full_2;'];
text{end+1} = [char(9), 'logic data_fifo_empty_2;'];
text{end+1} = [char(9), 'logic data_fifo_full_almost_2;'];
text{end+1} = [char(9), 'logic mem2obc_data_en_2;'];
text{end+1} = [char(9), 'logic [wDataWidth-1:0] obc2mem_data_2;'];
text{end+1} = [char(9), 'logic [wDataWidth-1:0] pc2obc_data_2;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign pc2obc_data_2 = (fifo_sel)? pc2obc_data: 0;'];
text{end+1} = [char(9), 'assign mem2obc_data_en_2 = (~fifo_sel)? mem2obc_en: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(wReqWidth-wAddrWidth), .ASIZE(FIFO_ASIZE)) data_fifo_2(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(w_req_en_2), ', ...
                       '.rinc(mem2obc_data_en_2), ', ...
                       '.wfull(data_fifo_full_2), ', ...
                       '.rempty(data_fifo_empty_2), ', ...
                       '.wfull_almost(data_fifo_full_almost_2), ', ...
                       '.rdata(obc2mem_data_2), ', ...
                       '.wdata(pc2obc_data_2)', ...
                       ');'];
text{end+1} = [''];

for i = 0: nPorts-1
    text{end+1} = [char(9), 'assign tk_out_', num2str(i), ' = (tk_count == ', num2str(i-1),' && ~w_addr_fifo_full_almost && ~w_addr_fifo_full)? 1: 0;'];
    text{end+1} = [''];
end

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);
end