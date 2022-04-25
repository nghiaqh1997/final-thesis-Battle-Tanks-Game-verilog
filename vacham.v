module vacham(x_tank1,y_tank1,clk25,reset,red_stop,we,write,data);
input [9:0]x_tank1;
input [8:0]y_tank1;
output reg red_stop;
input clk25,reset;
reg [9:0]ax1,bx1,cx1,dx1,ay1,by1,cy1,dy1;
reg [9:0]goca1,gocb1,gocc1,gocd1;
input wire [10:0]write;
input wire [1:0]we,data;
always@(*)
begin
	ax1=x_tank1/40;
	ay1=y_tank1/40;
	bx1=(x_tank1+10'd38)/40;
	by1=y_tank1/40;
	cx1=(x_tank1+10'd38)/40;
	cy1=(y_tank1+10'd38)/40;
	dx1=x_tank1/40;
	dy1=(y_tank1+10'd38)/40;
	goca1=ay1*16+ax1;
	gocb1=by1*16+bx1;
	gocc1=cy1*16+cx1;
	gocd1=dy1*16+dx1;
end
always@(posedge clk25)
begin
	if(reset)
		state<=ready;
	else
		state<=next_state;
end
wire data1,we1;
wire [10:0]write1;
assign data1=data;
assign we1=we;
assign write1=write;
parameter ready=1,UP2=2,DOWN2=3,LEFT2=4,RIGHT2=5,
						UP1=6,DOWN1=7,LEFT1=8,RIGHT1=9;
 map m3(data1,read,write1,we1,clk25,clk25,q,read1,q1);
 reg [10:0]read1,read;
 wire q1,q;
 reg [6:0]state,next_state;
 
 
always@(*)
begin
	case(state)
		ready:next_state=(reset==0)?UP2:ready;
		UP2:next_state=UP1;
		UP1:next_state=LEFT2;
		LEFT2:next_state=LEFT1;
		LEFT1:next_state=RIGHT2;
		
		RIGHT2:next_state=RIGHT1;
		RIGHT1:next_state=DOWN2;
		DOWN2:next_state=DOWN1;
		DOWN1:next_state=UP2;
	endcase
end
always@(*)
begin
	read1=10'd191;
	case(state)
		ready:
			read1=10'd191;
			
		UP2:
			read1=goca1;
		UP1:
			read1=gocb1;
		DOWN2:
			read1=gocc1;
		DOWN1:
			read1=gocd1;
		LEFT2:
			read1=goca1;
		LEFT1:
			read1=gocd1;
		RIGHT2:
			read1=gocb1;
		RIGHT1:
			read1=gocc1;
	endcase
end
always@(posedge clk25)
begin
	if(q1==1'b0)red_stop=1'b0;
	else if(q1==1'b1) red_stop=1'b1;
end
endmodule