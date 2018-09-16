%% Create a system verilog file of a synthesizable Input Buffer Controller (IBC)
function CreateInputBufferController(nPorts, rAddrWidth, rDataWidth, name)
if ~exist('name'), name = 'D:/Arthas/arthas/src/building_blocks/IBC.sv'; end
if ~exist('nPorts'), nPorts = 7; end
if ~exist('rReqWidth'), rReqWidth = 31; end
if ~exist('rAddrWidth'), rAddrWidth = 28; end
if ~exist('rDataWidth'), rDataWidth = 64; end

text = {};
text{end+1} = ['`timescale 1ns / 1ps'];
text{end+1} = ['//////////////////////////////////////////////////////////////////////////////////'];
text{end+1} = ['// Company: '];
text{end+1} = ['// Engineer: Liu Zichuan'];
text{end+1} = ['// '];
text{end+1} = ['// Create Date: 09/01/2017 09:40:47 PM'];
text{end+1} = ['// Design Name: Arthas'];
text{end+1} = ['// Module Name: Input Buffer Controller'];
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
text{end+1} = ['module IBC('];
text{end+1} = [char(9), '// inputs from PC'];
text{end+1} = [char(9), 'clk_bus,'];
text{end+1} = [char(9), 'rst_bus,'];
text{end+1} = [char(9), 'r_req,'];
text{end+1} = [char(9), 'r_req_en,'];
text{end+1} = [char(9), '// inputs from MIF'];
text{end+1} = [char(9), 'mem2ibc_en,'];
text{end+1} = [char(9), 'mem2ibc_data,'];
text{end+1} = [char(9), 'mem2ibc_data_en,'];
text{end+1} = [char(9), '// outputs to MIF'];
text{end+1} = [char(9), 'ibc2mem_r_addr,'];
text{end+1} = [char(9), 'ibc2mem_r_vld,'];
text{end+1} = [char(9), '// outputs to PC'];
text{end+1} = [char(9), 'ibc2pc_data,']; 
for i = 0: nPorts-1, text{end+1} = [char(9), 'ibc2pc_data_en_', num2str(i), ',']; end
for i = 0: nPorts-1, text{end+1} = [char(9), 'tk_out_', num2str(i), ',']; end
text{end+1} = [');'];
text{end+1} = [''];

text{end+1} = [char(9), 'parameter nPorts = ', num2str(nPorts),';'];
text{end+1} = [char(9), 'parameter rAddrWidth = ', num2str(rAddrWidth),';'];
text{end+1} = [char(9), 'parameter rDataWidth = ', num2str(rDataWidth),';'];
text{end+1} = [char(9), 'parameter rReqWidth = ', num2str(rReqWidth),';'];
text{end+1} = [''];

text{end+1} = [char(9), 'localparam FIFO_ASIZE = ($clog2(nPorts) > 2)? $clog2(nPorts) : 2;'];
text{end+1} = [''];

% signal definition
text{end+1} = [char(9), '// inputs'];
text{end+1} = [char(9), 'input clk_bus, rst_bus, r_req_en, mem2ibc_data_en, mem2ibc_en;'];
text{end+1} = [char(9), 'input [rReqWidth-1:0] r_req;'];
text{end+1} = [char(9), 'input [rDataWidth-1:0] mem2ibc_data;'];
text{end+1} = [''];

