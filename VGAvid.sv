`include "./DE0_VGA.v"

module VGAvid(CLOCK_50, updown, reset,
                VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);

input	wire			CLOCK_50;
input wire [1:0]updown;
input wire reset;

output	wire	[3:0]		VGA_R;		//Output Red
output	wire	[3:0]		VGA_G;		//Output Greense
output	wire	[3:0]		VGA_B;		//Output Blue

output	wire	[0:0]		VGA_HS;			//Horizontal Sync
output	wire	[0:0]		VGA_VS;			//Vertical Sync

wire			[9:0]		X_pix;			//Location in X of the driver
wire			[9:0]		Y_pix;			//Location in Y of the driver

wire			[0:0]		H_visible;		//H_blank?
wire			[0:0]		V_visible;		//V_blank?

wire		[0:0]		pixel_clk;		//Pixel clock. Every clock a pixel is being drawn. 
wire			[9:0]		pixel_cnt;		//How many pixels have been output.

reg			[11:0]		pixel_color;	//12 Bits representing color of pixel, 4 bits for R, G, and B
										//4 bits for Blue are in most significant position, Red in least

														
//endgame score (Score1, Score2, reset);														
paddle P1(slowclock,~reset, updown[1:0], paddle_y);
bouncingball Ball1(slowclock, ~reset, paddle_y, ballx, bally, Score1, Score2);
slowclk test(CLOCK_50,~reset,slowclock);	


/*always @(posedge slowclock)
	if (Score1 == 9 || Score2 == 9 )
	begin
		ballx = 0;
		bally = 0;
		paddle_y = 180;
		P2_y_location = 180;
	end*/

								
									
// Draw player 1 paddle
	
	wire [9:0] P1_box_width=30;
	wire [9:0] P1_box_height=120;
	wire [9:0] P1_x_location=60;
	wire [9:0] P1_y_location=210;
	wire [9:0] paddle_y;
	reg P1_paddle;
	
//	paddle P1 (.slowclock(slowclock),.reset(BUTTON[2]),.updown(BUTTON[1:0]),.paddle_y(P1_y_location));
		
	make_box P1_paddle_draw (
	.X_pix(X_pix),
	.Y_pix(Y_pix),
	.box_width(P1_box_width),
	.box_height(P1_box_height),
	.x_location(P1_x_location),
	.y_location(paddle_y),
	.pixel_clk(pixel_clk),
	.box_location(P1_paddle)
	
);
	

// Draw player 2 paddle
	
	wire [9:0] P2_box_width=30;
	wire [9:0] P2_box_height=120;
	wire [9:0] P2_x_location=610;
	wire [9:0] P2_y_location;
	reg P2_paddle;
		always @(*)
		if(bally >50 && bally <410)
			begin
			P2_y_location = bally-50;
			end
		else if(bally<=50) P2_y_location = 0;
		else if(bally>=410)
			begin
			P2_y_location = 360;
			end 
			
	make_box P2_paddle_draw (
	.X_pix(X_pix),
	.Y_pix(Y_pix),
	.box_width(P2_box_width),
	.box_height(P2_box_height),
	.x_location(P2_x_location),
	.y_location(P2_y_location),
	.pixel_clk(pixel_clk),
	.box_location(P2_paddle)
	
);

// Draw the ball
	wire [9:0] Ball_box_width=20;
	wire [9:0] Ball_box_height=20;
	wire [9:0] ballx;
	wire [9:0] bally;
	reg Ball;
	


	
	make_box Ball_draw(
	.X_pix(X_pix),
	.Y_pix(Y_pix),
	.box_width(Ball_box_width),
	.box_height(Ball_box_height),
	.x_location(ballx),
	.y_location(bally),
	.pixel_clk(pixel_clk),
	.box_location(Ball)
);
//if(Score2 == 3'd9 || Score1 == 3'd9) reset = 1;
//Draw scores
wire[3:0] Score1;
wire[3:0] Score2;
wire [11:0]  text_message_pixel_color;
wire [0:8*7-1] msg_7char = Score2;

display_message #( // score for right paddle

							.MSG_LENGTH(1), // length of message
                     .char_width(32), // char width in pixels
                     .char_height(32), // char height in pixels
                     .INIT_F("font_unscii_8x8_latin_uc.mem") // font file
                     ) disp_msg
(.X_pix(X_pix), // current X_pix being drawn
      .Y_pix(Y_pix), // current Y_pix being drawn
      .MSG(msg_7char-U-0016), // Message as 8-bit ascii value
      .msg_x(570), // X pos of left top corner of msg
      .msg_y(RESY / 2 - 2*BALLWIDTH), // Y pos of left top corner of msg
      .char_color(12'b0000_1111_0000), // text color
      .text_bg_color(12'b0000_0000_0000), // text background color
      .prev_layer_color(BGCOLOR), // color from previous layers 
      .pixel_color(text_message_pixel_color)); // output wire for pixel color

wire [11:0]  text_message_pixel_color1;
wire [0:8*7-1] msg_7char1 = Score1;	
	
display_message #( // score for left paddle

							.MSG_LENGTH(1), // length of message
                     .char_width(32), // char width in pixels
                     .char_height(32), // char height in pixels
                     .INIT_F("font_unscii_8x8_latin_uc.mem") // font file
                     ) disp_msg1
(.X_pix(X_pix), // current X_pix being drawn
      .Y_pix(Y_pix), // current Y_pix being drawn
      .MSG(msg_7char1-U-0016), // Message as 8-bit ascii value
      .msg_x(110), // X pos of left top corner of msg
      .msg_y(RESY / 2 - 2*BALLWIDTH), // Y pos of left top corner of msg
      .char_color(12'b0000_1111_0000), // text color
      .text_bg_color(12'b0000_0000_0000), // text background color
      .prev_layer_color(text_message_pixel_color), // color from previous layers 
      .pixel_color(text_message_pixel_color1)); // output wire for pixel color

		
always @(posedge pixel_clk)
	begin
		if(P1_paddle)pixel_color <= 12'b0000_1111_0000;
		else if(P2_paddle) pixel_color <=12'b0000_1111_0000;
		else if(Ball) pixel_color <= 12'b1101_1111_1001;
		else 
		pixel_color <= text_message_pixel_color1;
		end
	
	
	
		//Pass pins and current pixel values to display driver
		DE0_VGA VGA_Driver
		(
			.clk_50((CLOCK_50)),
			.pixel_color(pixel_color),
			.VGA_BUS_R(VGA_R), 
			.VGA_BUS_G(VGA_G), 
			.VGA_BUS_B(VGA_B), 
			.VGA_HS(VGA_HS), 
			.VGA_VS(VGA_VS), 
			.X_pix(X_pix), 
			.Y_pix(Y_pix), 
			.H_visible(H_visible),
			.V_visible(V_visible), 
			.pixel_clk(pixel_clk),
			.pixel_cnt(pixel_cnt)
		);

endmodule

module make_box(
	input [9:0] X_pix,
	input [9:0] Y_pix,
	input [9:0] box_width,
	input [9:0] box_height,
	input [9:0] x_location,
	input [9:0] y_location,
	input pixel_clk,
	output reg box_location
);
always @(posedge pixel_clk) 
    begin
        if ((X_pix > x_location) && (X_pix < (x_location + box_width)) && (Y_pix > y_location) && (Y_pix < (y_location + box_height))) box_location = 1;
        else box_location = 0;
    end
endmodule

	
