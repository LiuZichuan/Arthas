module FIFO #(parameter DSIZE = 16,
               parameter ASIZE = 5)
  (output reg [DSIZE-1:0] rdata,
   output             wfull,
   output             rempty,
   output             wfull_almost,
   input  [DSIZE-1:0] wdata,
   input              winc, wclk, wrst_n,
   input              rinc, rclk, rrst_n);

  wire   [ASIZE-1:0] waddr, raddr;
  wire   [ASIZE:0]   wptr, rptr, wq2_rptr, rq2_wptr;
  wire [DSIZE-1:0] rdata__;

  sync_r2w # (.ADDRSIZE(ASIZE)) sync_r2w (.wq2_rptr(wq2_rptr), .rptr(rptr),
                        .wclk(wclk), .wrst_n(wrst_n));

  sync_w2r # (.ADDRSIZE(ASIZE)) sync_w2r (.rq2_wptr(rq2_wptr), .wptr(wptr),
                        .rclk(rclk), .rrst_n(rrst_n));
                        
  fifomem #(DSIZE, ASIZE) fifomem
                          (.rdata(rdata__), .wdata(wdata),
                           .waddr(waddr), .raddr(raddr),
                           .wclken(winc), .wfull(wfull),
                           .wclk(wclk));
                           
  rptr_empty #(ASIZE)     rptr_empty
                          (.rempty(rempty),
                           .raddr(raddr),
                           .rptr(rptr), .rq2_wptr(rq2_wptr),
                           .rinc(rinc), .rclk(rclk),
                           .rrst_n(rrst_n));
                           
  wptr_full #(ASIZE)      wptr_full
                          (.wfull(wfull), .waddr(waddr),
                           .wptr(wptr), .wq2_rptr(wq2_rptr),
                           .winc(winc), .wclk(wclk),
                           .wrst_n(wrst_n), .wfull_almost(wfull_almost));
                           
  always@(posedge rclk or negedge rrst_n) begin
    if (~rrst_n)
        rdata <= 0;
    else
        rdata <= rdata__;
  end
                           
endmodule
  
