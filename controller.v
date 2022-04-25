module controller(
						//in
						clk25,reset,
						bullet_y1,bullet_x1,bullet_x2,bullet_y2,
						x_tank1,x_tank2,y_tank2,y_tank1,
						x,y,
						direction1,direction2,
						direction_bullet1,direction_bullet2,
						red_explosion_ack,green_explosion_ack,
						red_bullet_act,green_bullet_act,
						reset_plyrScrn,
						
						//out
						player_screen,
						first_screen_out,
						explosion_flag,
						des_bullet1,des_bullet2);


input red_bullet_act,green_bullet_act;
input [9:0]bullet_x1,bullet_x2,x_tank1,x_tank2,x;
input [8:0]bullet_y1,bullet_y2,y_tank1,y_tank2,y;
input clk25,reset;
input [1:0]direction1,direction2,direction_bullet1,direction_bullet2;
input red_explosion_ack,green_explosion_ack;//reset explosion_flag
output reg [1:0]player_screen;
input reset_plyrScrn;
output reg [11:0]first_screen_out;
output reg explosion_flag;
//dia chi vao` rom
reg [9:0]up_addr,left_addr,explosion_addr,greenup_addr,greenleft_addr,green_explosion_addr;
reg [6:0]bullet_up_addr,bullet_left_addr;
reg [6:0]greenbullet_down_addr,bullet_right_addr; 
reg [7:0]wall_addr;
//data out rom
wire [11:0]up_dataOut,left_dataOut,explosion_dataOut,greenup_dataOut,greenleft_dataOut,green_explosion_dataOut;
wire [11:0]bullet_up_dataOut,bullet_left_dataOut;
wire [11:0]bullet_down_dataOut,bullet_right_dataOut;
wire [11:0]wall_dataout;
//counter
reg [20:0]green_explosion_cnt,explosion_cnt;
//reg explosion_act;

reg des_tank2=1'b0;
reg des_tank1=1'b0;
reg [1:0]green_score,red_score;
output reg des_bullet1,des_bullet2;
wire [9:0]x_brick;
wire [8:0]y_brick;
reg wall_act;

/*wire [4:0] DOWN,RIGHT,UP,LEFT,FIRE;

assign  DOWN    = 5'b00001;                 
assign  RIGHT   = 5'b00010;
assign  UP      = 5'b00100;
assign  LEFT    = 5'b01000;
assign  FIRE  = 5'b10000;*/
wire [1:0] ICON_DOWN,ICON_LEFT,ICON_RIGHT,ICON_UP;
assign  ICON_UP     = 2'b00;                
assign  ICON_DOWN   = 2'b01;
assign  ICON_LEFT   = 2'b10;
assign  ICON_RIGHT  = 2'b11;

always@(posedge clk25)begin//begin lan` 1
	if(reset)
		begin
			up_addr<=10'd0;
			left_addr<=10'd0;
			greenup_addr <= 10'd0;
         greenleft_addr <= 10'd0;
			wall_addr<=10'd0;
			bullet_up_addr<=7'd0;
			bullet_left_addr<=7'd0;
			greenbullet_down_addr<=7'd0;
			bullet_right_addr<=7'd0;
		end
	//else if((x<0)||(x>639)||(y<0)||(y>479))
		//begin
			
		
		//end
			
//reset dia chi ve~ tuong`
	else if ((x==x_brick)&&(y==y_brick))
		begin
			wall_addr<=1'b0;
			wall_act<=1'b1;
		end
