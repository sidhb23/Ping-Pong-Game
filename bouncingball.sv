`timescale 10ms/1ms
module testbouncingball ( ) ;
reg clock ;
reg reset;
reg [ 9 : 0 ] paddle_y;
initial begin
clock = 0 ;
paddle_y = 10'd300 ;
#5 reset = 1 ;
#15 reset = 0 ;
end
always #5 clock = ~clock ;
wire [ 9 : 0 ] ballx ;
wire [ 9 : 0 ] bally ;
bouncingball bball(clock,reset,paddle_y,ballx,bally );
endmodule 

module bouncingball(
	input slowclock, 
	input reset, 
	input  [9:0] paddle_y, //location of the paddle
	output reg[9:0] ballx, //location of ball in x
	output reg[9:0] bally,	//location of ball in y
	output reg[3:0] Score1,
	output reg[3:0] Score2
	 );
	 
	reg[1:0] velocity; 
	always @(posedge slowclock)
	begin
	
	if((Score1 == 9 || Score2 == 9 )||reset)
	begin
	ballx <= 10'd320;
	bally <= 10'd240;
	velocity <= 2'b00; // 00 = xy velocities 0+ 1-
	Score1 <= 3'd0;
	Score2 <= 3'd0;
	
		//
	
	end
	else  
		begin
		
		ballx = (velocity == 2'b00 || velocity == 2'b01)? ballx+1 : ballx-1; // checks if the ball is moving in x+, then changes the location
		bally = (velocity == 2'b00 || velocity == 2'b10)? bally+1 : bally-1;// checks if the ball is moving in y+, then changes the location
		
		//if(ballx == 30) velocity = 2'b00; // checks for ball location 1 pixel into the left paddle
		if(ballx == 640 && velocity == 2'b01) velocity = 2'b11;// checks if the ball hit the right wall
		else if(ballx == 640 && velocity == 2'b00) velocity = 2'b10;
		
		if(bally == 0 && velocity == 2'b01) velocity = 2'b00;	// checks if the ball hit the top of the screen and ball moving in +x
		else if(bally == 0 && velocity == 2'b11) velocity = 2'b10;
		if(bally == 460 && velocity == 2'b00) velocity = 2'b01;// checks if the ball hit the bottom of the screen and ball moving in +x
		else if(bally == 460 && velocity == 2'b10) velocity = 2'b11;

		if(ballx == 90 && bally >= paddle_y-20 && bally <=(paddle_y+120) && velocity == 2'b10) velocity = 2'b00;//checks if the ball hit the paddle's y location
		else if(ballx == 90 && bally >= paddle_y-20 && bally <=(paddle_y+120)&& velocity == 2'b11) velocity = 2'b01;
		
		if(ballx == 610 && bally >= bally - 60 && bally <= bally + 120 && velocity == 2'b00) velocity = 2'b10;
		if(ballx == 590 && bally >= bally - 60 && bally <= bally + 120 && velocity == 2'b01) velocity = 2'b11;
		
		if(ballx == 0)
		begin 
		Score2 = Score2 + 3'd1;
		ballx = 10'd320;
		bally = 10'd240;
		velocity = 2'b00;
		end
		if(ballx == 640)
		begin 
		Score1 = Score1 + 3'd1;
		ballx = 10'd320;
		bally = 10'd240;
		velocity = 2'b10;
		end
		
		end
	end
endmodule
	 
	 
