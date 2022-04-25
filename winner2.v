module winner2(addr,m_icon_data);


reg  [7:0] m_mem_data[19199:0]; 
output  [7:0] m_icon_data;
input [14:0] addr ;



initial
begin
//add icon for mouse here
$readmemh("win2.mif",m_mem_data,0,19199);//mouse icon

end
//select icon
//assign m_icon_data = (m_mem_data[addr] == 8'hff)?2'b11:(m_mem_data[addr] == 8'h00)?2'b10:0;
assign m_icon_data = m_mem_data[addr];
endmodule