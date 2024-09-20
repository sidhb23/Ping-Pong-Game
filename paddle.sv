/*`timescale 10ms/1ms
module testpaddle();
	reg clock;
	reg reset ;
	reg [1:0] updown ; // up down b u t t o n s
	reg [9:0] paddle_y ; // y c o o r d i n a t e o f p a d dl e y
	initial begin
		clock = 0 ;
		reset = 0 ;
		updown = 2'b00 ;
		#1 reset = 1 ;
		#2 reset = 0 ;
		#10 updown = 2'b01 ; // a f t e r d e l a y o f 100ms p r e s s up
		#10 updown = 2'b01 ;
		#10 updown = 2'b01 ;
	   #10 updown = 2'b01;	// a f t e r d e l a y o f 100ms p r e s s down
		#10 updown = 2'b00 ; // a f t e r d e l a y o f 100ms r e l e a s e b o t h
	end
	always #1 clock = ~clock ; // 20ms c l o c k t ime p e r i od
	paddle pdl (clock , reset , updown , paddle_y);
endmodule*/

module paddle(
	input slowclock,
	input reset,
	input [1:0] updown,
	output reg[9:0] paddle_y
);
	always @(posedge slowclock or posedge reset)
	begin //5	
		if (reset)
				begin //1
				paddle_y <= 10'd180;
				end//1
			else if ((updown == 2'b10) && (paddle_y!=10'd0))
				begin //2
				paddle_y <= paddle_y - 10'd2;
				end//2
			else if ((updown == 2'b01) && (paddle_y!=10'd360))
				begin//3
				paddle_y <= paddle_y + 10'd2;
				end//3
			else
				paddle_y <= paddle_y;
		end///5
endmodule
