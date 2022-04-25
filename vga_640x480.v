module vga_640x480(clk25,reset,hcs,vcs,hsync,vsync,disp_ena,n_blank,n_sync);
input clk25,reset;
output hsync,vsync,disp_ena;
output reg [9:0] hcs,vcs;
output wire n_blank,n_sync;
//wire [9:0] h_period,v_period;

localparam h_period =10'b1100100000; //h_period = hpixels + hfp + hpulse + hbp = 640+16+96+48=800
localparam v_period =10'b1000001101; //v_period = hpixels + hfp + hpulse + hbp = 480+10+2+33 = 525

assign n_blank = 1'b1;  //no direct blanking
assign n_sync = 1'b0;   //no sync on green
//counter
always @(posedge clk25)
begin
	if (reset == 1)
	begin
		hcs <= 10'd0;
		vcs <= 10'd0;
	end
	else 
		if(hcs == h_period - 1)
			begin
				hcs <= 10'd0;
				if(vcs == v_period - 10'd1)
					vcs <= 10'd0;
				else
					vcs <= vcs + 10'd1;
			end
		else
			begin
			hcs <= hcs + 10'd1;
			end
end
//horizontal sync
assign hsync = ((hcs < 656)||(hcs >= 752))?1:0;//hsync = ((hcs < hpixels + hfp)||(hcs >= hpixels + hfp + hpulse))?1:0
//vertical sync
assign vsync = ((vcs < 490)||(vcs >= 492))?1:0;//vsync = ((vcs < vpixels + hfp)||(vcs >= vpixels + vfp + vpulse))?1:0
//set display
assign disp_ena = (hcs < 640)&&(vcs < 480)?1:0;//disp_ena = (hcs < hpixels)&&(vcs < vpixels)?1:0
endmodule

