module game_screen2 (first_screen_out,x,y,clk25,reset,player1,play,menu,mapselect,player_screen,music2);
input [9:0]x;
input [8:0]y;
input clk25,reset,menu,play;
input [1:0]mapselect;
output reg [11:0]first_screen_out;
wire [4:0]player2;
input  [4:0]player1;
wire  [4:0]player3;
reg [1:0]red_score;
initial
begin
	player_screen=1'b0;
end
input music2;
output reg [1:0]player_screen;
reg         [8:0]   y_tank1;
reg         [9:0]   x_tank1;
reg         [8:0]   y_tank2;
reg         [9:0]   x_tank2;
reg         [8:0]   y_tank3;
reg         [9:0]   x_tank3;

parameter integer   FLAG_CNT = 200000;  
reg	        [20:0]  flag_count;       
reg			        flag;               

reg         [20:0]  explosion1_cnt;
reg         [20:0]  explosion2_cnt;
//reg                 explosion1_enable;
//reg                 explosion2_enable;
reg                 explosion_flag;
reg					  green_explosion_flag;
reg  					  purple_explosion_flag;
reg         [20:0]  green_explosion_cnt;
reg         [20:0]  purple_explosion_cnt;
reg                 red_explosion_ack;
reg                 green_explosion_ack;
reg                 purple_explosion_ack;


parameter integer   BULLET_CNT = 50000; 
reg	        [19:0]  bullet_count;      
reg			        bullet_flag;         
reg         [1:0]	red_bullet_orient;     
reg         [8:0]	y_bullet1;             
reg         [9:0]	x_bullet1;             
reg                 red_bullet_act;      

wire         [1:0]	green_bullet_orient;
reg         [8:0]	y_bullet2;
reg         [9:0]	x_bullet2;
reg                 green_bullet_act;

wire         [1:0]	purple_bullet_orient;
reg         [8:0]	y_bullet3;
reg         [9:0]	x_bullet3;
reg                 purple_bullet_act;


reg         [6:0]   bullet_up_addr;
wire        [11:0]  bullet_up_dataOut;
reg         [6:0]   bullet_down_addr;
wire        [11:0]  bullet_down_dataOut;
reg         [6:0]   bullet_left_addr;
wire        [11:0]  bullet_left_dataOut;
reg         [6:0]   bullet_right_addr;
wire        [11:0]  bullet_right_dataOut;
reg         [6:0]   purplebullet_up_addr;
wire        [11:0]  purplebullet_up_dataOut;
reg         [6:0]   purplebullet_left_addr;
wire        [11:0]  purplebullet_left_dataOut;

reg         [1:0]   redtank_orient;
wire         [1:0]   greentank_orient;
wire         [1:0]   purpletank_orient;




reg         [9:0]   up_addr = 10'd0;
wire        [11:0]  up_dataOut;



reg         [9:0]   greenup_addr = 10'd0;
wire        [11:0]  greenup_dataOut;



reg         [9:0]   left_addr = 10'd0;
wire        [11:0]  left_dataOut;



reg         [9:0]   greenleft_addr = 10'd0;
wire        [11:0]  greenleft_dataOut;

reg         [9:0]   purpleup_addr = 10'd0;
wire        [11:0]  purpleup_dataOut;

reg         [9:0]   purpleleft_addr = 10'd0;
wire        [11:0]  purpleleft_dataOut;


wire        [4:0]   UP, DOWN, LEFT, RIGHT, CENTER;
wire        [1:0]   ICON_UP, ICON_DOWN, ICON_LEFT, ICON_RIGHT;


reg         [9:0]   explosion_addr = 10'd0;
wire        [11:0]  explosion_dataOut;


reg         [12:0]   green_explosion_addr = 10'd0;
wire        [11:0]  green_explosion_dataOut;

reg         [12:0]   purple_explosion_addr = 10'd0;
wire        [11:0]  purple_explosion_dataOut;

reduptank redup1(
  .clock(clk25),    
  .address(up_addr),  
  .q(up_dataOut)  
);


greentankup greenup(
  .clock(clk25),    
  .address(greenup_addr),  
  .q(greenup_dataOut)  
);


redtankleft redleft1(
  .clock(clk25),    
  .address(left_addr),  
  .q(left_dataOut)  
);


greentankleft greenleft(
  .clock(clk25),    
  .address(greenleft_addr),  
  .q(greenleft_dataOut)  
);
greentankup purpleup(
	.clock(clk25),
	.address(purpleup_addr),
	.q(purpleup_dataOut)
);
greentankleft purpleleft(
	.clock(clk25),
	.address(purpleleft_addr),
	.q(purpleleft_dataOut)
);
bulletup red_bullet_up(
  .clock(clk25),    
  .address( bullet_up_addr),  
  .q( bullet_up_dataOut)  
);

bulletup red_bullet_down(
  .clock(clk25),    
  .address( bullet_down_addr),  
  .q( bullet_down_dataOut)  
);

bulletleft red_bullet_left(
  .clock(clk25),    
  .address( bullet_left_addr),  
  .q( bullet_left_dataOut) 
);

bulletleft red_bullet_right(
  .clock(clk25),    
  .address( bullet_right_addr),  
  .q( bullet_right_dataOut)  
);
bulletup red_bullet_down1(
  .clock(clk25),    
  .address( purplebullet_up_addr),  
  .q( purplebullet_up_dataOut)  
);

bulletleft red_bullet_left3(
  .clock(clk25),    
  .address( purplebullet_left_addr),  
  .q( purplebullet_left_dataOut) 
);

/*
explosion explosion(
  .clock(clk25),    
  .address( explosion_addr),  
  .q( explosion_dataOut)  
);

explosion greenexplosion(
  .clock(clk25),    
  .address( green_explosion_addr),  
  .q( green_explosion_dataOut) 
);
explosion purpleexplosion(
  .clock(clk25),    
  .address( purple_explosion_addr),  
  .q( purple_explosion_dataOut) 
);
*/

assign  DOWN    = 5'b00001;                 
assign  RIGHT   = 5'b00010;
assign  UP      = 5'b00100;
assign  LEFT    = 5'b01000;


assign  ICON_UP     = 2'b00;                
assign  ICON_DOWN   = 2'b01;
assign  ICON_LEFT   = 2'b10;
assign  ICON_RIGHT  = 2'b11;

always @ (posedge clk25)
begin
if (reset) redtank_orient <= ICON_UP;

