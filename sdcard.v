module sdcard(
output SD_CLK,
output SD_CMD,
input SD_DAT,
output SD_DAT3,
input CLOCK_50,
input [1:0]KEY,

output [9:0]LEDR,
output [7:0]LEDG,
output [6:0]HEX1,
output [6:0]HEX2,
output [6:0]HEX3,
output [6:0]HEX0,
input [1:0]CLOCK_27,
output I2C_SCLK,
inout I2C_SDAT,
output AUD_DACLRCK,
output AUD_DACDAT,
output AUD_XCK,
output AUD_BCLK,
input [9:0]SW);


sd_controller(
     SD_DAT3, // Connect to SD_DAT[3].
     SD_CMD, // Connect to SD_CMD.
     SD_DAT, // Connect to SD_DAT[0].
     SD_CLK, // Connect to SD_SCK.
     rd,   
      dout, 
     SW[0], 
      address,   
     clk25,  
      status,
		 rdclk,
	  fifo_rd_dat,
	  usedw,
	  address_end,
	  SW[2]
	  
	  
);
wire [1:0]music_select;
assign music_select = SW[9:8];
wire rd;
always@(*)begin
address <= 1'b0;
	case(music_select)
		2'b00: begin address <= 32'd512000; address_end = 32'd4095488; end
		2'b01: begin address <= 32'd5120000; address_end = 32'd9050112;  end
		2'b11: begin address <= 32'd10240000;address_end = 32'd16122368; end
	endcase
end
//assign rd=(usedw < (1024-256-20))?1:0;
assign rd = (SW[1])?(usedw<(1024-256-20))?1:0:0;
//assign rd=SW[1];
wire [15:0]dout;
reg [31:0]address,address_end;
wire [4:0]status;
assign LEDR = status;
frequency_divider_by2(CLOCK_50,clk25);
wire clk25;
segment7 b1(fifo_rd_dat[3:0], HEX0);
segment7 b2(fifo_rd_dat[7:4], HEX1);
segment7 b3(fifo_rd_dat[11:8], HEX2);
segment7 b4(fifo_rd_dat[15:12], HEX3);
wire [15:0]fifo_rd_dat;
wire [10:0]usedw;
wire rdclk;
sinwave_gen s1(AUD_XCK, AUD_DACLRCK, AUD_BCLK, AUD_DACDAT, KEY[0],CLOCK_50,rdclk,fifo_rd_dat);
reg_config r2(
CLOCK_50,
I2C_SCLK,
I2C_SDAT,
KEY[0]);

audio_pll a1(
CLOCK_27[0],
AUD_XCK);

endmodule