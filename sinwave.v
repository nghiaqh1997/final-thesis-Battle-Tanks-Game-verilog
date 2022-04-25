module sinwave_gen (clock_ref, dacclk, bclk, dacdat, reset_n,clk50,rdclk,fifo_rd_dat);
input clock_ref;//wm8731 input clock, 18.432Mhz;
input reset_n; 
output dacclk; 
output dacdat;
output bclk;
input clk50;
reg dacclk;
input [15:0]fifo_rd_dat;
output reg rdclk;
reg bclk;
reg [15:0] bclk_cnt;

wire [15:0] sin_out;
reg [15:0] sin_index;
reg [3:0] counter_bclk;
reg [3:0] counter_fifo;

always@(*)rdclk<=dacclk;
always @ (posedge clock_ref or negedge reset_n)//Produce 16-bit data transmission clock, 32 times of sine wave sampling clock
begin
if (! reset_n)
begin
bclk <= 0;
bclk_cnt <= 0;
end
else if (bclk_cnt>= 35)
begin
bclk <= ~ bclk;
bclk_cnt <= 0;
end
else
bclk_cnt <= bclk_cnt + 1'b1;
end

always @ (negedge bclk or negedge reset_n)
begin
	if(!reset_n)
		begin
			counter_bclk<=1'b0;
			dacclk<=1'b0;
		end
	else if (counter_bclk==15)
		begin
			counter_bclk<=1'b0;
			dacclk<=~dacclk;
		end
	else
		begin
			counter_bclk<=counter_bclk+1'b1;
		end
end
			


always @ (posedge dacclk or negedge reset_n)
begin
if (! reset_n)
sin_index <= 0;
else if (sin_index <47)
sin_index <= sin_index + 1'b1;
else
sin_index <= 0;
end

assign dacdat = fifo_rd_dat [~ counter_bclk];//Generate DA converter digital audio data
/*
rom r1(
	sin_index,
	clk,
	sin_out);*/
endmodule