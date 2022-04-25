module player2(win_out2,x,y,clk,reset);
input reset,clk;
input [9:0]x;
input [8:0]y;
output [11:0]win_out2;
wire [14:0]addr;
wire [7:0]dataout;
wire [7:0]col;
wire [6:0]row;
assign row=y[8:2];
assign col=x[9:2];
winner2 w1(addr,dataout);
assign addr=row*160+col;
//assign addr=y*640+x;
assign win_out2 = {dataout[7:5],1'b0,dataout[4:2],1'b0,dataout[1:0],2'b0};
//first_screen_out<={m_icon_data[7:5],1'b0,m_icon_data[4:2],1'b0,m_icon_data[1:0],2'b0};

endmodule