//ve~ tuong`
	else if ((x>=x_brick)&&(x<=(x_brick+10'd39))&&(y>=y_brick)&&(y<=(y_brick+10'd39))&&wall_act==1'b1)
		begin
			wall_addr<=wall_addr+1'd1;
			first_screen_out<=wall_dataout;
		end
//xoa tuong` khi bullet va cham
	else if (((bullet_x1>=x_brick)&&(bullet_x1<=(x_brick+10'd40))&&(bullet_y1>=y_brick)&&(bullet_y1<=(y_brick+10'd40)))
				||((bullet_x2>=x_brick)&&(bullet_x2<=(x_brick+10'd40))&&(bullet_y2>=y_brick)&&(bullet_y2<=(y_brick+10'd40))))
		begin
			wall_act<=1'b0; // xoa tuong`
		end
//xuat hien vu no khi vien dan cham phai xe tank doi phuong
	else if ((bullet_y2 >= y_tank1) && ( bullet_y2 <= (y_tank1+ 10'd31)) && 
                (bullet_x2 >= x_tank1) && ( bullet_x2 <= (x_tank1+ 10'd31)) &&
                (y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                    begin
                               explosion_addr <= explosion_addr + 1'd1;             
                               first_screen_out <= explosion_dataOut;               
                               green_explosion_cnt <= green_explosion_cnt + 1'd1;   
                               //explosion_act <= 1'd1;                               
										 des_bullet2<=1'b1;
										 des_tank1<=1'b1;
                    end
            
           
   else if (green_explosion_cnt >= 19'd60000)
                begin
                    green_score <= green_score + 1'd1;
                    green_explosion_cnt <= 19'd0;
                    explosion_flag <= 1'd1;                                        
						  des_bullet2<=1'b0;
						  
                    //explosion_act <= 1'd0;                                          
                end
//////Thong bao win
    else if (green_score == 2'd3)
                begin
                    player_screen <= 2'b01;
                    green_score <= 1'd0;
                end
        
//////reset flag explo sau khi bat len        
    else if (red_explosion_ack >= 1'd1)begin 
							explosion_flag <= 1'd0;
							des_tank1<=1'b0;
							end
							
   
  
    
/////xong vu no giua tank 1 va` bullet 2
///// phat hien va cham giua tank 2 va` bullet 1   
    else if ((bullet_y1 >= y_tank2) && ( bullet_y1 <= (y_tank2+ 10'd31)) && 
        (bullet_x1 >= x_tank2) && ( bullet_x1 <= (x_tank2+ 10'd31)) &&
        (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
        (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
            begin
                green_explosion_addr <= green_explosion_addr + 1'd1;
                first_screen_out <= green_explosion_dataOut;
                explosion_cnt <= explosion_cnt + 1'd1;                  
                //explosion_act <= 1'd1;                                  
					 des_bullet1<=1'b1;
					 des_tank2<=1'b1;
            end
            
            
    else if (explosion_cnt >= 19'd60000)
             begin
                 red_score <= red_score + 1'd1;                         
                 explosion_cnt <= 19'd0;
                 explosion_flag <= 1'd1;                                
					  des_bullet1<=1'b0;
                 //explosion_act <= 1'd0;                               
             end
             
    else if (red_score == 2'd3)
             begin
                 player_screen <= 2'b10;                                
                 red_score <= 1'd0;                                     
             end 
              
////reset flag  
    else if (green_explosion_ack >= 1'd1)
				begin
				explosion_flag <= 1'd0;
				des_tank2<=1'b0;
				end
    else if (reset_plyrScrn >= 1'd1) begin                             
                player_screen <= 2'b0;                                  
                red_score <= 1'd0; 
					 green_score <= 1'd0;
              end
//////////xong va cham giua vien dan va` xe tank
////////// xong cach tinh diem ben win
//////////ve~ 2 xe tank
	else if ((des_tank1==1'd0)||(des_tank2==1'd0))
		begin
			case (direction1)
           
            ICON_UP:  if ((y == y_tank1) && (x == x_tank1)) 
                        begin
                         up_addr <=10'd0;                       
                         explosion_addr <= 10'd0;
                         end
                       else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                          (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= up_dataOut;   /////tang dia chi gan mau
                               up_addr <= up_addr + 1'd1;        
                       end
            
                else begin
                        up_addr <= up_addr + 10'd0;             
                        explosion_addr <= explosion_addr;       
                    end
            ICON_DOWN: if ((y == y_tank1) && (x == x_tank1))
                        begin
                         up_addr <=10'd1023;                             
                        explosion_addr <= 10'd0;                
                         end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin 
                                first_screen_out <= up_dataOut;  
                                up_addr <= up_addr - 1'd1;      
                               
                       end
             
                else begin
                           up_addr <= up_addr + 10'd0;          
                           explosion_addr <= explosion_addr;    
                       end
            ICON_LEFT:   
                 if ((y == y_tank1) && (x == x_tank1)) 
                            begin
                                left_addr <=10'd0;                  
                                explosion_addr <= 10'd0;
                            end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= left_dataOut;    
                               left_addr <= left_addr + 1'd1;       
                       end
            
            else begin
                            left_addr <= left_addr + 10'd0;         
                            explosion_addr <= explosion_addr;
                    end    
            
					ICON_RIGHT:
             if ((y == y_tank1) && (x == x_tank1))
                begin
                    left_addr <=10'd1023;                                  
                    explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin   
                               first_screen_out <= left_dataOut;           
                               left_addr <= left_addr - 1'd1;
                       end
                    
            else begin
                   left_addr <= left_addr + 10'd0;                    
                  explosion_addr <= explosion_addr;
                end
            
            endcase
/////////Ve~ xong tank 1
/////////Ve~ tank 2
			case (direction2)
           
            ICON_UP:   
            if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenup_addr <=10'd0;                           
                        green_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenup_dataOut;    
                               greenup_addr <= greenup_addr + 1'd1;     
                       end
            
            else begin 
                    greenup_addr <= greenup_addr + 10'd0;               
                    green_explosion_addr <= green_explosion_addr;
                 end
            ICON_DOWN:
              if ((y == y_tank2) && (x == x_tank2))
                    begin
                     greenup_addr <=10'd1023;                           
                    green_explosion_addr <= 10'd0;
                    end                
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin 
                                first_screen_out <= greenup_dataOut;        
                                greenup_addr <= greenup_addr - 1'd1;        
                               
                       end
             
            else begin 
                   greenup_addr <= greenup_addr + 10'd0;                    
                   green_explosion_addr <= green_explosion_addr;
                end
            ICON_LEFT:   
             if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenleft_addr <=10'd0;                                    
                        green_explosion_addr <= 10'd0;
                        end                  
             
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenleft_dataOut;                    
                               greenleft_addr <= greenleft_addr + 1'd1;
                       end
            
            else 
                begin
                    greenleft_addr <= greenleft_addr + 10'd0;                    
                   green_explosion_addr <= green_explosion_addr;
                 end            
            ICON_RIGHT:
             if ((y == y_tank2) && (x == x_tank2))
                begin
                    greenleft_addr <=10'd1023;                                   
                    green_explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin   
                               first_screen_out <= greenleft_dataOut;           
                               greenleft_addr <= greenleft_addr - 1'd1;
                       end
                    
            else begin
                   greenleft_addr <= greenleft_addr + 10'd0;                    
                  green_explosion_addr <= green_explosion_addr;
                end
            endcase 
			end
///// Ve~ xong xe tank 2
///// Ve~ bullet 1
	else if (red_bullet_act == 1'd1)
        begin
            case (direction_bullet1)
           
                ICON_UP:   
                    if ((y == y_tank2) && (x == x_tank2)) 
						  bullet_up_addr <= 7'd120;    
                    else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 5'd14)) && 
                    (x >= bullet_x1 ) && ( x <= (bullet_x1 + 4'd7)))
                       begin            
                           first_screen_out <= bullet_up_dataOut;                       
                           bullet_up_addr <= bullet_up_addr - 1'd1;
                       end
                    else bullet_up_addr <= bullet_up_addr + 7'd0;                      
                
                ICON_DOWN:   
                    if ((y == y_tank2) && (x == x_tank2)) bullet_up_addr <= 7'd0;          
                    else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 5'd14)) && 
                        (x >= bullet_x1 ) && ( x <= (bullet_x1 + 4'd7)))
                           begin            
                               first_screen_out <= bullet_up_dataOut;                   
                               bullet_up_addr <= bullet_up_addr + 1'd1;
                           end
                    else bullet_up_addr <= bullet_up_addr + 7'd0;                       
                
                ICON_LEFT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd120;     
                 else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 4'd7)) && 
                    (x >= bullet_x1 ) && ( x <= (bullet_x1 + 5'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     
                           bullet_left_addr <= bullet_left_addr - 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 7'd0;                      
                
                ICON_RIGHT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd0;       
                 else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 4'd7)) && 
                    (x >= bullet_x1 ) && ( x <= (bullet_x1 + 5'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     
                           bullet_left_addr <= bullet_left_addr + 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 7'd0;                      
            endcase
        end
	else if (green_bullet_act == 1'd1)
                begin
                    case (direction_bullet2)
                   
                        ICON_UP:   
                         if ((y == y_tank2) && (x == x_tank2)) greenbullet_down_addr <= 7'd120;    
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 5'd14)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 4'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;                                 
                                   greenbullet_down_addr <= greenbullet_down_addr - 1'd1;
                               end
                        else greenbullet_down_addr <= greenbullet_down_addr + 7'd0;                        
                        
                        ICON_DOWN:   
                         if ((y == y_tank2) && (x == x_tank2)) greenbullet_down_addr <= 7'd0;      
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 5'd14)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 4'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;
                                   greenbullet_down_addr <= greenbullet_down_addr + 1'd1;                   
                               end
                        else greenbullet_down_addr <= greenbullet_down_addr + 7'd0;                        
                        
                        ICON_LEFT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd120;        
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 4'd7)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 5'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                                
                                   bullet_right_addr <= bullet_right_addr - 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr;                                        
                        
                        ICON_RIGHT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd0;          
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 4'd7)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 5'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                                
                                   bullet_right_addr <= bullet_right_addr + 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr + 7'd0;                            
    
                    endcase
                end
		else begin
				bullet_left_addr <= bullet_left_addr;                                       
            bullet_up_addr <= bullet_up_addr ;
				bullet_right_addr <= bullet_right_addr;                                                 
            greenbullet_down_addr <=greenbullet_down_addr ;
				first_screen_out<=12'b111111111111;
				end
end
		
			
	
		
		


/*
always@(posedge clk25)begin
if (reset) begin
                up_addr <=  10'd0;
                left_addr <= 10'd0;
                end
                
//va cham bullet 2 voi tank 1               
           else if ((bullet_y2 >= y_tank1) && ( bullet_y2 <= (y_tank1+ 10'd31)) && 
                (bullet_x2 >= x_tank1) && ( bullet_x2 <= (x_tank1+ 10'd31)) &&
                (y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                    begin
                               explosion_addr <= explosion_addr + 1'd1;             
                               first_screen_out <= explosion_dataOut;               
                               green_explosion_cnt <= green_explosion_cnt + 1'd1;   
                               //explosion_act <= 1'd1;                               
										 des_bullet2<=1'b1;
                    end
            
           
           else if (green_explosion_cnt >= 19'd60000)
                begin
                    green_score <= green_score + 1'd1;
                    green_explosion_cnt <= 19'd0;
                    explosion_flag <= 1'd1;                                        
						  des_bullet2<=1'b0;
                    //explosion_act <= 1'd0;                                          
                end
//////Thong bao win
           else if (green_score == 2'd3)
                begin
                    player_screen <= 2'b01;
                    green_score <= 1'd0;
                end
        
//////reset flag explo sau khi bat len        
            else if (red_explosion_ack >= 1'd1) explosion_flag <= 1'd0;
   
  
            else if (reset_plyrScrn >= 1'd1) begin
                                        player_screen <= 2'b00;
                                        green_score <= 1'd0;
                                    end
   
   else begin
           
/////Ve xe tank 1
           case (direction1)
           
            ICON_UP:  if ((y == y_tank1) && (x == x_tank1)) 
                        begin
                         up_addr <=10'd0;                       
                         explosion_addr <= 10'd0;
                         end
                       else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                          (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= up_dataOut;   /////tang dia chi gan mau
                               up_addr <= up_addr + 1'd1;        
                       end
            
                else begin
                        up_addr <= up_addr + 10'd0;             
                        explosion_addr <= explosion_addr;       
                    end
            ICON_DOWN: if ((y == y_tank1) && (x == x_tank1))
                        begin
                         up_addr <=10'd1023;                             
                        explosion_addr <= 10'd0;                
                         end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin 
                                first_screen_out <= up_dataOut;  
                                up_addr <= up_addr - 1'd1;      
                               
                       end
             
                else begin
                           up_addr <= up_addr + 10'd0;          
                           explosion_addr <= explosion_addr;    
                       end
            ICON_LEFT:   
                 if ((y == y_tank1) && (x == x_tank1)) 
                            begin
                                left_addr <=10'd0;                  
                                explosion_addr <= 10'd0;
                            end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= left_dataOut;    
                               left_addr <= left_addr + 1'd1;       
                       end
            
            else begin
                            left_addr <= left_addr + 10'd0;         
                            explosion_addr <= explosion_addr;
                    end    
            
					ICON_RIGHT:
             if ((y == y_tank1) && (x == x_tank1))
                begin
                    left_addr <=10'd1023;                                  
                    explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin   
                               first_screen_out <= left_dataOut;           
                               left_addr <= left_addr - 1'd1;
                       end
                    
            else begin
                   left_addr <= left_addr + 10'd0;                    
                  explosion_addr <= explosion_addr;
                end
            
            endcase
    
end






//va cham bullet 1 voi tank 2
    if (reset) begin
            greenup_addr <= 10'd0;
            greenleft_addr <= 10'd0;
        end
       
    else if ((bullet_y1 >= y_tank2) && ( bullet_y1 <= (y_tank2+ 10'd31)) && 
        (bullet_x1 >= x_tank2) && ( bullet_x1 <= (x_tank2+ 10'd31)) &&
        (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
        (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
            begin
                green_explosion_addr <= green_explosion_addr + 1'd1;
                first_screen_out <= green_explosion_dataOut;
                explosion_cnt <= explosion_cnt + 1'd1;                  
                //explosion_act <= 1'd1;                                  
					 des_bullet1<=1'b1;
            end
            
            
    else if (explosion_cnt >= 19'd60000)
             begin
                 red_score <= red_score + 1'd1;                         
                 explosion_cnt <= 19'd0;
                 explosion_flag <= 1'd1;                                
					  des_bullet1<=1'b0;
                 //explosion_act <= 1'd0;                               
             end
             
    else if (red_score == 2'd3)
             begin
                 player_screen <= 2'b10;                                
                 red_score <= 1'd0;                                     
             end 
              
////reset flag  
    else if (green_explosion_ack >= 1'd1) explosion_flag <= 1'd0;
     else if (reset_plyrScrn >= 1'd1) begin                             
                player_screen <= 2'b0;                                  
                red_score <= 1'd0;                                      
              end
    else  begin
                
   
            case (direction2)
           
            ICON_UP:   
            if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenup_addr <=10'd0;                           
                        green_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenup_dataOut;    
                               greenup_addr <= greenup_addr + 1'd1;     
                       end
            
            else begin 
                    greenup_addr <= greenup_addr + 10'd0;               
                    green_explosion_addr <= green_explosion_addr;
                 end
            ICON_DOWN:
              if ((y == y_tank2) && (x == x_tank2))
                    begin
                     greenup_addr <=10'd1023;                           
                    green_explosion_addr <= 10'd0;
                    end                
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin 
                                first_screen_out <= greenup_dataOut;        
                                greenup_addr <= greenup_addr - 1'd1;        
                               
                       end
             
            else begin 
                   greenup_addr <= greenup_addr + 10'd0;                    
                   green_explosion_addr <= green_explosion_addr;
                end
            ICON_LEFT:   
             if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenleft_addr <=10'd0;                                    
                        green_explosion_addr <= 10'd0;
                        end                  
             
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenleft_dataOut;                    
                               greenleft_addr <= greenleft_addr + 1'd1;
                       end
            
            else 
                begin
                    greenleft_addr <= greenleft_addr + 10'd0;                    
                   green_explosion_addr <= green_explosion_addr;
                 end            
            ICON_RIGHT:
             if ((y == y_tank2) && (x == x_tank2))
                begin
                    greenleft_addr <=10'd1023;                                   
                    green_explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin   
                               first_screen_out <= greenleft_dataOut;           
                               greenleft_addr <= greenleft_addr - 1'd1;
                       end
                    
            else begin
                   greenleft_addr <= greenleft_addr + 10'd0;                    
                  green_explosion_addr <= green_explosion_addr;
                end
            endcase    
    end
if (red_bullet_act == 1'd1)
        begin
            case (direction_bullet1)
           
                ICON_UP:   
                    if ((y == y_tank2) && (x == x_tank2)) 
						  bullet_up_addr <= 7'd120;    
                    else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 5'd14)) && 
                    (x >= bullet_x1 ) && ( x <= (bullet_x1 + 4'd7)))
                       begin            
                           first_screen_out <= bullet_up_dataOut;                       
                           bullet_up_addr <= bullet_up_addr - 1'd1;
                       end
                    else bullet_up_addr <= bullet_up_addr + 7'd0;                      
                
                ICON_DOWN:   
                    if ((y == y_tank2) && (x == x_tank2)) bullet_up_addr <= 7'd0;          
                    else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 5'd14)) && 
                        (x >= bullet_x1 ) && ( x <= (bullet_x1 + 4'd7)))
                           begin            
                               first_screen_out <= bullet_up_dataOut;                   
                               bullet_up_addr <= bullet_up_addr + 1'd1;
                           end
                    else bullet_up_addr <= bullet_up_addr + 7'd0;                       
                
                ICON_LEFT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd120;     
                 else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 4'd7)) && 
                    (x >= bullet_x1 ) && ( x <= (bullet_x1 + 5'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     
                           bullet_left_addr <= bullet_left_addr - 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 7'd0;                      
                
                ICON_RIGHT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd0;       
                 else if ((y >= bullet_y1 ) && ( y <= (bullet_y1 + 4'd7)) && 
                    (x >= bullet_x1 ) && ( x <= (bullet_x1 + 5'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     
                           bullet_left_addr <= bullet_left_addr + 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 7'd0;                      
            endcase
        end
    else begin
            bullet_left_addr <= bullet_left_addr;                                       
            bullet_up_addr <= bullet_up_addr ;
        end   

//ve vien dan          
    if (green_bullet_act == 1'd1)
                begin
                    case (direction_bullet2)
                   
                        ICON_UP:   
                         if ((y == y_tank2) && (x == x_tank2)) greenbullet_down_addr <= 7'd120;    
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 5'd14)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 4'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;                                 
                                   greenbullet_down_addr <= greenbullet_down_addr - 1'd1;
                               end
                        else greenbullet_down_addr <= greenbullet_down_addr + 7'd0;                        
                        
                        ICON_DOWN:   
                         if ((y == y_tank2) && (x == x_tank2)) greenbullet_down_addr <= 7'd0;      
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 5'd14)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 4'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;
                                   greenbullet_down_addr <= greenbullet_down_addr + 1'd1;                   
                               end
                        else greenbullet_down_addr <= greenbullet_down_addr + 7'd0;                        
                        
                        ICON_LEFT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd120;        
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 4'd7)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 5'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                                
                                   bullet_right_addr <= bullet_right_addr - 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr;                                        
                        
                        ICON_RIGHT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd0;          
                         else if ((y >= bullet_y2 ) && ( y <= (bullet_y2 + 4'd7)) && 
                            (x >= bullet_x2 ) && ( x <= (bullet_x2 + 5'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                                
                                   bullet_right_addr <= bullet_right_addr + 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr + 7'd0;                            
    
                    endcase
                end
            else begin
                    bullet_right_addr <= bullet_right_addr;                                                 
                    greenbullet_down_addr <=greenbullet_down_addr ;
						  
                end  
end*/
/////////////////////ROM/////////////////////////////////////////////////////////////////////////////////

//redtankup
reduptank r1(
	up_addr,
	clk25,
	up_dataOut);
//redtankleft
redtankleft r2(
	left_addr,
	clk25,
	left_dataOut);
//explosion
explosion e1(
	explosion_addr,
	clk25,
	explosion_dataOut);
explosion e2(
	green_explosion_addr,
	clk25,
	green_explosion_dataOut);
//greentankup
greentankup g3(
	greenup_addr,
	clk25,
	greenup_dataOut);
//greentankleft
greentankleft g2(
	greenleft_addr,
	clk25,
	greenleft_dataOut);
//bulletup
bulletup b1(
	bullet_up_addr,
	clk25,
	bullet_up_dataOut);
//bulletleft
bulletleft b3(
	bullet_left_addr,
	
	bullet_left_dataOut);
//bulletdown
bulletup b2(
	greenbullet_down_addr,
	
	bullet_down_dataOut);
//bulletright
bulletleft b4(
	bullet_right_addr,
	clk25,
	bullet_right_dataOut);

endmodule


