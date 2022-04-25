module i2c_com (clock_i2c,//wm8731 control interface transmission required clock, 0-400khz, here is 20khz
reset_n, 
ack,//Answer signal
i2c_data,//24-bit data transmitted by sdin interface
start,//Start transmission flag
tr_end,//Transmission end flag
cyc_count, 
i2c_sclk,//FPGA and wm8731 clock interface
i2c_sdat);//FPGA and wm8731 data interface
input [23: 0] i2c_data;
input reset_n;
input clock_i2c;
output [5: 0] cyc_count;
output ack;
input start;
output tr_end;
output i2c_sclk;
inout i2c_sdat;
reg [5: 0] cyc_count;
reg reg_sdat;
reg sclk;
reg ack1, ack2, ack3;
reg tr_end;


wire i2c_sclk;
wire i2c_sdat;
wire ack;

assign ack = ack1 | ack2 | ack3;
assign i2c_sclk = sclk | (((cyc_count>= 4) & (cyc_count <= 30))? ~ clock_i2c: 0);
assign i2c_sdat = reg_sdat? 1'bz: 0;


always @ (posedge clock_i2c or negedge reset_n)
begin
if (! reset_n)
cyc_count <= 6'b111111;
else begin
if (start == 0)
cyc_count <= 0;
else if (cyc_count <6'b111111)
cyc_count <= cyc_count + 1'b1;
end
end
always @ (posedge clock_i2c or negedge reset_n)
begin
if (! reset_n)
begin
tr_end <= 0;
ack1 <= 1;
ack2 <= 1;
ack3 <= 1;
sclk <= 1;
reg_sdat <= 1;
end
else
case (cyc_count)
0: begin ack1 <= 1; ack2 <= 1; ack3 <= 1; tr_end <= 0; sclk <= 1; reg_sdat <= 1; end
1: reg_sdat <= 0;//Start transmission
2: sclk <= 0;
3: reg_sdat <= i2c_data [23];
4: reg_sdat <= i2c_data [22];
5: reg_sdat <= i2c_data [21];
6: reg_sdat <= i2c_data [20];
7: reg_sdat <= i2c_data [19];
8: reg_sdat <= i2c_data [18];
9: reg_sdat <= i2c_data [17];
10: reg_sdat <= i2c_data [16];
11: reg_sdat <= 1;//Response signal

12: begin reg_sdat <= i2c_data [15]; ack1 <= i2c_sdat; end
13: reg_sdat <= i2c_data [14];
14: reg_sdat <= i2c_data [13];
15: reg_sdat <= i2c_data [12];
16: reg_sdat <= i2c_data [11];
17: reg_sdat <= i2c_data [10];
18: reg_sdat <= i2c_data [9];
19: reg_sdat <= i2c_data [8];
20: reg_sdat <= 1;//Response signal

21: begin reg_sdat <= i2c_data [7]; ack2 <= i2c_sdat; end
22: reg_sdat <= i2c_data [6];
23: reg_sdat <= i2c_data [5];
24: reg_sdat <= i2c_data [4];
25: reg_sdat <= i2c_data [3];
26: reg_sdat <= i2c_data [2];
27: reg_sdat <= i2c_data [1];
28: reg_sdat <= i2c_data [0];
29: reg_sdat <= 1;//Answer signal

30: begin ack3 <= i2c_sdat; sclk <= 0; reg_sdat <= 0; end
31: sclk <= 1;
32: begin reg_sdat <= 1; tr_end <= 1; end
endcase

end
endmodule