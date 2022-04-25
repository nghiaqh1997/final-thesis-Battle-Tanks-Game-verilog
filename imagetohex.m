%read the image
%I = imread('memscreen 40x40.png');	

I = imread('winner-1.bmp');	
imshow(I);
		
%Extract RED, GREEN and BLUE components from the image
R = I(:,:,1);			
G = I(:,:,2);
B = I(:,:,3);

%make the numbers to be of double format for 
R = double(R);	
G = double(G);
B = double(B);

%Raise each member of the component by appropriate value. 
R = R*7/255; % 8 bits -> 3 bits
G = G*7/255; % 8 bits -> 3 bits
B = B*3/255; % 8 bits -> 2 bits

%tranlate to integer
R = uint8(R); % float -> uint8
G = uint8(G);
B = uint8(B);

%minus one cause sometimes conversion to integers rounds up the numbers wrongly
%R = R-1; % 3 bits -> max value is 111 (bin) -> 7 (dec)(hex)
%G = G-1;
%B = B-1; % 11 (bin) -> 3 (dec)(hex)

%shift bits and construct one Byte from 3 + 3 + 2 bits
G = bitshift(G, 2); % 3 << G (shift by 3 bits)
R = bitshift(R, 5); % 6 << B (shift by 6 bits)
COLOR = R+G+B;      % R + 3 << G + 6 << B

%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen ('mem_screen.mif', 'w');
for j = 1:size(COLOR, 1)
for i = 1:size(COLOR, 2)
    color_out = COLOR(j,i);
    %for mouse icon begin
   %{
    if color_out == 182
        color_out = 0;
    elseif color_out == 255
        color_out = 17;
    elseif color_out == 0
        color_out = 16;
        
    end
    if color_out == 0
    fprintf (fileID, '%x', color_out);
    end
    %}
     %{
    addr = (j-1)*size(COLOR, 2) + i-1;
    %}
    %for mouse icon end
    fprintf (fileID, '%x\n', color_out); % COLOR (dec) -> print to file (hex)
end
end
 % COLOR (dec) -> print to file (hex)
%save variable COLOR to a file in HEX format for the chip to read
%fileID = fopen ('Mickey.list', 'w');
%fprintf (fileID, '%x\n', COLOR); % COLOR (dec) -> print to file (hex)
fclose (fileID);

%translate to hex to see how many lines
COLOR_HEX = dec2hex(COLOR);
