`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 01/17/2018 12:17:29 AM
// Design Name: 
// Module Name: PCv2
// Project Name: Arthas
// Target Devices: 
// Tool Versions: 
// Description: Port controller for output data.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PCv2(
    // inputs
    clk_bus,
    clk_array,
    rst_bus,
    rst_array,
    data_arr2pc,
    data_arr2pc_en,
    start,
    config_bits,
    tk_en,
    //outputs
    wr_req_out,
    wr_req_en
    );
    
    parameter WIDTH_ARR = 16;
    parameter WIDTH_BUS = 64;
    parameter WIDTH_MASK = 8;
    parameter P_ID = 0;
    parameter nCols = 4;
    parameter nRows = 3;
    parameter MAX_nPERIOD = 16;
    parameter MAX_nCHN = 2048;

    localparam WIDTH_P_ID = 6;
    localparam WIDTH_MEM_ADDR = 28;
    localparam WIDTH_REQ = WIDTH_P_ID + WIDTH_MEM_ADDR + WIDTH_MASK + WIDTH_BUS;
    localparam WIDTH_CONFIGBITS = WIDTH_MEM_ADDR + WIDTH_MEM_ADDR + WIDTH_MEM_ADDR + $clog2(MAX_nPERIOD) + $clog2(MAX_nCHN);  
    localparam S0 = 0; localparam S1 = 1;   
    
    input clk_bus, clk_array, rst_bus, rst_array, tk_en, data_arr2pc_en, start;
    input [WIDTH_CONFIGBITS-1:0] config_bits;
    input [WIDTH_ARR-1:0] data_arr2pc;
    
    output [WIDTH_REQ-1:0] wr_req_out;
    output wr_req_en;
    
    
    // s2p_reg
    reg [WIDTH_BUS-1:0] s2p_reg[0:nCols-1];
    always@(posedge clk_array) begin
        for (integer i = 0; i < nCols; i = i+1) begin
            if (~rst_array || start) begin
                s2p_reg[i] <= 0;
            end
            else if (data_arr2pc_en && col_sel_count == i) begin
                s2p_reg[i] <= {s2p_reg[i][WIDTH_BUS-WIDTH_ARR-1:0], data_arr2pc};
            end
        end
    end 
        
    // col_sel_count
    reg [$clog2(nCols)-1:0] col_sel_count;
    always@(posedge clk_array) begin
        if (~rst_array || start) begin
            col_sel_count <= 0;
        end
        else if (data_arr2pc_en) begin
            col_sel_count <= (col_sel_count < nCols-1)? col_sel_count + 1: 0;
        end
    end
    
    // s2p_count 
    reg [$clog2(WIDTH_BUS/WIDTH_ARR)-1:0] s2p_count;
    always@(posedge clk_array) begin
        if (~rst_array || start) begin
            s2p_count <= 0;
        end
        else if (col_sel_count == nCols-1 && data_arr2pc_en) begin
            s2p_count <= (s2p_count < WIDTH_BUS/WIDTH_ARR-1)? s2p_count + 1: 0;
        end
    end 
    
    // req_fifo_we
    logic req_fifo_we;
    always@(posedge clk_array) begin
        if (~rst_array || start) begin
            req_fifo_we <= 0;
        end
        else  begin
            req_fifo_we <= (s2p_count == WIDTH_BUS/WIDTH_ARR-1 && data_arr2pc_en)? 1:0;
        end
    end
    
    // mem_w_mask
    logic [WIDTH_BUS-1:0] mem_w_mask;
    assign mem_w_mask = {WIDTH_BUS {1'b1}};
        
    // config_bits
    logic [WIDTH_MEM_ADDR-1:0] ADDR_BASE;
    logic [WIDTH_MEM_ADDR-1:0] ADDR_COL_STRIDE;
    logic [WIDTH_MEM_ADDR-1:0] ADDR_ROW_STRIDE;
    logic [WIDTH_MEM_ADDR-1:0] addr_chn_count;
    logic [WIDTH_MEM_ADDR-1:0] addr_row_count;
    logic [WIDTH_MEM_ADDR-1:0] addr_col_count;
    logic [WIDTH_MEM_ADDR-1:0] mem_w_addr;
    
    // ADDR_BASE
    assign ADDR_BASE = config_bits[WIDTH_CONFIGBITS-1:WIDTH_CONFIGBITS-WIDTH_MEM_ADDR];
    
    // ADDR_STRIDE
    assign ADDR_BLOCK_BASE_STRIDE = config_bits[WIDTH_CONFIGBITS-WIDTH_MEM_ADDR-1:WIDTH_CONFIGBITS-2*WIDTH_MEM_ADDR];
        
    // ADDR_OFFSET
    assign ADDR_ROW_STRIDE = config_bits[WIDTH_CONFIGBITS-2*WIDTH_MEM_ADDR-1:WIDTH_CONFIGBITS-3*WIDTH_MEM_ADDR];
    
    // nPeriods
    logic [$clog2(MAX_nPERIOD)-1:0] nPeriods;
    assign nPeriods = config_bits[WIDTH_CONFIGBITS-3*WIDTH_MEM_ADDR-1:WIDTH_CONFIGBITS-3*WIDTH_MEM_ADDR-$clog2(MAX_nPERIOD)];
    
    // nChns
    logic [$clog2(MAX_nCHN)-1:0] nChns;
    assign nChns = config_bits[$clog2(MAX_nCHN)-1:0]; 
    
    // mem_w_addr
    assign mem_w_addr = ADDR_BASE + addr_col_count * ADDR_COL_STRIDE + addr_row_count * ADDR_ROW_STRIDE + addr_chn_count;
    
    // addr_row_count
    always@(posedge clk_array) begin
        if (~rst_array || start) begin
            addr_row_count <= 0;
        end
        else if (req_fifo_we) begin
            addr_row_count <= (addr_row_count < nCols-1)? addr_row_count + 1 : 0;
        end
    end
    
    // addr_chn_count
    always@(posedge clk_array) begin
        if (~rst_array || start) begin
            addr_chn_count <= 0;
        end
        else if (req_fifo_we && addr_row_count == nCols-1) begin
            addr_chn_count <= (addr_chn_count < nChns-1)? addr_chn_count + 1 : 0;
        end
    end
    
    // addr_col_count
    always@(posedge clk_array) begin
        if (~rst_array || start) begin
            addr_col_count <= 0;
        end
        else if (req_fifo_we && addr_row_count == nCols-1 && addr_chn_count == nChns-1) begin
            addr_col_count <= (addr_col_count < nPeriods-1)? addr_col_count + 1 : 0;
        end
    end
    
    // req_fifo_wdata
    logic [WIDTH_REQ-1:0] req_fifo_wdata;
    assign req_fifo_wdata = {P_ID, mem_w_addr, mem_w_mask, mem_w_addr, s2p_reg[col_sel_count]};
    
    // wr_req_out
    assign wr_req_out = req_fifo_rdata;
    
    
    // wr_req_en
    assign wr_req_en = tk_en & (~req_fifo_empty);
    
    logic [WIDTH_REQ-1:0] req_fifo_rdata;
    logic req_fifo_full, req_fifo_empty, req_fifo_full_almost, req_fifo_re;
    FIFO # (.DSIZE(WIDTH_REQ), .ASIZE(2)) rd_req_fifo (.rdata(req_fifo_rdata), .wfull(req_fifo_full), .rempty(req_fifo_empty),
                                                       .wfull_almost(req_fifo_full_almost), .wdata(req_fifo_wdata), 
                                                       .winc(req_fifo_we), .wclk(clk_array), .wrst_n(rst_array), 
                                                       .rinc(req_fifo_re), .rclk(clk_bus), .rrst_n(rst_bus));

endmodule
