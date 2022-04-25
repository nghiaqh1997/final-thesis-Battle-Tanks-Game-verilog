module automove2(clk,reset,player,x_tank1,y_tank1,x_tank2,y_tank2,green_bullet_orient,greentank_orient,upgreen,downgreen,rightgreen,leftgreen,green_bullet_act,music2);
input clk,reset;
input green_bullet_act;
output reg [4:0]player;
input [9:0]x_tank1,x_tank2;
input [8:0]y_tank1,y_tank2;
output reg [1:0] green_bullet_orient,greentank_orient;
input upgreen,downgreen,rightgreen,leftgreen;
input music2;
assign  ICON_UP     = 2'b00;                
assign  ICON_DOWN   = 2'b01;
assign  ICON_LEFT   = 2'b10;
assign  ICON_RIGHT  = 2'b11;
wire [1:0]ICON_UP,ICON_RIGHT,ICON_LEFT,ICON_DOWN;
parameter integer ready=0,GO_UP=1,GO_DOWN=2,GO_LEFT=3,GO_RIGHT=4,
								  GO_UP1=11,GO_DOWN1=21,GO_LEFT1=31,GO_RIGHT1=41,
								  GO_UP2=12,GO_DOWN2=22,GO_LEFT2=32,GO_RIGHT2=42,
								  GO_UP3=13,GO_DOWN3=23,GO_LEFT3=33,GO_RIGHT3=43,
								  GO_UP4=14,GO_DOWN4=24,GO_LEFT4=34,GO_RIGHT4=44,
								  GO_UP5=15,GO_DOWN5=25,GO_LEFT5=35,GO_RIGHT5=45,
								  UP_TO_ENEMY=46,LEFT_TO_ENEMY=47,RIGHT_TO_ENEMY=48,DOWN_TO_ENEMY=49;
reg [6:0]state;
parameter integer MOVE_CNT=30000000;
reg [27:0]move_count;
 reg move_change;
always@(posedge clk)begin
	if(reset)begin
		move_change<=1'b0;
		move_count<=1'b0;
		end
	else if(move_count==MOVE_CNT)begin
		move_change<=1'b1;
		move_count<=1'b0;
		end
	else begin 
		move_count<=move_count+1'd1;
		move_change<=1'b0;
	end
	
end
wire [3:0] DOWN,RIGHT,UP,LEFT,FIRE;
assign  DOWN    = 4'b0001;                 
assign  RIGHT   = 4'b0010;
assign  UP      = 4'b0100;
assign  LEFT    = 4'b1000;

always@(posedge clk)begin
	if(reset)
		state<=ready;
	
		else if (music2) begin
			case(state)
				ready:state<=GO_UP;
				GO_UP:begin
							if(move_change==1'b0)
								player[3:0]<=UP;
							else if (upgreen)
								state<=GO_RIGHT;
						end
				GO_RIGHT:begin
							if(move_change==1'b0)
								player[3:0]<=RIGHT;
							else if (rightgreen)
								state<=GO_LEFT;
						end
				GO_LEFT:begin
							if(move_change==1'b0)
								player[3:0]<=LEFT;
							else if (leftgreen)
								state<=GO_DOWN;
						  end
				GO_DOWN:begin
							if(move_change==1'b0)
								player[3:0]<=DOWN;
							else if (downgreen)
								state<=GO_UP1;
						  end
				GO_UP1:begin
							if(move_change==1'b0)
								player[3:0]<=UP;
							else if (upgreen)
								state<=GO_LEFT1;
						end
				GO_LEFT1:begin
							if(move_change==1'b0)
								player[3:0]<=LEFT;
							else if (leftgreen)
								state<=GO_RIGHT1;
						end
				GO_RIGHT1:begin
							if(move_change==1'b0)
								player[3:0]<=RIGHT;
							else if (rightgreen)
								state<=GO_DOWN1;
						end
				GO_DOWN1:begin
							if(move_change==1'b0)
								player[3:0]<=DOWN;
							else if (downgreen)
								state<=GO_UP2;
						end
				GO_UP2:begin
							if(move_change==1'b0)
								player[3:0]<=UP;
							else if (upgreen)
								state<=GO_DOWN2;
						  end
				GO_DOWN2:begin
							if(move_change==1'b0)
								player[3:0]<=DOWN;
							else if (downgreen)
								state<=GO_LEFT2;
						  end
				GO_LEFT2:begin
							if(move_change==1'b0)
								player[3:0]<=LEFT;
							else if (leftgreen)
								state<=GO_UP;
						  end
				default:state<=ready;
			endcase
		end
end
reg [27:0]fire_count;
parameter integer FIRE_CNT=12000000;
always@(posedge clk)begin
	if (reset)begin
		fire_count<=1'b0;
		player[4] <=1'b0;
		end
	else if (music2)begin
	 if (fire_count==FIRE_CNT)begin
		player[4]<=1'b1;
		fire_count<=1'b0;
		end
	else if (player[4]==1'b1)
		player[4]<=1'b0;
	else fire_count<=fire_count+1'd1;
	end
end
always@(posedge clk)begin
if (reset) greentank_orient <= ICON_UP;
    
    else if     (( player[4] == 1'd1)&&(green_bullet_act==1'b0))
        begin
            case (greentank_orient) 
                ICON_DOWN:    green_bullet_orient <= ICON_DOWN;    
               ICON_UP:        green_bullet_orient <= ICON_UP;
                ICON_LEFT:    green_bullet_orient <= ICON_LEFT;
                ICON_RIGHT:    green_bullet_orient <= ICON_RIGHT;
                default:green_bullet_orient <= green_bullet_orient;
            endcase
        end
    else
        begin
            case (player)
            DOWN: greentank_orient <= ICON_DOWN;
            RIGHT:  greentank_orient <= ICON_RIGHT;
            UP:     greentank_orient <= ICON_UP;
          LEFT:   greentank_orient <= ICON_LEFT;
            default: greentank_orient <= greentank_orient;
            endcase
       
        end
end

endmodule
