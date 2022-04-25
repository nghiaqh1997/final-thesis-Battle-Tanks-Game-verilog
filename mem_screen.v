module mem_screen(row,column,mem_scr_data);

input [9:0] row,column;
reg  [7:0] mem_data[51199:0];
output [7:0] mem_scr_data;
wire [15:0] addr;
assign addr = row*640 + column;

initial
begin

$readmemh("mem_screen.mif",mem_data,0,51199);

end

assign mem_scr_data =(row < 80)? mem_data[addr]:8'h00;

endmodule
