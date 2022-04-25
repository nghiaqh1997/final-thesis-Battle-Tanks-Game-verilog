module brickbullet(x_tank,y_tank,clk,reset,stop1,write,we,data,x_bullet1,y_bullet1,stop2);
input [9:0]x_tank,x_bullet1;
input [8:0]y_tank,y_bullet1;
output reg stop1,stop2;
input clk,reset;
reg [9:0]ax,bx,cx,dx,ay,by,cy,dy;
reg [9:0]goca,gocb,gocc,gocd;
reg [9:0]ax3,bx3,cx3,dx3,ay3,by3,cy3,dy3;
reg [9:0]goca3,gocb3,gocc3,gocd3;
output reg we;
output reg data;
output reg [10:0]write;
always@(*)
begin
	ax=x_tank/40;
	ay=y_tank/40;
	bx=(x_tank+10'd14)/40;
	by=y_tank/40;
	cx=(x_tank+10'd14)/40;
	cy=(y_tank+10'd14)/40;
	dx=x_tank/40;
	dy=(y_tank+10'd14)/40;
	goca=ay*16+ax;
	gocb=by*16+bx;
	gocc=cy*16+cx;
	gocd=dy*16+dx;
	
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
	
end
always@(posedge clk)
begin
	if(reset)
		state<=ready;
	else
		state<=next_state;
end
parameter ready=1,UP=2,DOWN=3,LEFT=4,RIGHT=5,
						UP1=6,DOWN1=7,LEFT1=8,RIGHT1=9;
 map m4(data,read,write,we,clk,clk,q,read1,q1);
 reg [10:0]read1,read;
 wire q1,q;
 reg [3:0]state,next_state;
 
always@(*)
begin
	case(state)
		ready:next_state=(reset==0)?UP:ready;
		UP:next_state=UP1;
		UP1:next_state=LEFT;
		LEFT:next_state=LEFT1;
		LEFT1:next_state=RIGHT;
		LEFT1:next_state=RIGHT;
		RIGHT:next_state=RIGHT1;
		RIGHT1:next_state=DOWN;
		DOWN:next_state=DOWN1;
		DOWN1:next_state=UP;
	endcase
end
always@(*)
begin
	read1=10'd191;
	stop1=1'b0;
	stop2=1'b0;
	case(state)
		ready:
			read1=10'd191;
			
		UP:begin
			read1=goca;
			if(q1==1'b1)begin stop1=1'b1; we=1'b1; data=1'b0; write=goca; end
			else if(q1==1'b0) begin stop1=1'b0; we=1'b0; end
			end
		UP1:begin
			read1=goca3;
			if(q1==1'b1)begin stop2=1'b1; we=1'b1; data=1'b0; write=goca3; end
			else if(q1==1'b0) begin stop2=1'b0; we=1'b0; end
			end
		DOWN:begin
			read1=gocc;
			if(q1==1'b1)begin stop1=1'b1; we=1'b1; data=1'b0; write=gocc; end
			else if(q1==1'b0) begin stop1=1'b0; we=1'b0; end
			end
		DOWN1:begin
			read1=gocc3;
			if(q1==1'b1)begin stop2=1'b1; we=1'b1; data=1'b0; write=gocc3; end
			else if(q1==1'b0) begin stop2=1'b0; we=1'b0; end
			end
		LEFT:begin
			read1=gocd;
			if(q1==1'b1)begin stop1=1'b1; we=1'b1; data=1'b0; write=gocd; end
			else if(q1==1'b0) begin stop1=1'b0; we=1'b0; end
			end
		LEFT1:begin
			read1=gocd3;
			if(q1==1'b1)begin stop2=1'b1; we=1'b1; data=1'b0; write=gocd3; end
			else if(q1==1'b0) begin stop2=1'b0; we=1'b0; end
			end
		RIGHT:begin
			read1=gocb;
			if(q1==1'b1)begin stop1=1'b1; we=1'b1; data=1'b0; write=gocb; end
			else if(q1==1'b0) begin stop1=1'b0; we=1'b0; end
			end
		RIGHT1:begin
			read1=gocb3;
			if(q1==1'b1)begin stop2=1'b1; we=1'b1; data=1'b0; write=gocb3; end
			else if(q1==1'b0) begin stop2=1'b0; we=1'b0; end
			end
	endcase
end

endmodule