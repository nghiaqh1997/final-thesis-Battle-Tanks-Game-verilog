module autogreentank(player,clk,reset);
reg flag_enable;
output reg [4:0]player;
parameter FLAG_CNT=200000000;
input reset,clk;
parameter ready=1,UP=2,LEFT=3,RIGHT=4,DOWN=5,LEFT1=6,LEFT2=7,UP2=8,RIGHT1=9,DOWN1=10;
reg [3:0]state;
reg [27:0]flag_count;
assign  ICON_DOWN    = 5'b00001;                 
assign  ICON_RIGHT   = 5'b00010;
assign  ICON_UP      = 5'b00100;
assign  ICON_LEFT    = 5'b01000;
always@(*)begin
if (reset) begin
	flag_enable<=1'b0;
	flag_count<=1'b0;
	end
else if(flag_count==FLAG_CNT)begin
	flag_enable<=1'b1;
	flag_count<=1'b0;
	end
else flag_count<=flag_count+1'd1;
end
always@(posedge clk)begin
	if(reset)
		state<=ready;
	else begin
		case(state)
			ready:state<=UP;
			UP:begin
					if(flag_enable==1'b0)begin
						state<=UP;
						player<=ICON_UP;
					end
					else begin state<=LEFT; player[4]<=1'b1; end
					end
			LEFT:begin
					if(flag_enable==1'b0)begin
						state<=LEFT;
						player<=ICON_LEFT;
					end
					else begin state<=LEFT1; player[4]<=1'b1; end
					end
			LEFT1:begin
					if(flag_enable==1'b0)begin
						state<=LEFT1;
						player<=ICON_LEFT;
					end
					else begin state<=DOWN; player[4]<=1'b1; end
					end
			DOWN:begin
					if(flag_enable==1'b0)begin
						state<=LEFT1;
						player<=ICON_DOWN;
					end
					else begin state<=LEFT2; player[4]<=1'b1; end
					end
			LEFT2:begin
					if(flag_enable==1'b0)begin
						state<=LEFT2;
						player<=ICON_LEFT;
					end
					else begin state<=UP2; player[4]<=1'b1; end
					end
			UP2:begin
					if(flag_enable==1'b0)begin
						state<=UP2;
						player<=ICON_UP;
					end
					else begin state<=RIGHT; player[4]<=1'b1; end
					end
			RIGHT:begin
					if(flag_enable==1'b0)begin
						state<=RIGHT;
						player<=ICON_RIGHT;
					end
					else begin state<=RIGHT1; player[4]<=1'b1; end
					end
			RIGHT1:begin
					if(flag_enable==1'b0)begin
						state<=RIGHT1;
						player<=ICON_RIGHT;
					end
					else begin state<=DOWN1; player[4]<=1'b1; end
					end
			DOWN1:begin
					if(flag_enable==1'b0)begin
						state<=DOWN1;
						player<=ICON_DOWN;
					end
					else begin state<=UP; player[4]<=1'b1; end
					end
endcase
end
end

endmodule