text{end+1} = [char(9), '// outputs'];
for i = 0: nPorts-1, text{end+1} = [char(9), 'output ibc2pc_data_en_', num2str(i), ';']; end
for i = 0: nPorts-1, text{end+1} = [char(9), 'output tk_out_', num2str(i), ';']; end
text{end+1} = [char(9), 'output [rAddrWidth-1:0] ibc2mem_r_addr;'];
text{end+1} = [char(9), 'output ibc2mem_r_vld;'];
text{end+1} = [char(9), 'output [rDataWidth-1:0] ibc2pc_data;'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic [rAddrWidth-1:0] pc2ibc_addr;'];
text{end+1} = [char(9), 'assign pc2ibc_addr = r_req[rAddrWidth-1:0];'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] p_id;'];
text{end+1} = [char(9), 'assign p_id = r_req[rReqWidth-1:rAddrWidth];'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign ibc2mem_r_addr = (fifo_sel)? ibc2mem_addr_1: ibc2mem_addr_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'assign ibc2mem_r_vld = ~r_addr_fifo_empty;'];
text{end+1} = [''];

% text{end+1} = [char(9), 'logic tk_count;'];
% text{end+1} = [char(9), 'always@(posedge clk_bus) begin'];
% text{end+1} = [char(9), char(9), 'if (~rst_bus) begin'];
% text{end+1} = [char(9), char(9), char(9), 'tk_count <= 0;'];
% text{end+1} = [char(9), char(9), 'end'];
% text{end+1} = [char(9), char(9), 'else if (~(r_addr_fifo_full_almost || r_addr_fifo_full)) begin'];
% text{end+1} = [char(9), char(9), char(9), 'tk_count = (tk_count < nPorts-1)? tk_count + 1 : 0;'];
% text{end+1} = [char(9), char(9), 'end'];
% text{end+1} = [char(9), 'end'];
% text{end+1} = [''];

text{end+1} = [char(9), 'logic fifo_sel;'];
text{end+1} = [char(9), 'always@(posedge clk_bus) begin'];
text{end+1} = [char(9), char(9), 'if (~rst_bus) begin'];
text{end+1} = [char(9), char(9), char(9), 'fifo_sel <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else if ((r_addr_fifo_full_almost || r_addr_fifo_full) && r_req_en && fifo_sel == 0 && p_id_fifo_empty_2) begin'];
text{end+1} = [char(9), char(9), char(9), 'fifo_sel = ~fifo_sel;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else if ((r_addr_fifo_full_almost || r_addr_fifo_full) && r_req_en && fifo_sel == 1 && p_id_fifo_empty_1) begin'];
text{end+1} = [char(9), char(9), char(9), 'fifo_sel = ~fifo_sel;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic r_addr_fifo_full;'];
text{end+1} = [char(9), 'assign r_addr_fifo_full = (~fifo_sel)? r_addr_fifo_full_1: r_addr_fifo_full_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic r_addr_fifo_empty;'];
text{end+1} = [char(9), 'assign r_addr_fifo_empty = (fifo_sel)? r_addr_fifo_empty_1: r_addr_fifo_empty_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic r_addr_fifo_full_almost;'];
text{end+1} = [char(9), 'assign r_addr_fifo_full_almost = (~fifo_sel)? r_addr_fifo_full_almost_1: r_addr_fifo_full_almost_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'assign pc2ibc_addr = (~fifo_sel)? pc2ibc_addr_1: pc2ibc_addr_2;'];
text{end+1} = [''];

text{end+1} = [char(9), '// r_addr_fifo_1'];
text{end+1} = [char(9), 'logic r_addr_fifo_full_1;'];
text{end+1} = [char(9), 'logic r_addr_fifo_empty_1;'];
text{end+1} = [char(9), 'logic r_addr_fifo_full_almost_1;'];
text{end+1} = [char(9), 'logic ibc2mem_addr_en_1;'];
text{end+1} = [char(9), 'logic r_req_en_1;'];
text{end+1} = [char(9), 'logic [rAddrWidth-1:0] ibc2mem_addr_1;'];
text{end+1} = [char(9), 'logic [rAddrWidth-1:0] pc2ibc_addr_1;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign r_req_en_1 = (~fifo_sel)? r_req: 0;'];
text{end+1} = [char(9), 'assign ibc2mem_addr_en_1 = (fifo_sel)? mem2ibc_en: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(rAddrWidth), .ASIZE(FIFO_ASIZE)) r_addr_fifo_1(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(r_req_en_1), ', ...
                       '.rinc(ibc2mem_addr_en_1), ', ...
                       '.wfull(r_addr_fifo_full_1), ', ...
                       '.rempty(r_addr_fifo_empty_1), ', ...
                       '.wfull_almost(r_addr_fifo_full_almost_1), ', ...
                       '.rdata(ibc2mem_addr_1), ', ...
                       '.wdata(pc2ibc_addr_1)', ...
                       ');'];
text{end+1} = [''];
 
text{end+1} = [char(9), '// r_addr_fifo_2'];                  
text{end+1} = [char(9), 'logic r_addr_fifo_full_2;'];
text{end+1} = [char(9), 'logic r_addr_fifo_empty_2;'];
text{end+1} = [char(9), 'logic r_addr_fifo_full_almost_2;'];
text{end+1} = [char(9), 'logic ibc2mem_addr_en_2;'];
text{end+1} = [char(9), 'logic r_req_en_2;'];
text{end+1} = [char(9), 'logic [rAddrWidth-1:0] ibc2mem_addr_2;'];
text{end+1} = [char(9), 'logic [rAddrWidth-1:0] pc2ibc_addr_2;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign r_req_en_2 = (fifo_sel)? r_req: 0;'];
text{end+1} = [char(9), 'assign ibc2mem_addr_en_2 = (~fifo_sel)? mem2ibc_en: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(rAddrWidth), .ASIZE(FIFO_ASIZE)) r_addr_fifo_2(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(r_req_en_2), ', ...
                       '.rinc(ibc2mem_addr_en_2), ', ...
                       '.wfull(r_addr_fifo_full_2), ', ...
                       '.rempty(r_addr_fifo_empty_2), ', ...
                       '.wfull_almost(r_addr_fifo_full_almost_2), ', ...
                       '.rdata(ibc2mem_addr_2), ', ...
                       '.wdata(pc2ibc_addr_2)', ...
                       ');'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic p_id_fifo_full;'];
text{end+1} = [char(9), 'assign p_id_fifo_full = (~fifo_sel)? p_id_fifo_full_1: p_id_fifo_full_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic p_id_fifo_empty;'];
text{end+1} = [char(9), 'assign p_id_fifo_empty = (~fifo_sel)? p_id_fifo_empty_1: p_id_fifo_empty_2;'];
text{end+1} = [''];
text{end+1} = [char(9), 'logic p_id_fifo_full_almost;'];
text{end+1} = [char(9), 'assign p_id_fifo_full_almost = (~fifo_sel)? p_id_fifo_full_almost_1: p_id_fifo_full_almost_2;'];
text{end+1} = [''];
% text{end+1} = [char(9), 'logic ibc2mem_p_id_en;'];
% text{end+1} = [char(9), 'assign ibc2mem_p_id_en = (fifo_sel)? ibc2mem_p_id_en_1: ibc2mem_p_id_en_2;'];
% text{end+1} = [''];
% text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] ibc2mem_p_id;'];
% text{end+1} = [char(9), 'assign ibc2mem_p_id = (fifo_sel)? ibc2mem_p_id_1: ibc2mem_p_id_2;'];
% text{end+1} = [''];
text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] ibc2pc_p_id;'];
text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] pc2ibc_p_id;'];
text{end+1} = [char(9), 'assign pc2ibc_p_id = p_id;'];
text{end+1} = [''];


