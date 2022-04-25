module controller_fifo(clk,reset,usedw,read_ena,fifo_rd_dat,fifo_rd_dat3,fifo_rd_ena);
input clk;
input reset;
input [10:0]usedw;
output reg read_ena;
input fifo_rd_ena;
reg [15:0] fifo_rd_dat2;
output reg [15:0] fifo_rd_dat3;
input [7:0] fifo_rd_dat;
reg [26:0]counter_read_ena;

always @(posedge clk)
begin
	if(reset)
		begin
		read_ena <= 1'b0;
		counter_read_ena <= 1'b0;
		end
	else if (usedw >= 512)
		read_ena <= 1'b0;
	else if (read_ena)
		read_ena <= 1'b0;
	else if(counter_read_ena >= 200000)
		begin
			read_ena <= 1;
			counter_read_ena<=1'b0;
		end
	else
		counter_read_ena <= counter_read_ena + 8'd1;
end
reg [1:0]counter;
reg [2:0]state;
always@(fifo_rd_ena)
begin
	if(reset)
		begin
			counter<=1'b0;
			fifo_rd_dat2<=1'b0;
			state<=2'd1;
			fifo_rd_dat2[7:0]<=fifo_rd_dat[7:0];
		end
	else 
		begin
			case(state)
				0:
					begin
						fifo_rd_dat2[7:0]<=fifo_rd_dat[7:0];
						state<=1'b1;
					end
				1:
					begin
						fifo_rd_dat2[15:8]<=fifo_rd_dat2[7:0];
						fifo_rd_dat2[7:0] <=fifo_rd_dat[7:0];
						state<=2'd2;
					end
				2:
					begin
						fifo_rd_dat3[15:0]<=fifo_rd_dat2[15:0];
						fifo_rd_dat2[7:0]<=fifo_rd_dat[7:0];
						fifo_rd_dat2[15:8]<=fifo_rd_dat2[7:0];
						state<=2'd2;
					end
			endcase
		end
				
end
endmodule

