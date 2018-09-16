`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Liu Zichuan 
// 
// Create Date: 01/14/2018 10:36:13 AM
// Design Name: 
// Module Name: Arthas_v1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top level design 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Arthas_v1(
    // inputs
    clk,
    clk_mem,
    rst,
    uart_rx,
    // outputs
    ddr3_addr,
    ddr3_ba, 
    ddr3_cas_n,
    ddr3_ck_n,
    ddr3_ck_p,
    ddr3_cke,
    ddr3_ras_n,
    ddr3_reset_n,
    ddr3_we_n,
    init_calib_complete,
    ddr3_cs_n,
    uart_tx,
    ddr3_dm,
    ddr3_odt,
    // inout
    ddr3_dq,
    ddr3_dqs_n,
    ddr3_dqs_p
    );
    
    // UART interfance ports
    input uart_rx, clk, clk_mem, rst;
    output uart_tx;
    
    // Memory interface ports 
    output [13:0] ddr3_addr; output [2:0] ddr3_ba; output ddr3_cas_n; output [0:0] ddr3_ck_n; output [0:0] ddr3_ck_p;
    output [0:0] ddr3_cke; output ddr3_ras_n; output ddr3_reset_n; output ddr3_we_n; inout [7:0] ddr3_dq; 
    inout [0:0] ddr3_dqs_n; inout [0:0] ddr3_dqs_p; output init_calib_complete; output [0:0] ddr3_cs_n;
    output [0:0] ddr3_dm; output [0:0] ddr3_odt;
    
    // UART
    logic uart_s_axi_aclk, uart_s_axi_aresetn, uart_s_axi_awready, uart_s_axi_awvalid, uart_s_axi_wvalid;
    logic uart_s_axi_wready, uart_s_axi_bvalid, uart_s_axi_bready, uart_s_axi_arvalid, uart_s_axi_arready;
    logic uart_s_axi_rvalid, uart_s_axi_rready, uart_interrupt;
    logic [3 : 0] uart_s_axi_awaddr; logic [31 : 0] uart_s_axi_wdata; logic [3 : 0] uart_s_axi_wstrb; 
    logic [3 : 0] uart_s_axi_araddr; logic [31 : 0] uart_s_axi_rdata; logic [1 : 0] uart_s_axi_rresp;
    logic [1 : 0] uart_s_axi_bresp;
    
    axi_uartlite_0 uart_pc_fpga (
      .s_axi_aclk(uart_s_axi_aclk),        // input wire s_axi_aclk
      .s_axi_aresetn(uart_s_axi_aresetn),  // input wire s_axi_aresetn
      .interrupt(uart_interrupt),          // output wire interrupt
      .s_axi_awaddr(uart_s_axi_awaddr),    // input wire [3 : 0] s_axi_awaddr
      .s_axi_awvalid(uart_s_axi_awvalid),  // input wire s_axi_awvalid
      .s_axi_awready(uart_s_axi_awready),  // output wire s_axi_awready
      .s_axi_wdata(uart_s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
      .s_axi_wstrb(uart_s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
      .s_axi_wvalid(uart_s_axi_wvalid),    // input wire s_axi_wvalid
      .s_axi_wready(uart_s_axi_wready),    // output wire s_axi_wready
      .s_axi_bresp(uart_s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
      .s_axi_bvalid(uart_s_axi_bvalid),    // output wire s_axi_bvalid
      .s_axi_bready(uart_s_axi_bready),    // input wire s_axi_bready
      .s_axi_araddr(uart_s_axi_araddr),    // input wire [3 : 0] s_axi_araddr
      .s_axi_arvalid(uart_s_axi_arvalid),  // input wire s_axi_arvalid
      .s_axi_arready(uart_s_axi_arready),  // output wire s_axi_arready
      .s_axi_rdata(uart_s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
      .s_axi_rresp(uart_s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
      .s_axi_rvalid(uart_s_axi_rvalid),    // output wire s_axi_rvalid
      .s_axi_rready(uart_s_axi_rready),    // input wire s_axi_rready
      .rx(uart_rx),                        // input wire rx
      .tx(uart_tx)                         // output wire tx
    );
    
    
    
//    // Application interface ports
//    logic ddr3_app_ui_clk, ddr3_app_ui_clk_sync_rst, ddr3_app_mmcm_locked, ddr3_app_aresetn, ddr3_app_sr_req;
//    logic ddr3_app_ref_req, ddr3_app_zq_req, ddr3_app_sr_active, ddr3_app_ref_ack, ddr3_app_zq_ack;
    
//    // Slave Interface Write Address Ports
//    logic [3:0] ddr3_s_axi_awid; logic [26:0] ddr3_s_axi_awaddr; logic [7:0] ddr3_s_axi_awlen;
//    logic [2:0] ddr3_s_axi_awsize; logic [1:0] ddr3_s_axi_awburst; logic [0:0] ddr3_s_axi_awlock;
//    logic [3:0] ddr3_s_axi_awcache; logic [2:0] ddr3_s_axi_awprot; logic [3:0] ddr3_s_axi_awqos;
//    logic ddr3_s_axi_awvalid; logic ddr3_s_axi_awready;
    
//    // Slave Interface Write Data Ports
//    logic [63:0] ddr3_s_axi_wdata;  logic [7:0] ddr3_s_axi_wstrb;  logic ddr3_s_axi_wlast; 
//    logic ddr3_s_axi_wvalid;  logic ddr3_s_axi_wready;
    
//    // Slave Interface Write Response Ports
//    logic [3:0] ddr3_s_axi_bid; logic [1:0] ddr3_s_axi_bresp; logic ddr3_s_axi_bvalid; logic ddr3_s_axi_bready;
    
//    // Slave Interface Read Address Ports
//    logic [3:0] ddr3_s_axi_arid; logic [26:0] ddr3_s_axi_araddr; logic [7:0] ddr3_s_axi_arlen; logic [2:0] ddr3_s_axi_arsize; 
//    logic [1:0] ddr3_s_axi_arburst; logic ddr3_s_axi_arlock; logic [3:0] ddr3_s_axi_arcache; logic [2:0] ddr3_s_axi_arprot; 
//    logic [3:0] ddr3_s_axi_arqos; logic ddr3_s_axi_arvalid; logic ddr3_s_axi_arready;
    
//    // Slave Interface Read Data Ports
//    logic [3:0] ddr3_s_axi_rid; logic [63:0] ddr3_s_axi_rdata; logic [1:0] ddr3_s_axi_rresp; 
//    logic ddr3_s_axi_rlast; logic ddr3_s_axi_rvalid; logic ddr3_s_axi_rready;
    
//    // System Clock Ports
//    logic ddr3_sys_clk_p; logic ddr3_sys_clk_n;
    
//    // Reference Clock Ports
//    logic ddr3_clk_ref_p; logic ddr3_clk_ref_n; logic ddr3_sys_rst;
    
//    mig_7series_0 ddr3_fpga_interface (
//        // Memory interface ports
//        .ddr3_addr                      (ddr3_addr),            // output [13:0]     ddr3_addr
//        .ddr3_ba                        (ddr3_ba),              // output [2:0]      ddr3_ba
//        .ddr3_cas_n                     (ddr3_cas_n),           // output            ddr3_cas_n
//        .ddr3_ck_n                      (ddr3_ck_n),            // output [0:0]      ddr3_ck_n
//        .ddr3_ck_p                      (ddr3_ck_p),            // output [0:0]      ddr3_ck_p
//        .ddr3_cke                       (ddr3_cke),             // output [0:0]      ddr3_cke
//        .ddr3_ras_n                     (ddr3_ras_n),           // output            ddr3_ras_n
//        .ddr3_reset_n                   (ddr3_reset_n),         // output            ddr3_reset_n
//        .ddr3_we_n                      (ddr3_we_n),            // output            ddr3_we_n
//        .ddr3_dq                        (ddr3_dq),              // inout [7:0]       ddr3_dq
//        .ddr3_dqs_n                     (ddr3_dqs_n),           // inout [0:0]       ddr3_dqs_n
//        .ddr3_dqs_p                     (ddr3_dqs_p),           // inout [0:0]       ddr3_dqs_p
//        .init_calib_complete            (init_calib_complete),  // output            init_calib_complete
          
//        .ddr3_cs_n                      (ddr3_cs_n),            // output [0:0]      ddr3_cs_n
//        .ddr3_dm                        (ddr3_dm),              // output [0:0]      ddr3_dm
//        .ddr3_odt                       (ddr3_odt),             // output [0:0]      ddr3_odt
//        // Application interface ports
//        .ui_clk                         (ddr3_app_ui_clk),               // output            ui_clk
//        .ui_clk_sync_rst                (ddr3_app_ui_clk_sync_rst),      // output            ui_clk_sync_rst
//        .mmcm_locked                    (ddr3_app_mmcm_locked),          // output            mmcm_locked
//        .aresetn                        (ddr3_app_aresetn),              // input             aresetn
//        .app_sr_req                     (ddr3_app_sr_req),           // input             app_sr_req
//        .app_ref_req                    (ddr3_app_ref_req),          // input             app_ref_req
//        .app_zq_req                     (ddr3_app_zq_req),           // input             app_zq_req
//        .app_sr_active                  (ddr3_app_sr_active),        // output            app_sr_active
//        .app_ref_ack                    (ddr3_app_ref_ack),          // output            app_ref_ack
//        .app_zq_ack                     (ddr3_app_zq_ack),           // output            app_zq_ack
//        // Slave Interface Write Address Ports
//        .s_axi_awid                     (ddr3_s_axi_awid),           // input [3:0]       s_axi_awid
//        .s_axi_awaddr                   (ddr3_s_axi_awaddr),         // input [26:0]      s_axi_awaddr
//        .s_axi_awlen                    (ddr3_s_axi_awlen),          // input [7:0]       s_axi_awlen
//        .s_axi_awsize                   (ddr3_s_axi_awsize),         // input [2:0]       s_axi_awsize
//        .s_axi_awburst                  (ddr3_s_axi_awburst),        // input [1:0]       s_axi_awburst
//        .s_axi_awlock                   (ddr3_s_axi_awlock),         // input [0:0]       s_axi_awlock
//        .s_axi_awcache                  (ddr3_s_axi_awcache),        // input [3:0]       s_axi_awcache
//        .s_axi_awprot                   (ddr3_s_axi_awprot),         // input [2:0]       s_axi_awprot
//        .s_axi_awqos                    (ddr3_s_axi_awqos),          // input [3:0]       s_axi_awqos
//        .s_axi_awvalid                  (ddr3_s_axi_awvalid),        // input             s_axi_awvalid
//        .s_axi_awready                  (ddr3_s_axi_awready),        // output            s_axi_awready
//        // Slave Interface Write Data Ports
//        .s_axi_wdata                    (ddr3_s_axi_wdata),          // input [63:0]      s_axi_wdata
//        .s_axi_wstrb                    (ddr3_s_axi_wstrb),          // input [7:0]       s_axi_wstrb
//        .s_axi_wlast                    (ddr3_s_axi_wlast),          // input             s_axi_wlast
//        .s_axi_wvalid                   (ddr3_s_axi_wvalid),         // input             s_axi_wvalid
//        .s_axi_wready                   (ddr3_s_axi_wready),         // output            s_axi_wready
//        // Slave Interface Write Response Ports
//        .s_axi_bid                      (ddr3_s_axi_bid),            // output [3:0]      s_axi_bid
//        .s_axi_bresp                    (ddr3_s_axi_bresp),          // output [1:0]      s_axi_bresp
//        .s_axi_bvalid                   (ddr3_s_axi_bvalid),         // output            s_axi_bvalid
//        .s_axi_bready                   (ddr3_s_axi_bready),         // input             s_axi_bready
//        // Slave Interface Read Address Ports
//        .s_axi_arid                     (ddr3_s_axi_arid),           // input [3:0]       s_axi_arid
//        .s_axi_araddr                   (ddr3_s_axi_araddr),         // input [26:0]      s_axi_araddr
//        .s_axi_arlen                    (ddr3_s_axi_arlen),          // input [7:0]       s_axi_arlen
//        .s_axi_arsize                   (ddr3_s_axi_arsize),         // input [2:0]       s_axi_arsize
//        .s_axi_arburst                  (ddr3_s_axi_arburst),        // input [1:0]       s_axi_arburst
//        .s_axi_arlock                   (ddr3_s_axi_arlock),         // input [0:0]       s_axi_arlock
//        .s_axi_arcache                  (ddr3_s_axi_arcache),        // input [3:0]       s_axi_arcache
//        .s_axi_arprot                   (ddr3_s_axi_arprot),         // input [2:0]       s_axi_arprot
//        .s_axi_arqos                    (ddr3_s_axi_arqos),          // input [3:0]       s_axi_arqos
//        .s_axi_arvalid                  (ddr3_s_axi_arvalid),        // input             s_axi_arvalid
//        .s_axi_arready                  (ddr3_s_axi_arready),        // output            s_axi_arready
//        // Slave Interface Read Data Ports
//        .s_axi_rid                      (ddr3_s_axi_rid),            // output [3:0]      s_axi_rid
//        .s_axi_rdata                    (ddr3_s_axi_rdata),          // output [63:0]     s_axi_rdata
//        .s_axi_rresp                    (ddr3_s_axi_rresp),          // output [1:0]      s_axi_rresp
//        .s_axi_rlast                    (ddr3_s_axi_rlast),          // output            s_axi_rlast
//        .s_axi_rvalid                   (ddr3_s_axi_rvalid),         // output            s_axi_rvalid
//        .s_axi_rready                   (ddr3_s_axi_rready),         // input             s_axi_rready
//        // System Clock Ports
//        .sys_clk_p                      (ddr3_sys_clk_p),            // input             sys_clk_p
//        .sys_clk_n                      (ddr3_sys_clk_n),            // input             sys_clk_n
//        // Reference Clock Ports
//        .clk_ref_p                      (ddr3_clk_ref_p),            // input             clk_ref_p
//        .clk_ref_n                      (ddr3_clk_ref_n),            // input             clk_ref_n
//        .sys_rst                        (ddr3_sys_rst)               // input             sys_rst
//        );


endmodule
