
module slowclk(input wire fastclock,
						input wire reset,
						output reg slowclock
						);
						
	//1. Register/ or flip flops
	reg[27:0] count;
	wire[1:0] dinputs;
	parameter DIVIDER = 28'd250000;
	always @(posedge fastclock)
	begin
		
		if(reset || (count >= ((28'd250000)-1)))
		begin 
			count <= 28'd0; 
		end
		else 
		count <= count + 28'd1;
		
		slowclock <= (count<DIVIDER/2) ? 1'b1 : 1'b0;
	end
endmodule

	
