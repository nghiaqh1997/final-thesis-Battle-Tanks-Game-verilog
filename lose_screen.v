module lose_screen(win_out1,x,y,clk,reset);
input reset,clk;
input [9:0]x;
input [8:0]y;
output [11:0]win_out1;
wire [14:0]addr;
wire [7:0]dataout;
wire [7:0]col;
wire [6:0]row;
assign row=y[8:2];
assign col=x[9:2];
lose w1(addr,dataout);
//assign addr=row*320+col;
assign addr=row*160+col;
assign win_out1 = {dataout[7:5],1'b0,dataout[4:2],1'b0,dataout[1:0],2'b0};


endmodule