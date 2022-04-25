module reg_config (clock_50m,
i2c_sclk,
i2c_sdat,
reset_n);
input clock_50m;
input reset_n;
output i2c_sclk;
inout i2c_sdat;

reg clock_20k;
reg [15: 0] clock_20k_cnt;
reg [1: 0] config_step;
reg [3: 0] reg_index;
reg [23: 0] i2c_data;
reg [15: 0] reg_data;
reg start;
wire ack;
wire tr_end;
i2c_com u1 (.clock_i2c (clock_20k),
.reset_n (reset_n),
.ack (ack),
.i2c_data (i2c_data),
.start (start),
.tr_end (tr_end),
.i2c_sclk (i2c_sclk),
.i2c_sdat (i2c_sdat));

always @ (posedge clock_50m or negedge reset_n)//Generate i2c control clock-20khz
begin
if (! reset_n)
begin
clock_20k <= 1'b0;
clock_20k_cnt <= 1'b0;
end
else if (clock_20k_cnt <15'd1249)
clock_20k_cnt <= clock_20k_cnt + 1'b1;
else
begin
clock_20k <=! clock_20k;
clock_20k_cnt <= 1'b0;
end
end

always @ (posedge clock_20k or negedge reset_n)//Configure process control
begin
if (! reset_n)
begin
config_step <= 0;
start <= 0;
reg_index <= 0;
end
else
	begin
		if (reg_index <10)
			begin
				case (config_step)
					0: begin
							i2c_data <= {8'h34, reg_data};
							start <= 1;
							config_step <= 1;
						end
					1: begin
							if (tr_end)
								begin
									if (! ack)
										config_step <= 2;
									else begin
										config_step <= 0;
								start <= 0;
								end
								end
						end
					2: begin
							reg_index <= reg_index + 1;
							config_step <= 0;
						end
				endcase
			end
	end
end
always @ (reg_index) 
begin
case (reg_index)
0: reg_data <= 16'h001f;
1: reg_data <= 16'h021f;
2: reg_data <= 16'b0000010001111001;//left out
3: reg_data <= 16'b0000011001111001;//right out
4: reg_data <= 16'h08f8;
//5: reg_data <= 16'h0a06;
5: reg_data <= 16'h0a00;
6: reg_data <= 16'h0c00;
7: reg_data <= 16'h0e01;
//8: reg_data <= 16'h1002;//
8: reg_data <= 16'h1006;//8kz normal
9: reg_data <= 16'h1201;//active
default: reg_data <= 16'h001a;
endcase
end
endmodule