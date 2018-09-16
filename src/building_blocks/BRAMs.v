`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2017 09:28:03 PM
// Design Name: 
// Module Name: BRAMs
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


module BRAMs(
    clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb
    );
    
    parameter nRRAMs = 52;
    
    input clka;
    input ena;
    input wea;
    input [8:0]addra;
    input [15:0]dina;
    output logic [15:0]douta;
    input clkb;
    input enb;
    input [0:0]web;
    input [8:0]addrb;
    input [15:0]dinb;
    output logic [15:0]doutb;
    
    logic [15:0] a[nRRAMs-1:0];
    logic [15:0] b[nRRAMs-1:0];
    
    genvar i;
    generate
        for (i = 0; i < nRRAMs; i = i+1) begin
            BRAM U (.clka(clka), .ena(ena), .wea(wea), .addra(addra), .dina(dina), .douta(a[i]), 
                    .clkb(clkb), .enb(enb), .web(web), .addrb(addrb), .dinb(dinb), .doutb(b[i]));
        end
    endgenerate
    
    integer idx;
    always @* begin
        douta = {15{1'b1}};
        doutb = {15{1'b1}};
        for (idx = 0; idx < nRRAMs; idx = idx+1) begin
            douta = douta & a[idx];
            doutb = doutb & b[idx];
        end
    end
    
endmodule
