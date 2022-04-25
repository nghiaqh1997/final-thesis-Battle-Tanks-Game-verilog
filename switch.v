module switch(clk,first_screen_out,game_screen,reset,player_screen,no,yes,win_out1,win_out2,reset_plyrScrn,color_out,SW);
input clk,reset;
input [11:0]first_screen_out;
input [11:0]game_screen;
input [1:0]player_screen;
input no,yes;
input [11:0]win_out1;
input [11:0]win_out2;
output reg [11:0]color_out;
output reg reset_plyrScrn;
input [1:0]SW;
reg [1:0]screen_out;
initial
begin
	reset_plyrScrn=1'b1;
end
/*always@(posedge clk)
begin
	if(reset)
		color_out<=first_screen_out;
	
	else if(player_screen==2'b1)
		color_out<=win_out1;
	else if(player_screen==2'b10)
		color_out<=win_out2;
	else if(SW[1]) 
		color_out<=game_screen;
	else if (SW[0])
		color_out<=first_screen_out;
	
	
end*/
always@(*)
begin
	color_out<=game_screen;
end
endmodule
