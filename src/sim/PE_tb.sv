`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2017 02:19:03 PM
// Design Name: 
// Module Name: PE_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PE_tb();
    parameter WIDTH = 16;
    parameter MAX_nPERIOD = 8;
    parameter MAX_nLMAC = 3*512*8;
    parameter MAX_nSHFT = 192;
    parameter CLK_PERIOD = 10;
    
    parameter nPeriod = 2;
    parameter nLMAC = 8;
    parameter nSHFT = 3;
    
    localparam CONF_REG_LEN = $clog2(MAX_nPERIOD) + $clog2(MAX_nLMAC) + $clog2(MAX_nSHFT);
    localparam MAC_CNT_WIDTH = (MAX_nLMAC > MAX_nSHFT)? MAX_nLMAC:MAX_nSHFT;
    localparam M_WIDTH = WIDTH*2;
    localparam A_WIDTH = M_WIDTH+1;
    localparam MAX_TIC = CONF_REG_LEN + nLMAC + nSHFT + 30;
    
    // inputs
    logic clk, rst, start, iconfig, config_en, in_en;
    logic [WIDTH-1:0] weight, feature;
    logic [A_WIDTH-1:0] ipsum;
    // outputs
    logic [A_WIDTH-1:0] opsum;
    logic out_en;
    
    reg [CONF_REG_LEN-1:0] configuration;
    reg [$clog2(MAX_nPERIOD)-1:0] vPeriod;
    reg [$clog2(MAX_nLMAC)-1:0] vLMAC;
    reg [$clog2(MAX_nSHFT)-1:0] vSHFT;
    reg [$clog2(CONF_REG_LEN)-1:0] config_count;
    
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        proc_count = 0;
        config_en = 0;
        in_en = 0;
        weight = 1;
        feature = 1;
        ipsum = 2;
        vPeriod = nPeriod;
        vLMAC = nLMAC;
        vSHFT = nSHFT;
        config_count = 0;
        configuration = {vPeriod, vLMAC, vSHFT};     
    end
    
    // clk
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // proc_count
    logic [31:0] proc_count;
    always@(posedge clk) begin
        if (proc_count < MAX_TIC-1) begin
            proc_count <= proc_count + 1;
        end
    end
    
    // rst
    always@(proc_count) begin
        if (proc_count >= 5 && proc_count <=10) begin
            rst <= 0;
        end
        else begin
            rst <= 1;
        end
    end
    
    // config_en
    always@(proc_count) begin
        if (proc_count > 10 && proc_count <= 10 + CONF_REG_LEN) begin
            config_en <= 1;
        end
        else begin
            config_en <= 0;
        end
    end
    
    // config_count
    always@(posedge clk) begin
        if (proc_count >=10 && proc_count < 10 + CONF_REG_LEN && config_count < CONF_REG_LEN-1) begin
            config_count <= config_count + 1;
        end
        else begin
            config_count <= 0;
        end
    end
    
    // iconfig
    always@(posedge clk) begin
        iconfig <= configuration[config_count];
    end
    
    // start
    always@(proc_count) begin
        if (proc_count > 10 + CONF_REG_LEN && proc_count <= 10 + CONF_REG_LEN + 1) begin
            start <= 1;
        end
        else begin
            start <= 0;
        end
    end
    
    // in_en
    always@(proc_count) begin
        if (proc_count > 10 + CONF_REG_LEN + 5 && proc_count <= 10 + CONF_REG_LEN + 5 + nLMAC) begin
            in_en <= 1;
        end
        else if (proc_count > 10 + CONF_REG_LEN + 5 +1 + nLMAC + nSHFT && proc_count <= 10 + CONF_REG_LEN + 5 +1 + 2*nLMAC + nSHFT) begin
            in_en <= 1;
        end
        else begin
            in_en <= 0;
        end
    end
    
    // PE
    PE #(.WIDTH(WIDTH), .MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) 
    U (.clk(clk), .rst(rst), .start(start), .iconfig(iconfig), .config_en(config_en), 
       .in_en(in_en), .weight(weight), .feature(feature), .ipsum(ipsum), .opsum(opsum), .out_en(out_en));

endmodule
