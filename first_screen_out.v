module first_screen(first_screen_out,x,y,clk,reset);
input clk;
input [9:0]x;
input [8:0]y;
input reset;

output  [11:0]first_screen_out;
wire [16:0]addr;
wire [7:0]dataout;
wire [7:0]col;
wire [6:0]row;
assign row=y[8:2];
assign col=x[9:2];
screen s1(addr,dataout);
wire [11:0]dataout1;
assign addr=row*160+col;
assign first_screen_out = {dataout[7:5],1'b0,dataout[4:2],1'b0,dataout[1:0],2'b0};
endmodule