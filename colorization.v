module colorization(clk25,reset,disp_ena,first_screen_out,game_screen,game_screen2,player_screen,color_out,win_out1,win_out2,menu,play,play2,player_screen2,lose_out1,play_flag,play2_flag);
input clk25, reset, disp_ena;
input [11:0]first_screen_out,game_screen,win_out1,win_out2,game_screen2,lose_out1;
input [1:0]player_screen,player_screen2;
input menu,play,play2;
output reg [11:0] color_out;
reg [3:0]state1;
reg menu_flag;
output reg play_flag,play2_flag;
initial
	begin
	menu_flag=1'b1;
		play_flag=1'b0;
		play2_flag=1'b0;
	end
always@(posedge clk25)
begin
	if(reset)
		begin
		state1<=3'b001;
		menu_flag<=1'b0;
		play_flag<=1'b0;
		play2_flag<=1'b0;
		end
	else begin
		case(state1)
			3'b001:begin
					if(menu==1'b1)begin	
						menu_flag<=1'b1;
						play_flag<=1'b0;
						play2_flag<=1'b0;
						state1 <= 3'b011;
					end
					else begin menu_flag<=menu_flag;
								  play_flag<=play_flag;
								  play2_flag<=play2_flag;
								  state1<=3'b011;
					end
					end
			3'b011:begin
					if(play==1'b1)begin
						menu_flag<=1'b0;
						play_flag<=1'b1;
						play2_flag<=1'b0;
						state1<=3'b010;
					end
					else begin
						menu_flag<=menu_flag;
						play_flag<=play_flag;
						play2_flag<=play2_flag;
						state1<=3'b010;
					end
					end
			3'b010:begin
					if(play2==1'b1)begin
						menu_flag<=1'b0;
						play_flag<=1'b0;
						play2_flag<=1'b1;
						state1<=3'b110;
					end
					else begin
						menu_flag<=menu_flag;
						play_flag<=play_flag;
						play2_flag<=play2_flag;
						state1<=3'b110;
					end
					end
			3'b110:begin
					if(player_screen!=2'b00)begin
						menu_flag<=1'b0;
						play_flag<=1'b0;
						play2_flag<=1'b0;
						state1<=3'b111;
					end
					else begin
						menu_flag<=menu_flag;
						play_flag<=play_flag;
						play2_flag<=play2_flag;
						state1<=3'b111;
					end
					end
			3'b111:begin
					if(player_screen2!=2'b00)begin
						menu_flag<=1'b0;
						play_flag<=1'b0;
						play2_flag<=1'b0;
						state1<=3'b001;
					end
					else begin
						menu_flag<=menu_flag;
						play_flag<=play_flag;
						play2_flag<=play2_flag;
						state1<=3'b001;
					end
					end
						
endcase			
end						
						
end
always @(*)
begin
	if(reset)
	color_out = 0;
	else
	if(disp_ena)begin
		if(menu_flag==1'b1) color_out=first_screen_out;
		else if (play_flag==1'b1) color_out=game_screen;
		else if (play2_flag==1'b1) color_out=game_screen2;
		else if(player_screen==2'b01) color_out=win_out2;
		else if( player_screen==2'b10) color_out=win_out1;
		else if(player_screen2==2'd2) color_out=lose_out1;
		else if(player_screen2==2'd3) color_out=win_out1;
		
		
		
		else color_out=first_screen_out;
		end
	else
	color_out <= 0;
end

endmodule
