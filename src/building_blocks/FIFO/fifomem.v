module fifomem #(parameter  DATASIZE = 12,  // Memory data word width
                 parameter  ADDRSIZE = 3)  // Number of mem address bits
  (output  [DATASIZE-1:0]  rdata,
   input   [DATASIZE-1:0]  wdata,
   input   [ADDRSIZE-1:0]  waddr, raddr,
   input                   wclken, wfull, wclk);
   
    // RTL Verilog memory model
    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];
    
    assign rdata = mem[raddr];
    
    always @(posedge wclk)
      if (wclken && !wfull) mem[waddr] <= wdata;

endmodule
