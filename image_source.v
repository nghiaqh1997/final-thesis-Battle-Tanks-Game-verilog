module image_source(clk25,disp_ena,row,column,red,green,blue,rgb12,SW);
input [1:0]SW;
input disp_ena;
input clk25;
input [9:0]row,column;
wire [7:0] m_icon_data;
//output reg [9:0] red,green,blue;
output reg [3:0] red,green,blue;


//input [29:0] rgb30,chosen_color30;
input [11:0] rgb12;

always @(posedge clk25)
begin
	     		//display time
	
	//x <=  ((column + 1)%40 == 0)?((column + 1)%40):x;
	//y <= ((row +1)%40 == 0)?((row +1)%40):y;
    if(row >= 0 && row <= 479 && column >= 0 && column <= 639)
			begin
			//if(addr_x < 39)
			//addr_x <= addr_x + 1;
			//else
			//	begin
			//	addr_x <= 0;
			//	if(addr_y < 39)
			//	addr_y <= addr_y + 1;
			//	else 
			//	addr_y <= 0;
			//	end
			if(mapdata)
				begin
				red   <= {m_icon_data[7:5],1'b0} ;
				green <= {m_icon_data[4:2],1'b0} ;
				blue  <= {m_icon_data[1:0],2'b0};
				end
			else
				begin
				red   <= 0;
				green <= 0;
				blue  <= 0;
				end
			end
		else
		begin
		//addr_x <= 0;
		//addr_y <= 0;
		red   <= 4'd0;
		green <= 4'd0;
		blue  <= 4'd0;
	 
		end
	
	 

end
/*always @(row,column)
begin
if((row == line_x) && (column == line_y))
begin
read_address = read_address +1;
if (data[read_address])
	if (line_direct[0] == 0)
	line_x <= line_x + 1;
	else
	line_x <= line_x - 1;
else
	if (line_direct[1] == 0)
	line_y <= line_y + 1;
	else
	line_y <= line_y - 1;
end
end
*/
always @(posedge clk25)
begin
if(column == 799|| column == 39||column == 79||column == 119||column == 159||column == 200
||column == 240||column == 280||column == 320||column == 360||column == 400
||column == 440||column == 480||column == 520||column == 560||column == 600
||column == 640||column == 680||column == 760
)

addr_x <= 0;
else
addr_x <= addr_x + 1;

if( row == 0||row == 40||row == 80||row == 120||row == 160||row == 200||row == 240
||row == 280||row == 320||row == 360||row == 400||row == 440||row == 480
)
addr_y <= 0;
else
if(column == 641)
addr_y <= addr_y + 1;
else
addr_y <= addr_y;



//if(row >= 0 && row <= 479 && column >= 0 && column <= 639)
//			if(addr_x < 39)
//			addr_x <= addr_x + 1;
//			else
//				begin
//				addr_x <= 0;
//				if(addr_y < 39)
//				addr_y <= addr_y + 1;
//				else 
//				addr_y <= 0;
//				end
//else
//addr_x <= 0;
end
wire [4:0] a,b;
//assign a = (column + 1)%40;
//assign b = (row +1)%40;
wire [4:0]x,y;

assign	y=row/40;
assign	x=column/40;
		
		

//reg [4:0] x,y;
reg [5:0] addr_x = 0,addr_y = 0;//40

wire [10:0] addr;
assign  addr = addr_y*40 + addr_x;
mouse_icon icon0(.addr(addr),.m_icon_data(m_icon_data));

//map
wire [15:0]mapaddr;
assign mapaddr = y*16 + x;// 16x12
map(data,mapaddr,write,we,clk25,clk25,mapdata);//16x12
reg we=0;

reg data;
reg [4:0]write;

/*always@(posedge clk25)
begin
	if(SW[1]==1'b1)
		begin	
			write=5'd3;
			data=0;
			we=1;
		end
	else we=0;
end*/
	
	

endmodule