text{end+1} = [char(9), '// p_id_fifo_1'];                   
text{end+1} = [char(9), 'logic p_id_fifo_full_1;'];
text{end+1} = [char(9), 'logic p_id_fifo_empty_1;'];
text{end+1} = [char(9), 'logic p_id_fifo_full_almost_1;'];
text{end+1} = [char(9), 'logic mem2ibc_data_en_1;'];
text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] ibc2pc_p_id_1;'];
text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] pc2ibc_p_id_1;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign pc2ibc_p_id_1 = (~fifo_sel)? pc2ibc_p_id: 0;'];
text{end+1} = [char(9), 'assign mem2ibc_data_en_1 = (~fifo_sel)? mem2ibc_data_en: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(rReqWidth-rAddrWidth), .ASIZE(FIFO_ASIZE)) p_id_fifo_1(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(r_req_en_1), ', ...
                       '.rinc(mem2ibc_data_en_1), ', ...
                       '.wfull(p_id_fifo_full_1), ', ...
                       '.rempty(p_id_fifo_empty_1), ', ...
                       '.wfull_almost(p_id_fifo_full_almost_1), ', ...
                       '.rdata(ibc2pc_p_id_1), ', ...
                       '.wdata(pc2ibc_p_id_1)', ...
                       ');'];
