module rgb8_to_rgb12(rgb8,rgb12);
input [7:0] rgb8; //3r,3g,2b
output [11:0] rgb12;

assign rgb12[11:8] = rgb8[7:5]*(15/7);
assign rgb12[7:4] = rgb8[4:2]*(15/7);
assign rgb12[3:0] = rgb8[1:0]*(15/3);
endmodule
