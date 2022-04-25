module chuyendoi(in,out,clk,reset,first_screen_out,win_out1,win_out2,SW,player_screen,reset_screen);
input [11:0]in;
output reg [11:0]out;
input clk,reset;
input [11:0]first_screen_out,win_out1,win_out2;
input [1:0]SW;
input [1:0]player_screen;
output reset_screen;
reg [1:0]mode;
always@(*)begin

	if(reset)
		out=first_screen_out;
	else if (player_screen==2'b01)
		out=win_out1;
	else if (player_screen==2'b10)
		out=win_out2;
	else if (SW[1]) 
		out=in;
	else out = first_screen_out;
end
endmodule
