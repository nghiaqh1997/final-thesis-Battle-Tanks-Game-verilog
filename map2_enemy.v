module map2_enemy(data,read,write,we,read_clk,write_clk,q,read1,q1);
input [DATA_WIDTH-1:0]data;
input [ADDR_WIDTH-1:0]read;
input [ADDR_WIDTH-1:0]write;
input we;
input read_clk,write_clk;
output reg [DATA_WIDTH-1:0] q;
input [ADDR_WIDTH-1:0]read1;

output reg [DATA_WIDTH-1:0] q1;
parameter DATA_WIDTH=3;
parameter ADDR_WIDTH=15;
initial
begin
//add icon for mouse here
$readmemb("map2_enemy.mif",ram,0,191);//mouse icon

end
reg [DATA_WIDTH-1:0]ram[191:0];
always@(posedge write_clk)begin
	if(we)
		ram[write]<=data;
end
always@(*)begin
	q=ram[read];
end
//always@(*)begin
//	if(we)
//		ram[write1]<=data;
//end
always@(*)begin
	q1=ram[read1];
end

endmodule
