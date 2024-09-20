`timescale 1ns/1ps
module testslowclock();
  //$display("Hello world");
  reg fastclk;
  reg reset;
  wire slowclock;
  
  //New inital block
  initial
  begin
  reset <= 1;
  #20 reset <= ~reset;
  fastclk <= 0;
  end
  
  always
  begin
	 #10 fastclk <=~fastclk;

  end
  
  
  slowclock slwclk(fastclk, reset, slowclock);
endmodule