module autofire (clk,reset,fire);
input clk,reset;
output reg fire;
reg [27:0]fire_count;
parameter integer FIRE_CNT=12000000;
always@(posedge clk)begin
	if (reset)begin
		fire_count<=1'b0;
		fire <=1'b0;
		end
	else if (fire_count==FIRE_CNT)begin
		fire<=1'b1;
		fire_count<=1'b0;
		end
	else if (fire==1'b1)
		fire<=1'b0;
	else fire_count<=fire_count+1'd1;
end
endmodule

	
