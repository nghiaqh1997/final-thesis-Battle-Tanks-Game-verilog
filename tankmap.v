module tankmap(CLOCK_50,VGA_HS,VGA_VS,VGA_BLANK,VGA_SYNC,VGA_R,VGA_G,VGA_B,
		PS2_CLK,                   
		PS2_DAT,
		SD_CLK,
 SD_CMD,
 SD_DAT,
 SD_DAT3,
 KEY,
 CLOCK_27,
 I2C_SCLK,
 I2C_SDAT,
AUD_DACLRCK,
 AUD_DACDAT,
 AUD_XCK,
 AUD_BCLK,
 SW
		
);
output SD_CLK,SD_CMD,SD_DAT3;
input SD_DAT;
output I2C_SCLK,AUD_BCLK,AUD_DACDAT,AUD_DACLRCK,AUD_XCK;
input [3:0]KEY;
input [1:0]CLOCK_27;
inout I2C_SDAT;
input CLOCK_50,PS2_CLK,PS2_DAT;
input [9:0] SW;
output  VGA_HS,VGA_VS;
output  VGA_BLANK,VGA_SYNC;
output [3:0] VGA_R,VGA_G,VGA_B;

wire [9:0] column;
wire [8:0] row;
wire disp_ena,clk25;
//wire reset0;
//assign reset0 = !KEY[1];
frequency_divider_by2 f0(CLOCK_50,clk25);
vga_640x480 vga0(.clk25(clk25),.reset(reset),.hcs(column),.vcs(row),.hsync(VGA_HS),.vsync(VGA_VS),
.disp_ena(disp_ena),.n_blank(VGA_BLANK),.n_sync(VGA_SYNC));


/////////////////////////////COLOUR///////////////////////////////////////////
wire [3:0] red,green,blue;
colorization c1(clk25,reset,disp_ena,first_screen_out,game_screen,game_screen2,player_screen,color_out,win_out1,win_out2,menu,play1,play2,player_screen2,lose_out1,music1,music2);
assign VGA_R=color_out[11:8];
assign VGA_G=color_out[7:4];
assign VGA_B=color_out[3:0];
////////////////////////////////////////KEYBOARD///////////////////////////////////
wire menu, play1, play2, up1, down1, left1, right1, fire1,up2, down2, left2, right2, fire2;
keyboard k1(
		CLOCK_50,
		PS2_CLK,
		PS2_DAT,
		menu, play1, play2,
		up1, down1, left1, right1, fire1,        
		up2, down2, left2, right2, fire2         
    );

wire [4:0]player1,player2; 
assign player1={fire1,left1,up1,right1,down1};
assign player2={fire2,left2,up2,right2,down2};
game_screen g1(game_screen,y,x,CLOCK_50,clk25,reset,player1,player2,player_screen,
                   play1,menu,mapselect);
wire [1:0]player_screen,player_screen2;
wire reset_screen;
wire [11:0]game_screen,game_screen2;
assign x=column;
assign y=row;
wire [9:0]x;
wire [8:0]y;
game_screen2 g2(game_screen2,x,y,clk25,reset,player1,play1,menu,mapselect2,player_screen2,music2);

first_screen first(first_screen_out,x,y,clk25,reset);
wire [11:0]first_screen_out;

player1 p1(win_out1,x,y,clk25,reset);
wire [11:0]win_out1;
wire [11:0]win_out2;
player2 p2(win_out2,x,y,clk25,reset);
wire [11:0]color_out;
wire [1:0]mapselect,mapselect2;
assign mapselect=SW[2:1];
assign mapselect2=SW[4:3];
wire [11:0]lose_out1;
lose_screen l1(lose_out1,x,y,clk25,reset);

sd_controller(
     SD_DAT3, // Connect to SD_DAT[3].
     SD_CMD, // Connect to SD_CMD.
     SD_DAT, // Connect to SD_DAT[0].
     SD_CLK, // Connect to SD_SCK.
     rd,   
      dout, 
     !KEY[1], 
      address,   
     clk25,  
      status,
		 rdclk,
	  fifo_rd_dat,
	  usedw,
	  address_end,
	  SW[7]
	  
	  
);
wire [1:0]music_select;
assign music_select = SW[9:8];
wire rd;
always@(*)begin
address <= 1'b0;
address_end<=1'b0;
	case(music_select)
		2'b00: begin address <= 32'd512000; address_end <= 32'd4095488; end
		2'b01: begin address <= 32'd5120000; address_end <= 32'd9050112;  end
		2'b11: begin address <= 32'd10240000;address_end <= 32'd16122368; end
	endcase
end
wire music1,music2;
//assign rd=(usedw < (1024-256-20))?1:0;
assign rd = (music1||music2)?(usedw<(1024-256-20))?1:0:0;
//assign rd=SW[1];
wire [15:0]dout;
reg [31:0]address,address_end;
wire [4:0]status;
wire [15:0]fifo_rd_dat;
wire [10:0]usedw;
wire rdclk;
sinwave_gen s1(AUD_XCK, AUD_DACLRCK, AUD_BCLK, AUD_DACDAT, KEY[1],CLOCK_50,rdclk,fifo_rd_dat);
reg_config r2(
CLOCK_50,
I2C_SCLK,
I2C_SDAT,
KEY[1]);

audio_pll a1(
CLOCK_27[1],
AUD_XCK);
reset_delay (CLOCK_50, reset);
endmodule