else if 	(red_bullet_act && player1[4] == 1'd1)
    begin
        case (redtank_orient) 
            ICON_DOWN:	red_bullet_orient <= ICON_DOWN;	
            ICON_UP:		red_bullet_orient <= ICON_UP;
            ICON_LEFT:	red_bullet_orient <= ICON_LEFT;
            ICON_RIGHT:	red_bullet_orient <= ICON_RIGHT;
            default:red_bullet_orient <= red_bullet_orient;
        endcase
    end
else
    begin
        case (player1)
        DOWN: redtank_orient <= ICON_DOWN;
        RIGHT:  redtank_orient <= ICON_RIGHT;
        UP:     redtank_orient <= ICON_UP;
        LEFT:   redtank_orient <= ICON_LEFT;
        default: redtank_orient <= redtank_orient;
        endcase
   
    end
    
//if (reset) greentank_orient <= ICON_UP;
    
    //else if     (green_bullet_act && player2[4] == 1'd1)
      //  begin
      //      case (greentank_orient) 
        //        ICON_DOWN:    green_bullet_orient <= ICON_DOWN;    
        //        ICON_UP:        green_bullet_orient <= ICON_UP;
         //       ICON_LEFT:    green_bullet_orient <= ICON_LEFT;
         //       ICON_RIGHT:    green_bullet_orient <= ICON_RIGHT;
         //       default:green_bullet_orient <= green_bullet_orient;
         //   endcase
      //  end
   // else
        //begin
        //    case (player2)
         //   DOWN: greentank_orient <= ICON_DOWN;
         //   RIGHT:  greentank_orient <= ICON_RIGHT;
         //   UP:     greentank_orient <= ICON_UP;
          //  LEFT:   greentank_orient <= ICON_LEFT;
         //   default: greentank_orient <= greentank_orient;
         //   endcase
       
        //end
//if (reset) purpletank_orient <= ICON_UP;
    
   // else if     (purple_bullet_act && player3[4] == 1'd1)
   //     begin
   //         case (purpletank_orient) 
   //             ICON_DOWN:    purple_bullet_orient <= ICON_DOWN;    
    //            ICON_UP:        purple_bullet_orient <= ICON_UP;
    //           ICON_LEFT:    purple_bullet_orient <= ICON_LEFT;
    //            ICON_RIGHT:    purple_bullet_orient <= ICON_RIGHT;
    //            default:purple_bullet_orient <= green_bullet_orient;
    //        endcase
    //    end
   // else
    //    begin
     //       case (player3)
     //       DOWN: purpletank_orient <= ICON_DOWN;
     //       RIGHT:  purpletank_orient <= ICON_RIGHT;
     //       UP:     purpletank_orient <= ICON_UP;
     //       LEFT:   purpletank_orient <= ICON_LEFT;
      //      default: purpletank_orient <= purpletank_orient;
      //      endcase
       
      //  end
end

parameter water=12500000;
reg [23:0]water_count;
reg water_flag;
always@(posedge clk25) begin
	if (reset)
		begin
			flag_count <= 0;
			flag <= 1'd0;
		end


	else if (flag_count == FLAG_CNT)
		begin
			flag <= 1'd1;
			flag_count <= 0;
		end
	else 
		begin
			flag_count <= flag_count + 1'b1;
			flag <= 1'd0;
		end

			
	if (reset)
		begin
			bullet_count <= 0;
			bullet_flag <= 1'd0;
		end
	else if (bullet_count == BULLET_CNT)
		begin
			bullet_flag <= 1'd1;
			bullet_count <= 0;
		end
	else 
		begin
			bullet_count <= bullet_count + 1'b1;
			bullet_flag <= 1'd0;
		end
	if (reset)
		begin
			water_count <= 0;
			water_flag <= 1'd0;
		end
	else if (water_count == water)
		begin
			water_flag <= ~water_flag;
			water_count <= 0;
		end
	else 
		begin
			water_count <= water_count + 1'b1;
		end
		
   
end
always @(posedge clk25)
begin
if(x == 799|| x == 39||x == 79||x == 119||x == 159||x == 199
||x == 239||x == 279||x == 319||x == 359||x == 399
||x == 439||x == 479||x == 519||x == 559||x == 599
||x == 639||x == 679||x == 759
)

addr_x <= 6'b0;
else
addr_x <= addr_x + 6'd1;

if( y == 0||y == 40||y == 80||y == 120||y == 160||y == 200||y == 240
||y == 280||y == 320||y == 360||y == 400||y == 440||y == 480
)
addr_y <= 6'd0;
else
if(x == 641)
addr_y <= addr_y + 6'd1;
else
addr_y <= addr_y;
end

wire [7:0]m_icon_data,m_icon_data1,m_icon_data2,m_icon_data3;
wire [4:0]column,row;
assign	row=y/40;
assign	column=x/40;
reg [5:0] addr_x = 0,addr_y = 0;//40
wire [10:0] addr;
assign  addr = addr_y*40 + addr_x;
mouse_icon icon0(.addr(addr),.m_icon_data(m_icon_data));
water1 w3(addr,m_icon_data1);
water2 w4(addr,m_icon_data2);
bush b2(addr,m_icon_data3);
wire [15:0]mapaddr;
assign mapaddr = row*16 + column;// 16x12
reg [2:0] mapdata;
reg data1,data2,data3,data;
reg [10:0]write,write1,write2,write3;
wire [2:0] q1,q2,q3;
wire [2:0]mapdata1,mapdata2,mapdata3;
reg we; 
reg [2:0]q;
reg [10:0]read1;
reg stop1;
reg stop2;
reg stop3;
map_enemy m1(data1,mapaddr,write1,we,clk25,clk25,mapdata1,read1,q1);
map1_enemy m2(data2,mapaddr,write2,we,clk25,clk25,mapdata2,read1,q2);
map2_enemy m3(data3,mapaddr,write3,we,clk25,clk25,mapdata3,read1,q3);
reg 					purple_stop;
reg               green_stop;
reg              red_stop;
always@(*)begin
	write1=11'd0;
	write2=11'd0;
	write3=11'd0;
	
case(mapselect)
	2'b00:begin mapdata=mapdata1; q=q1; data1=data; write1=write; end
	2'b01:begin mapdata=mapdata2; q=q2; data2=data; write2=write; end
	2'b11:begin mapdata=mapdata3; q=q3; data3=data; write3=write; end
	default: begin mapdata=mapdata1; q=q1; data1=data; write1=write; end
endcase
end
//////////////////////va cham/////////////////////////////////////////
reg [9:0]ax1,bx1,cx1,dx1,ay1,by1,cy1,dy1;
reg [9:0]goca1,gocb1,gocc1,gocd1;
reg [9:0]ax2,bx2,cx2,dx2,ay2,by2,cy2,dy2;
reg [9:0]goca2,gocb2,gocc2,gocd2;
reg [9:0]ax3,bx3,cx3,dx3,ay3,by3,cy3,dy3;
reg [9:0]goca3,gocb3,gocc3,gocd3;
reg [9:0]ax4,bx4,cx4,dx4,ay4,by4,cy4,dy4;
reg [9:0]goca4,gocb4,gocc4,gocd4;
reg [9:0]ax5,bx5,cx5,dx5,ay5,by5,cy5,dy5;
reg [9:0]goca5,gocb5,gocc5,gocd5;
reg [9:0]ax6,bx6,cx6,dx6,ay6,by6,cy6,dy6;
reg [9:0]goca6,gocb6,gocc6,gocd6;
always@(*)
begin
	ax1=x_tank1/40;
	ay1=y_tank1/40;
	bx1=(x_tank1+10'd31)/40;
	by1=y_tank1/40;
	cx1=(x_tank1+10'd31)/40;
	cy1=(y_tank1+10'd31)/40;
	dx1=x_tank1/40;
	dy1=(y_tank1+10'd31)/40;
	goca1=ay1*16+ax1;
	gocb1=by1*16+bx1;
	gocc1=cy1*16+cx1;
	gocd1=dy1*16+dx1;
	
	ax2=x_tank2/40;
	ay2=y_tank2/40;
	bx2=(x_tank2+10'd31)/40;
	by2=y_tank2/40;
	cx2=(x_tank2+10'd31)/40;
	cy2=(y_tank2+10'd31)/40;
	dx2=x_tank2/40;
	dy2=(y_tank2+10'd31)/40;
	goca2=ay2*16+ax2;
	gocb2=by2*16+bx2;
	gocc2=cy2*16+cx2;
	gocd2=dy2*16+dx2;
	
	ax5=x_tank3/40;
	ay5=y_tank3/40;
	bx5=(x_tank3+10'd31)/40;
	by5=y_tank3/40;
	cx5=(x_tank3+10'd31)/40;
	cy5=(y_tank3+10'd31)/40;
	dx5=x_tank3/40;
	dy5=(y_tank3+10'd31)/40;
	goca5=ay5*16+ax5;
	gocb5=by5*16+bx5;
	gocc5=cy5*16+cx5;
	gocd5=dy5*16+dx5;
	
	
	
	ax3=x_bullet1/40;
	ay3=y_bullet1/40;
	bx3=(x_bullet1+10'd14)/40;
	by3=y_bullet1/40;
	cx3=(x_bullet1+10'd14)/40;
	cy3=(y_bullet1+10'd14)/40;
	dx3=x_bullet1/40;
	dy3=(y_bullet1+10'd14)/40;
	goca3=ay3*16+ax3;
	gocb3=by3*16+bx3;
	gocc3=cy3*16+cx3;
	gocd3=dy3*16+dx3;
	
	ax4=x_bullet2/40;
	ay4=y_bullet2/40;
	bx4=(x_bullet2+10'd14)/40;
	by4=y_bullet2/40;
	cx4=(x_bullet2+10'd14)/40;
	cy4=(y_bullet2+10'd14)/40;
	dx4=x_bullet2/40;
	dy4=(y_bullet2+10'd14)/40;
	goca4=ay4*16+ax4;
	gocb4=by4*16+bx4;
	gocc4=cy4*16+cx4;
	gocd4=dy4*16+dx4;
	
	ax6=x_bullet3/40;
	ay6=y_bullet3/40;
	bx6=(x_bullet3+10'd14)/40;
	by6=y_bullet3/40;
	cx6=(x_bullet3+10'd14)/40;
	cy6=(y_bullet3+10'd14)/40;
	dx6=x_bullet3/40;
	dy6=(y_bullet3+10'd14)/40;
	goca6=ay6*16+ax6;
	gocb6=by6*16+bx6;
	gocc6=cy6*16+cx6;
	gocd6=dy6*16+dx6;
end
always@(posedge clk25)
begin
	if(reset)
		state<=ready;
	else
		state<=next_state;
end

 reg [6:0]state,next_state;
 
 parameter integer ready=0,UP2=1,DOWN2=2,LEFT2=3,RIGHT2=4,
						UP1=5,DOWN1=7,LEFT1=6,RIGHT1=8,
						UP3=9,DOWN3=10,LEFT3=11,RIGHT3=12,
						UP4=13,DOWN4=14,LEFT4=15,RIGHT4=16,
						UP5=17,LEFT5=18,DOWN5=19,RIGHT5=20,COLLISION5=21,COLLISION6=22,COLLISION7=31,COLLISION8=32,
						COLLISION9=33,COLLISION10=34,COLLISION11=35,COLLISION12=36,
						UP6=23,LEFT6=24,DOWN6=25,RIGHT6=26,
						COLLISION1=27,COLLISION2=28,
						COLLISION3=29,COLLISION4=30;
always@(*)
begin
	case(state)
		ready:next_state=(reset==0)?UP1:ready;
		UP1:next_state=LEFT1;
		LEFT1:next_state=RIGHT1;
		RIGHT1:next_state=DOWN1;
		DOWN1:next_state=UP2;
		UP2:next_state=LEFT2;
		LEFT2:next_state=RIGHT2;
		RIGHT2:next_state=DOWN2;
		DOWN2:next_state=UP3;
		
		UP3:next_state=LEFT3;
		LEFT3:next_state=RIGHT3;
		RIGHT3:next_state=DOWN3;
		DOWN3:next_state=UP4;
		UP4:next_state=LEFT4;
		LEFT4:next_state=RIGHT4;
		RIGHT4:next_state=DOWN4;
		DOWN4:next_state=UP5;
		
		UP5:next_state=LEFT5;
		LEFT5:next_state=RIGHT5;
		RIGHT5:next_state=DOWN5;
		DOWN5:next_state=UP6;
		UP6:next_state=LEFT6;
		LEFT6:next_state=RIGHT6;
		RIGHT6:next_state=DOWN6;
		DOWN6:next_state=COLLISION1;
		
		
		
		COLLISION1:next_state=COLLISION2;
		COLLISION2:next_state=COLLISION3;
		COLLISION3:next_state=COLLISION4;
		COLLISION4:next_state=COLLISION5;
		COLLISION5:next_state=COLLISION6;
		COLLISION6:next_state=COLLISION7;
		COLLISION7:next_state=COLLISION8;
		COLLISION8:next_state=COLLISION9;
		COLLISION9:next_state=COLLISION10;
		COLLISION10:next_state=COLLISION11;
		COLLISION11:next_state=COLLISION12;
		COLLISION12:next_state=ready;
		
	endcase
end
always@(*)
begin
	read1=10'd0;
	red_stop=1'b0;
	we=1'b0;
	write=1'b0;
	data=1'b0;
	green_stop=1'b0;
	purple_stop=1'b0;
	stop1=1'b0;
	stop2=1'b0;
	stop3=1'b0;
	case(state)
		ready:
			read1=10'd0;
		UP1:begin
			read1=goca1;
			if(q==3'b001||q==3'b011||q==3'b111)red_stop=1'b1;
			else red_stop=1'b0;
			end
		DOWN1:begin
			read1=gocd1;
			if(q==3'b001||q==3'b011||q==3'b111)red_stop=1'b1;
			else red_stop=1'b0;
			end
		LEFT1:begin
			read1=gocb1;
			if(q==3'b001||q==3'b011||q==3'b111)red_stop=1'b1;
			else red_stop=1'b0;
			end
		RIGHT1:begin
			read1=gocc1;
			if(q==3'b001||q==3'b011||q==3'b111)red_stop=1'b1;
			else red_stop=1'b0;
			end
		UP5:begin
			read1=goca5;
			if(q==3'b001||q==3'b011||q==3'b111)purple_stop=1'b1;
			else purple_stop=1'b0;
			end
		DOWN5:begin
			read1=gocd5;
			if(q==3'b001||q==3'b011||q==3'b111)purple_stop=1'b1;
			else purple_stop=1'b0;
			end
		LEFT5:begin
			read1=gocb5;
			if(q==3'b001||q==3'b011||q==3'b111)purple_stop=1'b1;
			else purple_stop=1'b0;
			end
		RIGHT5:begin
			read1=gocc5;
			if(q==3'b001||q==3'b011||q==3'b111)purple_stop=1'b1;
			else purple_stop=1'b0;
			end
		UP2:begin
			read1=goca2;
			if(q==3'b001||q==3'b011||q==3'b111)green_stop=1'b1;
			else green_stop=1'b0;
			end
		DOWN2:begin
			read1=gocd2;
			if(q==3'b001||q==3'b011||q==3'b111)green_stop=1'b1;
			else green_stop=1'b0;
			end
		LEFT2:begin
			read1=gocb2;
			if(q==3'b001||q==3'b011||q==3'b111)green_stop=1'b1;
			else green_stop=1'b0;
			end
		RIGHT2:begin
			read1=gocc2;
			if(q==3'b001||q==3'b011||q==3'b111)green_stop=1'b1;
			else green_stop=1'b0;
			end
		UP3:begin
			read1=goca3;
			if(q==3'b001)begin stop1=1'b1; we=1'b1; write=goca3; data=1'd0;end
			else if (q==3'b111) stop1=1'b1;
			else stop1=1'b0;
			end
		DOWN3:begin
			read1=gocd3;
			if(q==3'b001)begin stop1=1'b1; we=1'b1; write=gocd3; data=1'd0;end
			else if (q==3'b111) stop1=1'b1;
			else stop1=1'b0;
			end
		LEFT3:begin
			read1=gocb3;
			if(q==3'b001)begin stop1=1'b1; we=1'b1; write=gocb3; data=1'd0;end
			else if (q==3'b111) stop1=1'b1;
			else stop1=1'b0;
			end
		RIGHT3:begin
			read1=gocc3;
			if(q==3'b001)begin stop1=1'b1; we=1'b1; write=gocc3; data=1'd0;end
			else if (q==3'b111) stop1=1'b1;
			else stop1=1'b0;
			end
		UP4:begin
			read1=goca4;
			if(q==3'b001)begin stop2=1'b1; we=1'b1; write=goca4; data=1'd0;end
			else if (q==3'b111) stop2=1'b1;
			else stop2=1'b0;
			end
		DOWN4:begin
			read1=gocd4;
			if(q==3'b001)begin stop2=1'b1; we=1'b1; write=gocd4; data=1'd0;end
			else if (q==3'b111) stop2=1'b1;
			else stop2=1'b0;
			end
		LEFT4:begin
			read1=gocb4;
			if(q==3'b001)begin stop2=1'b1; we=1'b1; write=gocb4; data=1'd0;end
			else if (q==3'b111) stop2=1'b1;
			else stop2=1'b0;
			end
		RIGHT4:begin
			read1=gocc4;
			if(q==3'b001)begin stop2=1'b1; we=1'b1; write=gocc4; data=1'd0;end
			else if (q==3'b111) stop2=1'b1;
			else stop2=1'b0;
			end
		UP6:begin
			read1=goca6;
			if(q==3'b001)begin stop3=1'b1; we=1'b1; write=goca6; data=1'd0;end
			else if (q==3'b111) stop3=1'b1;
			else stop3=1'b0;
			end
		DOWN6:begin
			read1=gocd6;
			if(q==3'b001)begin stop3=1'b1; we=1'b1; write=gocd6; data=1'd0;end
			else if (q==3'b111) stop3=1'b1;
			else stop3=1'b0;
			end
		LEFT6:begin
			read1=gocb6;
			if(q==3'b001)begin stop3=1'b1; we=1'b1; write=gocb6; data=1'd0;end
			else if (q==3'b111) stop3=1'b1;
			else stop3=1'b0;
			end
		RIGHT6:begin
			read1=gocc6;
			if(q==3'b001)begin stop3=1'b1; we=1'b1; write=gocc6; data=1'd0;end
			else if (q==3'b111) stop3=1'b1;
			else stop3=1'b0;
			end
		COLLISION1:begin
if((y_tank1<=(y_tank2+10'd31))&&(y_tank1>=(y_tank2+10'd0))&&(((x_tank1+10'd31)>=x_tank2)&&((x_tank1+10'd31)<=(x_tank2+10'd31)))) red_stop=1'd1;

else if (((y_tank1+10'd31)>=y_tank2)&&((y_tank1+10'd31)<=(y_tank2+10'd31))&&((x_tank1+10'd31)>=x_tank2)&&((x_tank1+10'd31)<=(x_tank2+10'd31))) red_stop=1'd1;

else if((x_tank1<=(x_tank2+10'd31))&&(x_tank1>=x_tank2)&&(((y_tank1+10'd31)>=y_tank2)&&((y_tank1+10'd31)<=(y_tank2+10'd31)))) red_stop=1'd1;
else if ((x_tank1<=(x_tank2+10'd31))&&(x_tank1>=x_tank2)&&(((y_tank1+10'd0)>=y_tank2)&&((y_tank1+10'd0)<=(y_tank2+10'd31)))) red_stop=1'd1;

else red_stop=1'd0;
end
		COLLISION2:begin
if((y_tank2==(y_tank1+10'd31))&&(((x_tank2+10'd31)>=x_tank1)&&((x_tank2+10'd31)<=(x_tank1+10'd31)))) green_stop=1'd1;
else if ((y_tank2==(y_tank1+10'd31))&&(((x_tank2+10'd0)>=x_tank1)&&((x_tank2+10'd0)<=(x_tank1+10'd31)))) green_stop=1'd1;
else if ((y_tank1==(y_tank2+10'd31))&&(((x_tank2+10'd0)>=x_tank1)&&((x_tank2+10'd0)<=(x_tank1+10'd31)))) green_stop=1'd1;
else if ((y_tank1==(y_tank2+10'd31))&&(((x_tank2+10'd31)>=x_tank1)&&((x_tank2+10'd31)<=(x_tank1+10'd31)))) green_stop=1'd1;
else if((x_tank2==(x_tank1+10'd31))&&(((y_tank2+10'd31)>=y_tank1)&&((y_tank2+10'd31)<=(y_tank1+10'd31)))) green_stop=1'd1;
else if ((x_tank2==(x_tank1+10'd31))&&(((y_tank2+10'd0)>=y_tank1)&&((y_tank2+10'd0)<=(y_tank1+10'd31)))) green_stop=1'd1;
else if ((x_tank1==(x_tank2+10'd31))&&(((y_tank2+10'd0)>=y_tank1)&&((y_tank2+10'd0)<=(y_tank1+10'd31)))) green_stop=1'd1;
else if ((x_tank1==(x_tank2+10'd31))&&(((y_tank2+10'd31)>=y_tank1)&&((y_tank2+10'd31)<=(y_tank1+10'd31)))) green_stop=1'd1;
else green_stop=1'd0;			
			end
		COLLISION5:begin
if((y_tank1<=(y_tank3+10'd31))&&(y_tank1>=(y_tank3+10'd0))&&(((x_tank1+10'd31)>=x_tank3)&&((x_tank1+10'd31)<=(x_tank3+10'd31)))) red_stop=1'd1;

else if (((y_tank1+10'd31)>=y_tank3)&&((y_tank1+10'd31)<=(y_tank3+10'd31))&&((x_tank1+10'd31)>=x_tank3)&&((x_tank1+10'd31)<=(x_tank3+10'd31))) red_stop=1'd1;

else if((x_tank1<=(x_tank3+10'd31))&&(x_tank1>=x_tank3)&&(((y_tank1+10'd31)>=y_tank3)&&((y_tank1+10'd31)<=(y_tank3+10'd31)))) red_stop=1'd1;
else if ((x_tank1<=(x_tank3+10'd31))&&(x_tank1>=x_tank3)&&(((y_tank1+10'd0)>=y_tank3)&&((y_tank1+10'd0)<=(y_tank3+10'd31)))) red_stop=1'd1;

else red_stop=1'd0;
end
		COLLISION6:begin
if((y_tank3==(y_tank1+10'd31))&&(((x_tank3+10'd31)>=x_tank1)&&((x_tank3+10'd31)<=(x_tank1+10'd31)))) purple_stop=1'd1;
else if ((y_tank3==(y_tank1+10'd31))&&(((x_tank3+10'd0)>=x_tank1)&&((x_tank3+10'd0)<=(x_tank1+10'd31)))) purple_stop=1'd1;
else if ((y_tank1==(y_tank3+10'd31))&&(((x_tank3+10'd0)>=x_tank1)&&((x_tank3+10'd0)<=(x_tank1+10'd31)))) purple_stop=1'd1;
else if ((y_tank1==(y_tank3+10'd31))&&(((x_tank3+10'd31)>=x_tank1)&&((x_tank3+10'd31)<=(x_tank1+10'd31)))) purple_stop=1'd1;
else if((x_tank3==(x_tank1+10'd31))&&(((y_tank3+10'd31)>=y_tank1)&&((y_tank3+10'd31)<=(y_tank1+10'd31)))) purple_stop=1'd1;
else if ((x_tank3==(x_tank1+10'd31))&&(((y_tank3+10'd0)>=y_tank1)&&((y_tank3+10'd0)<=(y_tank1+10'd31)))) purple_stop=1'd1;
else if ((x_tank1==(x_tank3+10'd31))&&(((y_tank3+10'd0)>=y_tank1)&&((y_tank3+10'd0)<=(y_tank1+10'd31)))) purple_stop=1'd1;
else if ((x_tank1==(x_tank3+10'd31))&&(((y_tank3+10'd31)>=y_tank1)&&((y_tank3+10'd31)<=(y_tank1+10'd31)))) purple_stop=1'd1;
else purple_stop=1'd0;			
			end
		COLLISION7:begin
if((y_tank3<=(y_tank2+10'd31))&&(y_tank3>=(y_tank2+10'd0))&&(((x_tank3+10'd31)>=x_tank2)&&((x_tank3+10'd31)<=(x_tank2+10'd31)))) purple_stop=1'd1;

else if (((y_tank3+10'd31)>=y_tank2)&&((y_tank3+10'd31)<=(y_tank2+10'd31))&&((x_tank3+10'd31)>=x_tank2)&&((x_tank3+10'd31)<=(x_tank2+10'd31))) purple_stop=1'd1;

else if((x_tank3<=(x_tank2+10'd31))&&(x_tank3>=x_tank2)&&(((y_tank3+10'd31)>=y_tank2)&&((y_tank3+10'd31)<=(y_tank2+10'd31)))) purple_stop=1'd1;
else if ((x_tank3<=(x_tank2+10'd31))&&(x_tank3>=x_tank2)&&(((y_tank3+10'd0)>=y_tank2)&&((y_tank3+10'd0)<=(y_tank2+10'd31)))) purple_stop=1'd1;

else purple_stop=1'd0;
end
		COLLISION8:begin
if((y_tank2==(y_tank3+10'd31))&&(((x_tank2+10'd31)>=x_tank3)&&((x_tank2+10'd31)<=(x_tank3+10'd31)))) green_stop=1'd1;
else if ((y_tank2==(y_tank3+10'd31))&&(((x_tank2+10'd0)>=x_tank3)&&((x_tank2+10'd0)<=(x_tank3+10'd31)))) green_stop=1'd1;
else if ((y_tank3==(y_tank2+10'd31))&&(((x_tank2+10'd0)>=x_tank3)&&((x_tank2+10'd0)<=(x_tank3+10'd31)))) green_stop=1'd1;
else if ((y_tank3==(y_tank2+10'd31))&&(((x_tank2+10'd31)>=x_tank3)&&((x_tank2+10'd31)<=(x_tank3+10'd31)))) green_stop=1'd1;
else if((x_tank2==(x_tank3+10'd31))&&(((y_tank2+10'd31)>=y_tank3)&&((y_tank2+10'd31)<=(y_tank3+10'd31)))) green_stop=1'd1;
else if ((x_tank2==(x_tank3+10'd31))&&(((y_tank2+10'd0)>=y_tank3)&&((y_tank2+10'd0)<=(y_tank3+10'd31)))) green_stop=1'd1;
else if ((x_tank3==(x_tank2+10'd31))&&(((y_tank2+10'd0)>=y_tank3)&&((y_tank2+10'd0)<=(y_tank3+10'd31)))) green_stop=1'd1;
else if ((x_tank3==(x_tank2+10'd31))&&(((y_tank2+10'd31)>=y_tank3)&&((y_tank2+10'd31)<=(y_tank3+10'd31)))) green_stop=1'd1;
else green_stop=1'd0;			
			end
		COLLISION3:begin
if((y_bullet2==(y_bullet1+10'd14))&&(((x_bullet2+10'd14)>=x_bullet1)&&((x_bullet2+10'd14)<=(x_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((y_bullet2==(y_bullet1+10'd14))&&(((x_bullet2+10'd0)>=x_bullet1)&&((x_bullet2+10'd0)<=(x_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((y_bullet1==(y_bullet2+10'd14))&&(((x_bullet2+10'd0)>=x_bullet1)&&((x_bullet2+10'd0)<=(x_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((y_bullet1==(y_bullet2+10'd14))&&(((x_bullet2+10'd14)>=x_bullet1)&&((x_bullet2+10'd14)<=(x_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if((x_bullet2==(x_bullet1+10'd14))&&(((y_bullet2+10'd14)>=y_bullet1)&&((y_bullet2+10'd14)<=(y_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((x_bullet2==(x_bullet1+10'd14))&&(((y_bullet2+10'd0)>=y_bullet1)&&((y_bullet2+10'd0)<=(y_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((x_bullet1==(x_bullet2+10'd14))&&(((y_bullet2+10'd0)>=y_bullet1)&&((y_bullet2+10'd0)<=(y_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((x_bullet1==(x_bullet2+10'd14))&&(((y_bullet2+10'd14)>=y_bullet1)&&((y_bullet2+10'd14)<=(y_bullet1+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else begin stop2=1'd0; stop1=1'd0; end			
			end
		COLLISION4:begin
if((y_bullet1<=(y_bullet2+10'd14))&&(y_bullet1>=(y_bullet2+10'd0))&&(((x_bullet1+10'd14)>=x_bullet2)&&((x_bullet1+10'd14)<=(x_bullet2+10'd14)))) begin stop2=1'd1; stop1=1'd1; end

else if (((y_bullet1+10'd14)>=y_bullet2)&&((y_bullet1+10'd14)<=(y_bullet2+10'd14))&&((x_bullet1+10'd14)>=x_bullet2)&&((x_bullet1+10'd14)<=(x_bullet2+10'd14))) begin stop2=1'd1; stop1=1'd1; end

else if((x_bullet1<=(x_bullet2+10'd14))&&(x_bullet1>=x_bullet2)&&(((y_bullet1+10'd14)>=y_bullet2)&&((y_bullet1+10'd14)<=(y_bullet2+10'd14)))) begin stop2=1'd1; stop1=1'd1; end
else if ((x_bullet1<=(x_bullet2+10'd14))&&(x_bullet1>=x_bullet2)&&(((y_bullet1+10'd0)>=y_bullet2)&&((y_bullet1+10'd0)<=(y_bullet2+10'd14)))) begin stop2=1'd1; stop1=1'd1; end

else begin stop2=1'd0; stop1=1'd0; end		
			end
		COLLISION9:begin
if((y_bullet2==(y_bullet3+10'd14))&&(((x_bullet2+10'd14)>=x_bullet3)&&((x_bullet2+10'd14)<=(x_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((y_bullet2==(y_bullet3+10'd14))&&(((x_bullet2+10'd0)>=x_bullet3)&&((x_bullet2+10'd0)<=(x_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((y_bullet3==(y_bullet2+10'd14))&&(((x_bullet2+10'd0)>=x_bullet3)&&((x_bullet2+10'd0)<=(x_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((y_bullet3==(y_bullet2+10'd14))&&(((x_bullet2+10'd14)>=x_bullet3)&&((x_bullet2+10'd14)<=(x_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if((x_bullet2==(x_bullet3+10'd14))&&(((y_bullet2+10'd14)>=y_bullet3)&&((y_bullet2+10'd14)<=(y_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((x_bullet2==(x_bullet3+10'd14))&&(((y_bullet2+10'd0)>=y_bullet3)&&((y_bullet2+10'd0)<=(y_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((x_bullet3==(x_bullet2+10'd14))&&(((y_bullet2+10'd0)>=y_bullet3)&&((y_bullet2+10'd0)<=(y_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((x_bullet3==(x_bullet2+10'd14))&&(((y_bullet2+10'd14)>=y_bullet3)&&((y_bullet2+10'd14)<=(y_bullet3+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else begin stop2=1'd0; stop3=1'd0; end			
			end
		COLLISION10:begin
if((y_bullet3<=(y_bullet2+10'd14))&&(y_bullet3>=(y_bullet2+10'd0))&&(((x_bullet3+10'd14)>=x_bullet2)&&((x_bullet3+10'd14)<=(x_bullet2+10'd14)))) begin stop2=1'd1; stop3=1'd1; end

else if (((y_bullet3+10'd14)>=y_bullet2)&&((y_bullet3+10'd14)<=(y_bullet2+10'd14))&&((x_bullet3+10'd14)>=x_bullet2)&&((x_bullet3+10'd14)<=(x_bullet2+10'd14))) begin stop2=1'd1; stop3=1'd1; end

else if((x_bullet3<=(x_bullet2+10'd14))&&(x_bullet3>=x_bullet2)&&(((y_bullet3+10'd14)>=y_bullet2)&&((y_bullet3+10'd14)<=(y_bullet2+10'd14)))) begin stop2=1'd1; stop3=1'd1; end
else if ((x_bullet3<=(x_bullet2+10'd14))&&(x_bullet3>=x_bullet2)&&(((y_bullet3+10'd0)>=y_bullet2)&&((y_bullet3+10'd0)<=(y_bullet2+10'd14)))) begin stop2=1'd1; stop3=1'd1; end

else begin stop2=1'd0; stop3=1'd0; end		
			end
		COLLISION11:begin
if((y_bullet1==(y_bullet3+10'd14))&&(((x_bullet1+10'd14)>=x_bullet3)&&((x_bullet1+10'd14)<=(x_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((y_bullet1==(y_bullet3+10'd14))&&(((x_bullet1+10'd0)>=x_bullet3)&&((x_bullet1+10'd0)<=(x_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((y_bullet3==(y_bullet1+10'd14))&&(((x_bullet1+10'd0)>=x_bullet3)&&((x_bullet1+10'd0)<=(x_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((y_bullet3==(y_bullet1+10'd14))&&(((x_bullet1+10'd14)>=x_bullet3)&&((x_bullet1+10'd14)<=(x_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if((x_bullet1==(x_bullet3+10'd14))&&(((y_bullet1+10'd14)>=y_bullet3)&&((y_bullet1+10'd14)<=(y_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((x_bullet1==(x_bullet3+10'd14))&&(((y_bullet1+10'd0)>=y_bullet3)&&((y_bullet1+10'd0)<=(y_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((x_bullet3==(x_bullet1+10'd14))&&(((y_bullet1+10'd0)>=y_bullet3)&&((y_bullet1+10'd0)<=(y_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((x_bullet3==(x_bullet1+10'd14))&&(((y_bullet1+10'd14)>=y_bullet3)&&((y_bullet1+10'd14)<=(y_bullet3+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else begin stop1=1'd0; stop3=1'd0; end			
			end
		COLLISION12:begin
if((y_bullet3<=(y_bullet1+10'd14))&&(y_bullet3>=(y_bullet1+10'd0))&&(((x_bullet3+10'd14)>=x_bullet1)&&((x_bullet3+10'd14)<=(x_bullet1+10'd14)))) begin stop1=1'd1; stop3=1'd1; end

else if (((y_bullet3+10'd14)>=y_bullet1)&&((y_bullet3+10'd14)<=(y_bullet1+10'd14))&&((x_bullet3+10'd14)>=x_bullet1)&&((x_bullet3+10'd14)<=(x_bullet1+10'd14))) begin stop1=1'd1; stop3=1'd1; end

else if((x_bullet3<=(x_bullet1+10'd14))&&(x_bullet3>=x_bullet1)&&(((y_bullet3+10'd14)>=y_bullet1)&&((y_bullet3+10'd14)<=(y_bullet1+10'd14)))) begin stop1=1'd1; stop3=1'd1; end
else if ((x_bullet3<=(x_bullet1+10'd14))&&(x_bullet3>=x_bullet1)&&(((y_bullet3+10'd0)>=y_bullet1)&&((y_bullet3+10'd0)<=(y_bullet1+10'd14)))) begin stop1=1'd1; stop3=1'd1; end

else begin stop1=1'd0; stop3=1'd0; end		
			end
	endcase
end
///////////////////////AI-BOT//////////////////////////////////////////
///////////////////////////AUTO FIRE//////////////////////////////
//autofire a1(clk25,reset,player2[4]);
//autofire a2(clk25,reset,player3[4]);
////////////////////////////AUTO MOVE////////////////////////////
reg upgreen,downgreen,rightgreen,leftgreen;
reg uppurple,downpurple,rightpurple,leftpurple;
automove1 a3(clk25,reset,player2[4:0],x_tank1,y_tank1,x_tank2,y_tank2,green_bullet_orient,greentank_orient,upgreen,downgreen,rightgreen,leftgreen,green_bullet_act,music2);
automove2 a4(clk25,reset,player3[4:0],x_tank1,y_tank1,x_tank3,y_tank3,purple_bullet_orient,purpletank_orient,uppurple,downpurple,rightpurple,leftpurple,purple_bullet_act,music2);
/////////////////////////gamescreen////////////////////////////////////

always@(posedge clk25) begin
     
	if(y >= 0 && y <= 479 && x >= 0 && x <= 639)
			begin
				if(mapdata==3'b001)
					first_screen_out<={m_icon_data[7:5],1'b0,m_icon_data[4:2],1'b0,m_icon_data[1:0],2'b0};
				else if(mapdata==3'b011)begin
					if(water_flag==1'b0) first_screen_out<={m_icon_data1[7:5],1'b0,m_icon_data1[4:2],1'b0,m_icon_data1[1:0],2'b0};
					else if (water_flag==1'b1) first_screen_out<={m_icon_data2[7:5],1'b0,m_icon_data2[4:2],1'b0,m_icon_data2[1:0],2'b0};
				end
				else if (mapdata==3'b111) first_screen_out<={m_icon_data3[7:5],1'b0,m_icon_data3[4:2],1'b0,m_icon_data3[1:0],2'b0};
				
			else first_screen_out<=12'd0;
			end
if (reset)
		begin
			y_tank1 <= 9'd3;                   
			x_tank1 <= 10'd3;

		end
	
	else if ( explosion_flag >= 1'd1)                  
	   begin
	       red_explosion_ack <= 1'd1;                  
	       //y_tank1 <= 9'd3;                   
          // x_tank1 <= 10'd3;
           
	   end
	
	
	else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
					begin if(x_tank1 < 10'd2 ) 
                     
                        x_tank1<=10'd5;             
                      
	            else if ( y_tank1 < 9'd2 ) 
                     
                          y_tank1<=9'd5;             
                      
	            else if ( x_tank1 > 10'd606 ) 
                     
                          x_tank1<=10'd604;             
                      
	             else if( y_tank1 > 9'd445 ) 
                     
                          y_tank1<=9'd443; 
					end
                      
	
	else if ((flag > 0) )          
		begin
			if (red_stop == 1'd0)                    
                begin
					 
                    case (player1)         
                        UP:	begin	y_tank1 <= y_tank1 - 1'd1;    end         
                        DOWN: begin	y_tank1 <= y_tank1 + 1'd1;   end
                        LEFT: begin 	x_tank1 <= x_tank1 - 1'd1;  end
                        RIGHT: begin	x_tank1 <= x_tank1 + 1'd1;  end
                        default:	begin
                                        x_tank1 <= x_tank1;
                                        y_tank1 <= y_tank1;
                                    end
			         endcase
			    end
				
			else if (red_stop >= 1'd1)       
			     begin
						  
			               
			         case (player1)
                         UP:       y_tank1 <= y_tank1 + 9'd1;             
                         DOWN:      y_tank1 <= y_tank1 - 9'd1;  
                         LEFT:      x_tank1 <= x_tank1 + 9'd1; 
                         RIGHT:      x_tank1 <= x_tank1 - 9'd1;
                         default:    begin
                                         x_tank1 <= x_tank1;
                                         y_tank1 <= y_tank1;
                                     end
                      endcase
			     end
			
			else begin
			         y_tank1 <= y_tank1;
                     x_tank1 <= x_tank1;
                     
			     end
		
	   end
	else if (red_stop >= 1'd1)       
			     begin
						      
			         case (player1)
                         UP:        y_tank1 <= y_tank1 + 9'd1;             
                         DOWN:      y_tank1 <= y_tank1 - 9'd1;
                         LEFT:      x_tank1 <= x_tank1 + 9'd1;
                         RIGHT:     x_tank1 <= x_tank1 - 9'd1;
                         default:    begin
                                         x_tank1 <= x_tank1;
                                         y_tank1 <= y_tank1;
                                     end
                      endcase
			     end
	   else
		begin
			y_tank1 <= y_tank1;
			x_tank1 <= x_tank1;
			red_explosion_ack <= 1'd0;                   
		end
//////////////////////////////////////////////////////////////////////////
if (reset)
		begin
			y_tank2 <= 9'd441;                   
			x_tank2 <= 10'd604;

		end
	
	else if ( green_explosion_flag >= 1'd1)                  
	   begin
	       green_explosion_ack <= 1'd1;                  
	       y_tank2 <= 9'd490;                   
           x_tank2 <= 10'd650;
           
	   end
	
	
	else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
					begin if(x_tank2 < 10'd2 ) 
                     
                        x_tank2<=10'd5;             
                      
	            else if ( y_tank2 < 9'd2 ) 
                     
                          y_tank2<=9'd5;             
                      
	            else if (( x_tank2 > 10'd606 )&& ( x_tank2 < 10'd620 ))
                     
                          x_tank2<=10'd604;             
                      
	             else if(( y_tank2 > 9'd445 )&&(y_tank2<9'd450))
                     
                          y_tank2<=9'd443; 
					else if((y_tank2>9'd480)&&(y_tank2<9'd500))
									y_tank2<=9'd490;
					end
                      
	
	else if ((flag > 0) )          
		begin
			if (green_stop == 1'd0)                    
                begin
					 
                    case (player2)         
                        UP:	begin	y_tank2 <= y_tank2 - 1'd1;    end         
                        DOWN: begin	y_tank2 <= y_tank2 + 1'd1;   end
                        LEFT: begin 	x_tank2 <= x_tank2 - 1'd1;  end
                        RIGHT: begin	x_tank2 <= x_tank2 + 1'd1;  end
                        default:	begin
                                        x_tank2 <= x_tank2;
                                        y_tank2 <= y_tank2;
                                    end
			         endcase
			    end
				
			else if (green_stop >= 1'd1)       
			     begin
						  
			           //green_stop <= 1'd0;     
			         case (player2)
                         UP:       y_tank2 <= y_tank2 + 9'd1;             
                         DOWN:      y_tank2 <= y_tank2 - 9'd1;  
                         LEFT:      x_tank2 <= x_tank2 + 9'd1; 
                         RIGHT:      x_tank2 <= x_tank2 - 9'd1;
                         default:    begin
                                         x_tank2 <= x_tank2;
                                         y_tank2 <= y_tank2;
                                     end
                      endcase
			     end
			
			else begin
			         y_tank2 <= y_tank2;
                     x_tank2 <= x_tank2;
                     //red_stop <= 1'd0;
			     end
		
	   end
	else if (green_stop >= 1'd1)       
			     begin
						      
			         case (player2)
                         UP:     begin   y_tank2 <= y_tank2 + 9'd1;  upgreen=1'b1; end           
                         DOWN: begin     y_tank2 <= y_tank2 - 9'd1; downgreen=1'b1; end
                         LEFT:    begin  x_tank2 <= x_tank2 + 9'd1; leftgreen=1'b1; end
                         RIGHT:   begin  x_tank2 <= x_tank2 - 9'd1; rightgreen=1'b1; end
                         default:    begin
                                         x_tank2 <= x_tank2;
                                         y_tank2 <= y_tank2;
                                     end
                      endcase
			     end
	   else
		begin
			y_tank2 <= y_tank2;
			x_tank2 <= x_tank2;
			green_explosion_ack <= 1'd0;                   
		end
//////////////////////////////////////////////////////////////////////////////////////////
if (reset)
		begin
			y_tank3 <= 9'd3;                   
			x_tank3 <= 10'd604;

		end
	
	else if ( purple_explosion_flag >= 1'd1)                  
	  begin
	       purple_explosion_ack <= 1'd1;                  
	       y_tank3 <= 9'd490;                   
           x_tank3 <= 10'd650;
           
	   end
	
	
	else if ((y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
					begin if(x_tank3 < 10'd2 ) 
                     
                        x_tank3<=10'd5;             
                      
	            else if ( y_tank3 < 9'd2 ) 
                     
                          y_tank3<=9'd5;             
                      
	            else if (( x_tank3 > 10'd606 )&& ( x_tank3 < 10'd620 ))
                     
                          x_tank3<=10'd604;             
                      
	             else if(( y_tank3 > 9'd445 )&&(y_tank3<9'd450))
                     
                          y_tank3<=9'd443; 
					else if((y_tank3>9'd480)&&(y_tank3<9'd500))
									y_tank3<=9'd490;
					end
                      
	
	else if ((flag > 0) )          
		begin
			if (purple_stop == 1'd0)                    
                begin
					 
                    case (player3)         
                        UP:	begin	y_tank3 <= y_tank3 - 1'd1;    end         
                        DOWN: begin	y_tank3 <= y_tank3 + 1'd1;   end
                        LEFT: begin 	x_tank3 <= x_tank3 - 1'd1;  end
                        RIGHT: begin	x_tank3 <= x_tank3 + 1'd1;  end
                        default:	begin
                                        x_tank3 <= x_tank3;
                                        y_tank3 <= y_tank3;
                                    end
			         endcase
			    end
				
			else if (purple_stop >= 1'd1)       
			     begin
						  
			               
			         case (player3)
                         UP:       y_tank3 <= y_tank3 + 9'd1;             
                         DOWN:      y_tank3 <= y_tank3 - 9'd1;  
                         LEFT:      x_tank3 <= x_tank3 + 9'd1; 
                         RIGHT:      x_tank3 <= x_tank3 - 9'd1;
                         default:    begin
                                         x_tank3 <= x_tank3;
                                         y_tank3 <= y_tank3;
                                     end
                      endcase
			     end
			
			else begin
			         y_tank3 <= y_tank3;
                     x_tank3 <= x_tank3;
                     
			     end
		
	   end
	else if (purple_stop >= 1'd1)       
			     begin
						      
			         case (player3)
                         UP: begin       y_tank3 <= y_tank3 + 9'd1;   uppurple=1'b1; end          
                         DOWN:   begin   y_tank3 <= y_tank3 - 9'd1;   downpurple=1'b1; end
                         LEFT:   begin   x_tank3 <= x_tank3 + 9'd1;   leftpurple=1'b1; end
                         RIGHT:  begin   x_tank3 <= x_tank3 - 9'd1; rightpurple=1'b1; end
                         default:    begin
                                         x_tank3 <= x_tank3;
                                         y_tank3 <= y_tank3;
                                     end
                      endcase
			     end
	   else
		begin
			y_tank3 <= y_tank3;
			x_tank3 <= x_tank3;
			purple_explosion_ack <= 1'd0;                   
		end
///////////////////////////////////////////////////////////////////////////////
if (reset)
		begin
			red_bullet_act <= 0;
			x_bullet1 <= 10'd0;                    
			y_bullet1 <= 9'd0;
		end
		else if (stop1)begin
			red_bullet_act <= 0;
			x_bullet1 <= 10'd0;                    
			y_bullet1 <= 9'd0;
		end
		
		
    else if (explosion_flag >= 1'd1)                   
        begin 
           red_explosion_ack <= 1'd1;                    
          x_bullet1 <= 10'd0;
           y_bullet1 <= 9'd0;
        end 	
	else if ((player1[4] == 1'd1)&&(red_bullet_act==1'b0))                          
		begin
			red_bullet_act <= 1'd1;                          
			x_bullet1 <= x_tank1 + 4'd15;      
			y_bullet1 <= y_tank1 + 4'd15;
		end
	else if ((red_bullet_act == 1'd1) && (bullet_flag > 0))    
		begin
			case (red_bullet_orient)         
				ICON_UP:			y_bullet1 <= y_bullet1 - 1'd1;	
				ICON_DOWN:		    y_bullet1 <= y_bullet1 + 1'd1;
				ICON_LEFT:		    x_bullet1 <= x_bullet1 - 1'd1;
				ICON_RIGHT:		   x_bullet1 <= x_bullet1 + 1'd1;
				default:	begin
								    x_bullet1 <= x_bullet1;
								    y_bullet1 <= y_bullet1;
							end
			endcase
		end
	
	else if ((y_bullet1 >= y_tank2) && ( y_bullet1 <= (y_tank2+ 10'd31)) &&    
            (x_bullet1 >= x_tank2) && ( x_bullet1 <= (x_tank2+ 10'd31)))
                 begin 
							red_bullet_act <= 0;
			//x_bullet1 <= 10'd0;                    
			//y_bullet1 <= 9'd0;
						end
	else if ((y_bullet1 >= y_tank3) && ( y_bullet1 <= (y_tank3+ 10'd31)) &&    
            (x_bullet1 >= x_tank3) && ( x_bullet1 <= (x_tank3+ 10'd31)))
                  begin 
							red_bullet_act <= 0;
			//x_bullet1 <= 10'd0;                    
			//y_bullet1 <= 9'd0;
						end
	else begin
			x_bullet1 <= x_bullet1;
			y_bullet1 <= y_bullet1;
			red_explosion_ack <= 1'd0;
		end
///////////////////////////////////////////////////////////////////////////////////////
if (reset)
                begin
                    green_bullet_act <= 0;                          
                    x_bullet2 <= 10'd0;
                    y_bullet2 <= 9'd0;
                end
			else if (stop2)begin
			green_bullet_act <= 0;
			x_bullet2 <= 10'd0;                    
			y_bullet2 <= 9'd0;
		end
            else if (green_explosion_flag >= 1'd1)                        
                begin   
                   green_explosion_ack <= 1'd1;                  
                   x_bullet2 <= 10'd0;
                   y_bullet2 <= 9'd0;
                end   
            else if ((player2[4] == 1'd1)&&(green_bullet_act==1'b0))   
                begin
                    green_bullet_act <= 1'd1;                       
                    x_bullet2 <= x_tank2 + 4'd15;   
                    y_bullet2 <= y_tank2 + 4'd15;
                end
            else if ((green_bullet_act == 1'd1) && (bullet_flag > 0)) 
                begin
                    case (green_bullet_orient)
                        ICON_UP:            y_bullet2 <= y_bullet2 - 1'd1;    
                        ICON_DOWN:          y_bullet2 <= y_bullet2 + 1'd1;
                        ICON_LEFT:          x_bullet2 <= x_bullet2 - 1'd1;
                        ICON_RIGHT:         x_bullet2 <= x_bullet2 + 1'd1;
                        default:    begin
                                        x_bullet2 <= x_bullet2;
                                        y_bullet2 <= y_bullet2;
                                    end
                    endcase
                end
          
           else if ((y_bullet2 >= y_tank1) && ( y_bullet2 <= (y_tank1+ 10'd31)) && 
                    (x_bullet2 >= x_tank1) && ( x_bullet2 <= (x_tank1+ 10'd31)))
                          begin 
							green_bullet_act <= 0;
			//x_bullet2 <= 10'd0;                    
			//y_bullet2 <= 9'd0;
						end 
				else if ((y_bullet2 >= y_tank3) && ( y_bullet2 <= (y_tank3+ 10'd31)) && 
                    (x_bullet2 >= x_tank3) && ( x_bullet2 <= (x_tank3+ 10'd31)))
                          begin 
							green_bullet_act <= 0;
			x_bullet2 <= 10'd0;                    
			y_bullet2 <= 9'd0;
						end
            else begin
                    x_bullet2 <= x_bullet2;
                    y_bullet2 <= y_bullet2;
                    green_explosion_ack <= 1'd0;
                end
/////////////////////////////////////////////////////////////////////////////////////////
if (reset)
                begin
                    purple_bullet_act <= 0;                          
                    x_bullet3 <= 10'd0;
                    y_bullet3 <= 9'd0;
                end
				else if (stop3)begin
			purple_bullet_act <= 0;
			x_bullet3 <= 10'd0;                    
			y_bullet3 <= 9'd0;
		end
            else if (purple_explosion_flag >= 1'd1)                        
                begin   
                   purple_explosion_ack <= 1'd1;                  
                  x_bullet3 <= 10'd0;
                  y_bullet3 <= 9'd0;
                end   
            else if ((player3[4] == 1'd1)&&(purple_bullet_act==1'b0))   
                begin
                    purple_bullet_act <= 1'd1;                       
                    x_bullet3 <= x_tank3 + 4'd15;   
                    y_bullet3 <= y_tank3 + 4'd15;
                end
            else if ((purple_bullet_act == 1'd1) && (bullet_flag > 0)) 
                begin
                    case (purple_bullet_orient)
                        ICON_UP:            y_bullet3 <= y_bullet3 - 1'd1;    
                        ICON_DOWN:          y_bullet3 <= y_bullet3 + 1'd1;
                        ICON_LEFT:          x_bullet3 <= x_bullet3 - 1'd1;
                        ICON_RIGHT:         x_bullet3 <= x_bullet3 + 1'd1;
                        default:    begin
                                        x_bullet3 <= x_bullet3;
                                        y_bullet3 <= y_bullet3;
                                    end
                    endcase
                end
          
           else if ((y_bullet3 >= y_tank1) && ( y_bullet3 <= (y_tank1+ 10'd31)) && 
                    (x_bullet3 >= x_tank1) && ( x_bullet3 <= (x_tank1+ 10'd31)))
                          begin 
							purple_bullet_act <= 0;
			//x_bullet3 <= 10'd0;                    
			//y_bullet3 <= 9'd0;
						end 
				else if ((y_bullet3 >= y_tank2) && ( y_bullet3 <= (y_tank2+ 10'd31)) && 
                    (x_bullet3 >= x_tank2) && ( x_bullet3 <= (x_tank2+ 10'd31)))
                          begin 
							purple_bullet_act <= 0;
			x_bullet3 <= 10'd0;                    
			y_bullet3 <= 9'd0;
						end
            else begin
                    x_bullet3 <= x_bullet3;
                    y_bullet3 <= y_bullet3;
                    purple_explosion_ack <= 1'd0;
                end
///////////////////////////////////////////////////////////////////////////////
if (reset) begin
                up_addr <=  10'd0;
                left_addr <= 10'd0;
                end
                
               
           else if ((y_bullet2 >= y_tank1) && ( y_bullet2 <= (y_tank1+ 10'd31)) && 
                (x_bullet2 >= x_tank1) && ( x_bullet2 <= (x_tank1+ 10'd31)) &&
                (y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                    begin
                               explosion_addr <= explosion_addr + 1'd1;             
                               first_screen_out <= explosion_dataOut;               
                               green_explosion_cnt <= green_explosion_cnt + 1'd1;   
                               explosion_flag <= 1'd1;
										 
                    end
				 else if ((y_bullet3 >= y_tank1) && ( y_bullet3 <= (y_tank1+ 10'd31)) && 
                (x_bullet3 >= x_tank1) && ( x_bullet3 <= (x_tank1+ 10'd31)) &&
                (y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                    begin
                               explosion_addr <= explosion_addr + 1'd1;             
                               first_screen_out <= explosion_dataOut;               
                               purple_explosion_cnt <= purple_explosion_cnt + 1'd1;   
                               explosion_flag <= 1'd1;
										 
                    end
            
           
           else if (green_explosion_cnt >= 19'd10000)
                begin
                    green_explosion_cnt <= 19'd0;
                    explosion_flag <= 1'd1;                                         
                 end
				else if (purple_explosion_cnt >= 19'd10000)
                begin
                    purple_explosion_cnt <= 19'd0;
                    explosion_flag <= 1'd1;                                         
                                                              
                end
           
        
       
            else if (red_explosion_ack >= 1'd1) begin explosion_flag <= 1'd0;
																		player_screen=2'd2;////lose
																end
   
  
            else if (play == 1'd1||menu==1'd1) begin
                                        player_screen <= 2'd0;
                                        y_tank1 <= 9'd3;  
												 x_tank1 <= 10'd3;
												 end
   
   else begin
           

           case (redtank_orient)
           
            ICON_UP:  if ((y == y_tank1) && (x == x_tank1)) 
                        begin
                         up_addr <=10'd0;                       
                         explosion_addr <= 10'd0;
                         end
                       else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                          (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= up_dataOut;   
                               up_addr <= up_addr + 1'd1;        
                       end
            
                else begin
                        up_addr <= up_addr + 10'd0;             
                        explosion_addr <= explosion_addr;       
                    end
            ICON_DOWN: if ((y == y_tank1) && (x == x_tank1))
                        begin
                         up_addr <=10'd1023;                                    
                        explosion_addr <= 10'd0;                
                         end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin 
                                first_screen_out <= up_dataOut;  
                                up_addr <= up_addr - 1'd1;      
                               
                       end
             
                else begin
                           up_addr <= up_addr + 10'd0;          
                           explosion_addr <= explosion_addr;    
                       end
            ICON_LEFT:   
                 if ((y == y_tank1) && (x == x_tank1)) 
                            begin
                                left_addr <=10'd0;                   
                                explosion_addr <= 10'd0;
                            end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= left_dataOut;    
                               left_addr <= left_addr + 1'd1;       
                       end
            
            else begin
                            left_addr <= left_addr + 10'd0;         
                            explosion_addr <= explosion_addr;
                    end    
            ICON_RIGHT:  
             if ((y == y_tank1) && (x == x_tank1)) 
                        begin
                            left_addr <=10'd1023;                                     
                            explosion_addr <= 10'd0;
                        end               
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin 
                               first_screen_out <= left_dataOut;    
                               left_addr <= left_addr - 1'd1;       
                       end
            
            else begin
                    left_addr <= left_addr + 10'd0;                 
                    explosion_addr <= explosion_addr;
                end            
            
            endcase
    
end
//////////////////////////////////////////////////////////////////////////////////////
if (reset) begin
            greenup_addr <= 10'd0;
            greenleft_addr <= 10'd0;
        end
          
    else if ((y_bullet1 >= y_tank2) && ( y_bullet1 <= (y_tank2+ 10'd31)) && 
        (x_bullet1 >= x_tank2) && ( x_bullet1 <= (x_tank2+ 10'd31)) &&
        (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
        (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
            begin
                green_explosion_addr <= green_explosion_addr + 1'd1;
                first_screen_out <= green_explosion_dataOut;
                //explosion1_enable<=1'b1;                  
                //green_explosion_flag <= 1'd1; 
					 explosion1_cnt<=explosion1_cnt+1'd1;
            end
     //else if ((y_bullet3 >= y_tank2) && ( y_bullet3 <= (y_tank2+ 10'd31)) && 
      //  (x_bullet3 >= x_tank2) && ( x_bullet3 <= (x_tank2+ 10'd31)) &&
      //  (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
      //  (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
      //      begin
       //         green_explosion_addr <= green_explosion_addr + 1'd1;
       //         first_screen_out <= green_explosion_dataOut;
       //         purple_explosion_cnt <= purple_explosion_cnt + 1'd1;                  
                 
       //     end       
    //else if (explosion1_enable==1'b1)
	//			 explosion1_cnt<=explosion1_cnt+1'd1;
    else if (explosion1_cnt >= 19'd10)
             begin
                 //explosion1_enable<=1'b0;                         
                 explosion1_cnt <= 19'd0;
                 green_explosion_flag <= 1'd1; 
						red_score<=red_score+1'd1;
                                                 
             end
	//else if (purple_explosion_cnt >= 19'd10000)
        //        begin
        //            purple_explosion_cnt <= 19'd0;
         //           green_explosion_flag <= 1'd1;                                         
                                                              
         //       end
             
	else if(red_score==2'd2) begin player_screen<=2'd3;
											 red_score<=2'd0;
									end////win
    
              
  
    else if (green_explosion_ack >= 1'd1) green_explosion_flag <= 1'd0;
     else if (play == 1'd1||menu==1'd1) begin                             
                player_screen <= 2'b0;                                  
                red_score <= 1'd0;
					 y_tank2 <= 9'd441; 
					 x_tank2 <= 10'd604;
              end
    else  begin
                
   
            case (greentank_orient)
           
            ICON_UP:   
            if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenup_addr <=10'd0;                           
                        green_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenup_dataOut;    
                               greenup_addr <= greenup_addr + 1'd1;     
                       end
            
            else begin 
                    greenup_addr <= greenup_addr + 10'd0;               
                    green_explosion_addr <= green_explosion_addr;
                 end
            ICON_DOWN:
              if ((y == y_tank2) && (x == x_tank2))
                    begin
                     greenup_addr <=10'd1023;                           
                    green_explosion_addr <= 10'd0;
                    end                
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin 
                                first_screen_out <= greenup_dataOut;        
                                greenup_addr <= greenup_addr - 1'd1;        
                               
                       end
             
            else begin 
                   greenup_addr <= greenup_addr + 10'd0;                    
                   green_explosion_addr <= green_explosion_addr;
                end
            ICON_LEFT:   
             if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenleft_addr <=10'd0;                                  
                        green_explosion_addr <= 10'd0;
                        end                  
             
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenleft_dataOut;                   
                               greenleft_addr <= greenleft_addr + 1'd1;
                       end
            
            else 
                begin
                    greenleft_addr <= greenleft_addr + 10'd0;                    
                   green_explosion_addr <= green_explosion_addr;
                 end            
            ICON_RIGHT:
             if ((y == y_tank2) && (x == x_tank2))
                begin
                    greenleft_addr <=10'd1023;                                   
                    green_explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin   
                               first_screen_out <= greenleft_dataOut;           
                               greenleft_addr <= greenleft_addr - 1'd1;
                       end
                    
            else begin
                   greenleft_addr <= greenleft_addr + 10'd0;                    
                  green_explosion_addr <= green_explosion_addr;
                end
				default:   
            if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenup_addr <=10'd0;                           
                        green_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenup_dataOut;    
                               greenup_addr <= greenup_addr + 1'd1;     
                       end
            
            else begin 
                    greenup_addr <= greenup_addr + 10'd0;               
                    green_explosion_addr <= green_explosion_addr;
                 end
            endcase    
    end
////////////////////////////////////////////////////////////////////////////
if (reset) begin
            purpleup_addr <= 10'd0;
            purpleleft_addr <= 10'd0;
        end
          
    else if ((y_bullet1 >= y_tank3) && ( y_bullet1 <= (y_tank3+ 10'd31)) && 
        (x_bullet1 >= x_tank3) && ( x_bullet1 <= (x_tank3+ 10'd31)) &&
        (y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && 
        (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
            begin
                purple_explosion_addr <= purple_explosion_addr + 1'd1;
                first_screen_out <= purple_explosion_dataOut;
                //explosion2_enable<=1'b1;
					 //purple_explosion_flag <= 1'd1;
					 explosion2_cnt<=explosion2_cnt+1'd1;
                 
            end
     //else if ((y_bullet3 >= y_tank2) && ( y_bullet3 <= (y_tank2+ 10'd31)) && 
      //  (x_bullet3 >= x_tank2) && ( x_bullet3 <= (x_tank2+ 10'd31)) &&
      //  (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
      //  (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
      //      begin
       //         green_explosion_addr <= green_explosion_addr + 1'd1;
       //         first_screen_out <= green_explosion_dataOut;
       //         purple_explosion_cnt <= purple_explosion_cnt + 1'd1;                  
                 
       //     end       
    //else if(explosion2_enable==1'b1)
		//		explosion2_cnt<=explosion2_cnt+1'd1;
    else if (explosion2_cnt >= 19'd10)
             begin
                  //explosion2_enable<=1'b0;                        
                 explosion2_cnt <= 19'd0;
                 purple_explosion_flag <= 1'd1; 
						red_score<=red_score+1'd1;
                                                 
             end
	//else if (purple_explosion_cnt >= 19'd10000)
        //        begin
        //            purple_explosion_cnt <= 19'd0;
         //           green_explosion_flag <= 1'd1;                                         
                                                              
         //       end
             
	else if(red_score==2'd2) begin player_screen<=2'd3;
												red_score<=2'd0;
									end////win
    
              
  
    else if (purple_explosion_ack >= 1'd1) purple_explosion_flag <= 1'd0;
     else if (play == 1'd1||menu==1'd1) begin                             
                player_screen <= 2'b0;                                  
                red_score <= 1'd0;
					 y_tank3 <= 9'd3;   
					 x_tank3 <= 10'd604;
              end
    else  begin
                
   
            case (purpletank_orient)
           
            ICON_UP:   
            if ((y == y_tank3) && (x == x_tank3)) 
                    begin
                        purpleup_addr <=10'd0;                           
                        purple_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && 
                    (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
                       begin            
                               first_screen_out <= purpleup_dataOut;    
                               purpleup_addr <= purpleup_addr + 1'd1;     
                       end
            
            else begin 
                    purpleup_addr <= purpleup_addr + 10'd0;               
                    purple_explosion_addr <= purple_explosion_addr;
                 end
            ICON_DOWN:
              if ((y == y_tank3) && (x == x_tank3))
                    begin
                     purpleup_addr <=10'd1023;                           
                    purple_explosion_addr <= 10'd0;
                    end                
             else if ((y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && 
                    (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
                       begin 
                                first_screen_out <= purpleup_dataOut;        
                                purpleup_addr <= purpleup_addr - 1'd1;        
                               
                       end
             
            else begin 
                   purpleup_addr <= purpleup_addr + 10'd0;                    
                   purple_explosion_addr <= purple_explosion_addr;
                end
            ICON_LEFT:   
             if ((y == y_tank3) && (x == x_tank3)) 
                    begin
                        purpleleft_addr <=10'd0;                                  
                        purple_explosion_addr <= 10'd0;
                        end                  
             
             else if ((y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && 
                    (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
                       begin            
                               first_screen_out <= purpleleft_dataOut;                   
                               purpleleft_addr <= purpleleft_addr + 1'd1;
                       end
            
            else 
                begin
                    purpleleft_addr <= purpleleft_addr + 10'd0;                    
                   purple_explosion_addr <= purple_explosion_addr;
                 end            
            ICON_RIGHT:
             if ((y == y_tank3) && (x == x_tank3))
                begin
                    purpleleft_addr <=10'd1023;                                   
                    purple_explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && 
                    (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
                       begin   
                               first_screen_out <= purpleleft_dataOut;           
                               purpleleft_addr <= purpleleft_addr - 1'd1;
                       end
                    
            else begin
                   purpleleft_addr <= purpleleft_addr + 10'd0;                    
                  purple_explosion_addr <= purple_explosion_addr;
                end
				default:if ((y == y_tank3) && (x == x_tank3)) 
                    begin
                        purpleup_addr <=10'd0;                           
                        purple_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank3 ) && ( y <= (y_tank3 + 10'd31)) && 
                    (x >= x_tank3 ) && ( x <= (x_tank3 + 10'd31)))
                       begin            
                               first_screen_out <= purpleup_dataOut;    
                               purpleup_addr <= purpleup_addr + 1'd1;     
                       end
            
            else begin 
                    purpleup_addr <= purpleup_addr + 10'd0;               
                    purple_explosion_addr <= purple_explosion_addr;
                 end
            endcase    
    end
///////////////////////////////////////////////////////////////////////////////
if ((y_bullet1 < 1) || (y_bullet1 > 490) || (x_bullet1 < 1) || (x_bullet1 > 650))
		red_bullet_act<=1'b0;
		
		else if (red_bullet_act == 1'd1)
        begin
            case (red_bullet_orient)
           
                ICON_UP:   
                    if ((y == y_tank2) && (x == x_tank2)) bullet_up_addr <= 7'd120;    
                    else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd14)) && 
                    (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd7)))
                       begin            
                           first_screen_out <= bullet_up_dataOut;                       
                           bullet_up_addr <= bullet_up_addr - 1'd1;
                       end
                    else bullet_up_addr <= bullet_up_addr + 7'd0;                      
                
                ICON_DOWN:   
                    if ((y == y_tank2) && (x == x_tank2)) bullet_up_addr <= 7'd0;          
                    else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd14)) && 
                        (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd7)))
                           begin            
                               first_screen_out <= bullet_up_dataOut;                   
                               bullet_up_addr <= bullet_up_addr + 1'd1;
                           end
                    else bullet_up_addr <= bullet_up_addr + 7'd0;                       
                
                ICON_LEFT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd120;     
                 else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd7)) && 
                    (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     
                           bullet_left_addr <= bullet_left_addr - 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 7'd0;                      
                
                ICON_RIGHT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd0;       
                 else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd7)) && 
                    (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     
                           bullet_left_addr <= bullet_left_addr + 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 7'd0;                      
            endcase
        end
    else begin
            bullet_left_addr <= bullet_left_addr;                                       
            bullet_up_addr <= bullet_up_addr ;
        end   

////////////////////////////////////////////////////////////////////////////////////////////////////////
	if ((y_bullet2 < 1) || (y_bullet2 > 490) || (x_bullet2 < 1) || (x_bullet2 > 650))
		green_bullet_act<=1'b0;
	else if (green_bullet_act == 1'd1)
		begin
                    case (green_bullet_orient)
                   
                        ICON_UP:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_down_addr <= 7'd120;    
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd14)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;                                 
                                   bullet_down_addr <= bullet_down_addr - 1'd1;
                               end
                        else bullet_down_addr <= bullet_down_addr + 7'd0;                        
                        
                        ICON_DOWN:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_down_addr <= 7'd0;      
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd14)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;
                                   bullet_down_addr <= bullet_down_addr + 1'd1;                
                               end
                        else bullet_down_addr <= bullet_down_addr + 7'd0;               
                        
                        ICON_LEFT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd120;        
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd7)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                    
                                   bullet_right_addr <= bullet_right_addr - 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr;                                        
                        
                        ICON_RIGHT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd0;          
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd7)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                    
                                   bullet_right_addr <= bullet_right_addr + 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr + 7'd0;                            
    
                    endcase
                end
            else begin
                    bullet_right_addr <= bullet_right_addr;                                                 
                    bullet_down_addr <=bullet_down_addr ;
                end
/////////////////////////////////////////////////////////////////////////////////////////////////
if ((y_bullet3 < 1) || (y_bullet3 > 490) || (x_bullet3 < 1) || (x_bullet3 > 650))
		purple_bullet_act<=1'b0;
	else if (purple_bullet_act == 1'd1)
		begin
                    case (purple_bullet_orient)
                   
                        ICON_UP:   
                         if ((y == y_tank2) && (x == x_tank2)) purplebullet_up_addr <= 7'd0;    
                         else if ((y >= y_bullet3 ) && ( y <= (y_bullet3 + 10'd14)) && 
                            (x >= x_bullet3 ) && ( x <= (x_bullet3 + 10'd7)))
                               begin            
                                   first_screen_out <= purplebullet_up_dataOut;                                 
                                   purplebullet_up_addr <= purplebullet_up_addr + 1'd1;
                               end
                        else purplebullet_up_addr <= purplebullet_up_addr + 7'd0;                        
                        
                        ICON_DOWN:   
                         if ((y == y_tank2) && (x == x_tank2)) purplebullet_up_addr <= 7'd120;      
                         else if ((y >= y_bullet3 ) && ( y <= (y_bullet3 + 10'd14)) && 
                            (x >= x_bullet3 ) && ( x <= (x_bullet3 + 10'd7)))
                               begin            
                                   first_screen_out <= purplebullet_up_dataOut;
                                   purplebullet_up_addr <= purplebullet_up_addr - 1'd1;                
                               end
                        else bullet_down_addr <= bullet_down_addr + 7'd0;               
                        
                        ICON_LEFT:   
                         if ((y == y_tank2) && (x == x_tank2)) purplebullet_left_addr <= 7'd0;        
                         else if ((y >= y_bullet3 ) && ( y <= (y_bullet3 + 10'd7)) && 
                            (x >= x_bullet3 ) && ( x <= (x_bullet3 + 10'd14)))
                               begin            
                                   first_screen_out <= purplebullet_left_dataOut ;                    
                                   purplebullet_left_addr  <= purplebullet_left_addr  + 1'd1;
                               end
                        else purplebullet_left_addr  <= purplebullet_left_addr ;                                        
                        
                        ICON_RIGHT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd120;          
                         else if ((y >= y_bullet3 ) && ( y <= (y_bullet3 + 10'd7)) && 
                            (x >= x_bullet3 ) && ( x <= (x_bullet3 + 10'd14)))
                               begin            
                                   first_screen_out <= purplebullet_left_dataOut;                    
                                   purplebullet_left_addr  <= purplebullet_left_addr  - 1'd1;
                               end
                        else purplebullet_left_addr  <= purplebullet_left_addr  + 7'd0;                            
    
                    endcase
                end
            else begin
                    purplebullet_left_addr  <= purplebullet_left_addr ;                                                 
                    purplebullet_up_addr  <=purplebullet_up_addr  ;
                end


end


endmodule