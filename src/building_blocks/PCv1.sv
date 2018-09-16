`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan
// 
// Create Date: 01/17/2018 12:16:04 AM
// Design Name: Arthas
// Module Name: PCv1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Port controller for input data.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PCv1(
    // inputs
    clk_bus,
    clk_array,
    rst_bus,
    rst_array,
    start,
    tk_en,
    rd_data_mem2pc,
    rd_data_mem2pc_en,
    wrdy,
    config_bits,
    // outputs
    rd_req_en,
    rd_req_out,
    rd_data_pc2arr,
    rd_data_pc2arr_en
    );
    parameter WIDTH_ARR = 16;
    parameter WIDTH_BUS = 64;
    parameter P_ID = 0;
    
    localparam WIDTH_P_ID = 6;
    localparam WIDTH_MEM_ADDR = 28;
    localparam WIDTH_REQ = WIDTH_P_ID + WIDTH_MEM_ADDR;
    localparam WIDTH_CONFIGBITS = WIDTH_MEM_ADDR + WIDTH_MEM_ADDR;
    localparam S0 = 0; localparam S1 = 1; localparam S2 = 2; localparam Sp = 3;
    localparam P2S_FACT = WIDTH_BUS / WIDTH_ARR;
    localparam FIFO_ASIZE = $clog2(P2S_FACT);
    
    // inputs
    input clk_bus, clk_array, start, rst_bus, rst_array, tk_en, rd_data_mem2pc_en, wrdy;
    input [WIDTH_BUS-1:0] rd_data_mem2pc;
    input [WIDTH_CONFIGBITS-1:0] config_bits;
    
    // outputs
    output reg rd_req_en;
    output reg rd_data_pc2arr_en;
    output [WIDTH_REQ-1:0] rd_req_out;
    output [WIDTH_ARR-1:0] rd_data_pc2arr;
    
    // config_bits
    logic [WIDTH_MEM_ADDR-1:0] ADDR_BASE;
    logic [WIDTH_MEM_ADDR-1:0] ADDR_OFFSET;
    logic [WIDTH_MEM_ADDR-1:0] addr_offset_count;
    logic [WIDTH_MEM_ADDR-1:0] abs_addr;
    
    // ADDR_BASE
    assign ADDR_BASE = config_bits[WIDTH_CONFIGBITS-1:WIDTH_CONFIGBITS-WIDTH_MEM_ADDR];
    
    // ADDR_OFFSET
    assign ADDR_OFFSET = config_bits[WIDTH_MEM_ADDR-1:0];
    
    // abs_addr
    assign abs_addr = ADDR_BASE + addr_offset_count;
      
    // addr_offset_count
    always@(posedge clk_bus) begin
        if (~rst_bus) begin
            addr_offset_count <= 0;
        end
        else if (state == S1 && rd_data_mem2pc_en) begin
            addr_offset_count <= (addr_offset_count < ADDR_OFFSET)? (addr_offset_count + 1): 0;
        end
    end
    
    // rd_req_out
    logic [WIDTH_REQ-1:0] rd_req;
    assign rd_req = (rd_req_en_)? {P_ID, abs_addr}: 0;
    
    
    
    // rd_req_en_
    logic rd_req_en_;
    always@(posedge clk_bus) begin
        if (~rst_bus) begin
            rd_req_en_ <= 0;
        end
        else if ((state == Sp && wrdy && addr_offset_count <= ADDR_OFFSET)
               ||(state == S2 && p2s_count == P2S_FACT-1 && wrdy && addr_offset_count <= ADDR_OFFSET)) begin
            rd_req_en_ <= 1;
        end
        else begin
            rd_req_en_ <= 0;
        end
    end
    
    
    // p2s_count
    logic [$clog2(P2S_FACT)-1:0] p2s_count;
    always@(posedge clk_bus) begin
        if (~rst_bus) begin
            p2s_count <= 0;
        end
        else if (state == S2 && ~p2s_fifo_full) begin
            p2s_count <= (p2s_count < P2S_FACT-1)? (p2s_count + 1): 0;
        end
        else begin
            p2s_count <= 0;
        end
    end
    
    // p2s_data_reg 
    reg [WIDTH_BUS-1:0] p2s_data_reg;
    always@(posedge clk_bus) begin
        if (~rst_bus) begin
            p2s_data_reg <= 0;
        end
        else if (state == S1 && rd_data_mem2pc_en) begin
            p2s_data_reg <= rd_data_mem2pc;
        end
    end
       
    
    // state
    logic state;
    always@(posedge clk_bus) begin
        if (rst_bus) begin
            state <= S0;
        end
        else begin
            case (state)
                S0: begin
                        if (start) begin
                            state <= Sp;
                        end
                    end
                Sp: begin
                        if (wrdy && addr_offset_count <= ADDR_OFFSET) begin
                            state <= S1;
                        end
                     end
                S1: begin
                        if (rd_data_mem2pc_en) begin
                            state <= S2;
                        end 
                    end
                S2: begin
                        if (p2s_count == P2S_FACT-1) begin
                            state <= (addr_offset_count > ADDR_OFFSET)? S0: ((wrdy)? S2:Sp);
                        end
                    end
            endcase
        end
    end
    
    
    
    logic [WIDTH_REQ-1:0] req_fifo_rdata, req_fifo_wdata;
    logic req_fifo_full, req_fifo_empty, req_fifo_full_almost, req_fifo_we, req_fifo_re;
    
    assign req_fifo_wdata = rd_req;
    assign req_fifo_we = rd_req_en_;
    
    // req_fifo_re
    assign req_fifo_re = tk_en & ~req_fifo_empty;
    
    // rd_req_out
    assign rd_req_out = req_fifo_rdata;
    
    // rd_req_en
    always@(posedge clk_bus) rd_req_en <= req_fifo_re;
    
    FIFO # (.DSIZE(WIDTH_REQ), .ASIZE(2)) rd_req_fifo (.rdata(req_fifo_rdata), .wfull(req_fifo_full), .rempty(req_fifo_empty),
                                                       .wfull_almost(req_fifo_full_almost), .wdata(req_fifo_wdata), 
                                                       .winc(req_fifo_we), .wclk(clk_array), .wrst_n(rst_array), 
                                                       .rinc(req_fifo_re), .rclk(clk_bus), .rrst_n(rst_bus));
       
    logic [WIDTH_ARR-1:0] p2s_fifo_rdata, p2s_fifo_wdata;
    logic p2s_fifo_full, p2s_fifo_empty, p2s_fifo_full_almost, p2s_fifo_we, p2s_fifo_re;
    
    // p2s_fifo_we
    assign p2s_fifo_we = (state == S2 && ~p2s_fifo_full);
    
    // p2s_fifo_wdata
    assign p2s_fifo_wdata = (p2s_fifo_we)? p2s_data_reg[WIDTH_BUS-1-p2s_count*WIDTH_ARR -: WIDTH_ARR]: 0;
    
    // p2s_fifo_re
    assign p2s_fifo_re = wrdy && ~p2s_fifo_empty;
    
    // rd_data_pc2arr
    assign rd_data_pc2arr = p2s_fifo_rdata;
    
    //rd_data_pc2arr_en
    always@(posedge clk_bus) rd_data_pc2arr_en <=  p2s_fifo_re;
    
    FIFO # (.DSIZE(WIDTH_ARR), .ASIZE(FIFO_ASIZE)) p2s_data_fifo (.rdata(p2s_fifo_rdata), .wfull(p2s_fifo_full), .rempty(p2s_fifo_empty),
                                                                       .wfull_almost(p2s_fifo_full_almost), .wdata(p2s_fifo_wdata), 
                                                                       .winc(p2s_fifo_we), .wclk(clk_bus), .wrst_n(rst_bus), 
                                                                       .rinc(p2s_fifo_re), .rclk(clk_bus), .rrst_n(rst_bus));
    
endmodule
