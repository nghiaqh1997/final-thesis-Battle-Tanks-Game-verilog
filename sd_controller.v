
module sd_controller(
    output reg cs, // Connect to SD_DAT[3].
    output mosi, // Connect to SD_CMD.
    input miso, // Connect to SD_DAT[0].
    output sclk, // Connect to SD_SCK.
    input rd,   
    output reg [15:0] dout, 
    input reset, 
    input [31:0] address,   
    input clk,  
    output [4:0] status, 
	 //fifo
	 input rdclk,
	 output [15:0]fifo_rd_dat,
	 output [10:0]usedw,
	 input [31:0]address_end,
	 input reset_music
	 
);

    parameter RST = 0;
    parameter INIT = 1;
    parameter CMD0 = 2;
    parameter CMD55 = 3;
    parameter CMD41 = 4;
    parameter POLL_CMD = 5;
    
    parameter IDLE = 6;
    parameter READ_BLOCK = 7;
    parameter READ_BLOCK_WAIT = 8;
    parameter READ_BLOCK_DATA = 9;
    parameter READ_BLOCK_CRC = 10;
    parameter SEND_CMD = 11;
    parameter RECEIVE_BYTE_WAIT = 12;
    parameter RECEIVE_BYTE = 13;
    parameter RECEIVE_BYTE2 = 14;
    reg [31:0]address_;
    reg [4:0] state = RST;
    assign status = state;
    reg [4:0] return_state;
    reg sclk_sig = 0;
    reg [55:0] cmd_out;
    reg [7:0] recv_data;
	 reg [15:0] recv_data2;
    reg cmd_mode = 1;
    reg [7:0] data_sig = 8'hFF;
    reg byte_available;
    reg [9:0] byte_counter;
    reg [9:0] bit_counter;
    
    reg [26:0] boot_counter = 27'd25_000_000;
    always @(posedge clk) begin
        if(reset == 1) begin
            state <= RST;
            sclk_sig <= 0;
            boot_counter <= 27'd25_000_000;
				address_<=address;
        end
        else begin
            case(state)
                RST: begin
                    if(boot_counter == 0) begin
                        sclk_sig <= 0;
                        cmd_out <= {56{1'b1}};
                        byte_counter <= 0;
                        cmd_mode <= 1;
                        bit_counter <= 160;
                        cs <= 1;
								fifo_clr<=1'b1;
                        state <= INIT;
								//get_data_done<=1'b0;
								byte_available<=1'b0;
								address_<=address;
                    end
                    else begin
                        boot_counter <= boot_counter - 1'b1;
                    end
                end
                INIT: begin
                    if(bit_counter == 0) begin
                        cs <= 0;
                        state <= CMD0;
								fifo_clr<=1'b0;
                    end
                    else begin
                        bit_counter <= bit_counter - 1'b1;
                        sclk_sig <= ~sclk_sig;
                    end
                end
                CMD0: begin
                    cmd_out <= 56'hFF_40_00_00_00_00_95;
                    bit_counter <= 55;
                    return_state <= CMD55;
                    state <= SEND_CMD;
                end
                CMD55: begin
                    cmd_out <= 56'hFF_77_00_00_00_00_01;
                    bit_counter <= 55;
                    return_state <= CMD41;
                    state <= SEND_CMD;
                end
                CMD41: begin
                    cmd_out <= 56'hFF_69_00_00_00_00_01;
                    bit_counter <= 55;
                    return_state <= POLL_CMD;
                    state <= SEND_CMD;
                end
                POLL_CMD: begin
                    if(recv_data[0] == 0) begin
                        state <= IDLE;
                    end
                    else begin
                        state <= CMD55;
                    end
                end
                IDLE: begin
							if(reset_music)
							address_<=address;
							else address_<=address_;
                    if(rd == 1) begin
                        state <= READ_BLOCK;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                READ_BLOCK: begin
						
                    cmd_out <= {16'hFF_51, address_, 8'hFF};
                    bit_counter <= 55;
                    return_state <= READ_BLOCK_WAIT;
                    state <= SEND_CMD;
						 
                end
                READ_BLOCK_WAIT: begin
                    if(sclk_sig == 1 && miso == 0) begin
                        byte_counter <= 256;
                        bit_counter <= 7;
                        return_state <= READ_BLOCK_DATA;
                        state <= RECEIVE_BYTE;
                    end
                    sclk_sig <= ~sclk_sig;
                end
                READ_BLOCK_DATA: begin
                    dout <= recv_data2;
                    byte_available<=1'b1;
                    if (byte_counter == 0) begin
                        bit_counter <= 7;
								
                        return_state <= READ_BLOCK_CRC;
                        state <= RECEIVE_BYTE;
								if (address_ == address_end)
									address_<=address;
								else
								address_<=address_+10'd512;
                    end
                    else begin
                        byte_counter <= byte_counter - 1;
                        return_state <= READ_BLOCK_DATA;
                        bit_counter <= 15;
                        state <= RECEIVE_BYTE2;
								
                    end
                end
                READ_BLOCK_CRC: begin
                    bit_counter <= 7;
                    return_state <= IDLE;
                    state <= RECEIVE_BYTE;
                end
                SEND_CMD: begin
                    if (sclk_sig == 1) begin
                        if (bit_counter == 0) begin
                            state <= RECEIVE_BYTE_WAIT;
                        end
                        else begin
                            bit_counter <= bit_counter - 1'b1;
                            cmd_out <= {cmd_out[54:0], 1'b1};
                        end
                    end
                    sclk_sig <= ~sclk_sig;
                end
                RECEIVE_BYTE_WAIT: begin
                    if (sclk_sig == 1) begin
                        if (miso == 0) begin
                            recv_data <= 0;
                            bit_counter <= 6;
                            state <= RECEIVE_BYTE;
                        end
                    end
                    sclk_sig <= ~sclk_sig;
                end
                RECEIVE_BYTE: begin
                    byte_available<=1'b0;
                    if (sclk_sig == 1) begin
                        recv_data <= {recv_data[6:0], miso};
                        if (bit_counter == 0) begin
                            state <= return_state;
                        end
                        else begin
                            bit_counter <= bit_counter - 1'b1;
                        end
                    end
                    sclk_sig <= ~sclk_sig;
                end
					 RECEIVE_BYTE2: begin
                    byte_available<=1'b0;
                    if (sclk_sig == 1) begin
                        recv_data2 <= {recv_data2[14:0], miso};
                        if (bit_counter == 0) begin
                            state <= return_state;
                        end
                        else begin
                            bit_counter <= bit_counter - 1'b1;
                        end
                    end
                    sclk_sig <= ~sclk_sig;
                end
                
            endcase
        end
    end

    assign sclk = sclk_sig;
    assign mosi = cmd_mode ? cmd_out[55] : data_sig[7];

fifo (
	fifo_clr,
	dout,
	rdclk,
	fifo_rd_ena,
	clk,
	byte_available,
	fifo_rd_dat,
	rdempty,
	usedw);
reg fifo_clr;
wire rdempty;
wire fifo_rd_ena;
assign fifo_rd_ena = 1'b1;



endmodule