text{end+1} = [''];

text{end+1} = [char(9), '// p_id_fifo_2'];   
text{end+1} = [char(9), 'logic p_id_fifo_full_2;'];
text{end+1} = [char(9), 'logic p_id_fifo_empty_2;'];
text{end+1} = [char(9), 'logic p_id_fifo_full_almost_2;'];
text{end+1} = [char(9), 'logic mem2ibc_data_en_2;'];
text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] ibc2pc_p_id_2;'];
text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] pc2ibc_p_id_2;'];
text{end+1} = [''];

text{end+1} = [char(9), 'assign pc2ibc_p_id_2 = (fifo_sel)? pc2ibc_p_id: 0;'];
text{end+1} = [char(9), 'assign mem2ibc_data_en_2 = (fifo_sel)? mem2ibc_data_en: 0;'];
text{end+1} = [''];

text{end+1} = [char(9), 'FIFO # (.DSIZE(rReqWidth-rAddrWidth), .ASIZE(FIFO_ASIZE)) p_id_fifo_2(', ...
                       '.wclk(clk_bus), .rclk(clk_bus), .wrst_n(rst_bus), .rrst_n(rst_bus), ', ...
                       '.winc(r_req_en_2), ', ...
                       '.rinc(mem2ibc_data_en_2), ', ...
                       '.wfull(p_id_fifo_full_2), ', ...
                       '.rempty(p_id_fifo_empty_2), ', ...
                       '.wfull_almost(p_id_fifo_full_almost_2), ', ...
                       '.rdata(ibc2pc_p_id_2), ', ...
                       '.wdata(pc2ibc_p_id_2)', ...
                       ');'];
text{end+1} = [''];

text{end+1} = [char(9), 'logic [rReqWidth-rAddrWidth-1:0] tk_count;'];
text{end+1} = [char(9), 'always@(posedge clk_bus) begin'];
text{end+1} = [char(9), char(9), 'if (~rst_bus) begin'];
text{end+1} = [char(9), char(9), char(9), 'tk_count <= 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), char(9), 'else if (~p_id_fifo_full_almost) begin'];
text{end+1} = [char(9), char(9), char(9), 'tk_count <= (tk_count < nPorts -1)? tk_count + 1 : 0;'];
text{end+1} = [char(9), char(9), 'end'];
text{end+1} = [char(9), 'end'];
text{end+1} = [''];

for i = 0: nPorts-1
    text{end+1} = [char(9), 'assign ibc2pc_data_en_', num2str(i), ' = (ibc2pc_p_id == ', num2str(i-1),')? mem2ibc_data_en: 0;'];
    text{end+1} = [''];
end

text{end+1} = [char(9), 'assign ibc2pc_data = mem2ibc_data;'];
text{end+1} = [''];

for i = 0: nPorts-1
    text{end+1} = [char(9), 'assign tk_out_', num2str(i), ' = (tk_count == ', num2str(i-1),' && ~r_addr_fifo_full_almost && ~r_addr_fifo_full)? 1: 0;'];
    text{end+1} = [''];
end

text{end+1} = ['endmodule'];

fid = fopen(name, 'w+');
for i = 1:length(text)
    fprintf(fid, '%s\n', text{i});
end
fclose(fid);
end