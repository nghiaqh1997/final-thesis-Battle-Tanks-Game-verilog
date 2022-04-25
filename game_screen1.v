
module game_screen1 (first_screen_out,y,x,CLOCK_50,clk25,reset,player1,player2,player_screen,
                    red_score,green_score,reset_plyrScrn,explosion_act);

input               CLOCK_50; //100Mhz
input               clk25; //44.9 Mhzinput  reset; 
input       [10:0]  y; //from DTG
input       [10:0]  x; //From DTG
input               reset;

output  reg [11:0]  first_screen_out = 12'd0;       // output data to colorizer
input       [4:0]   player1;                           // input to control red tank
input       [4:0]   player2;                             // input to control green tank
output  reg [1:0]   player_screen;                  // output to player2itch interface: outputs 2'd2 if red player wins and 2'd1 if green wins
output  reg [1:0]   red_score;                      // outputs red score to 7 SD
output  reg [1:0]   green_score;                    // outputs green score to 7 SD
input               reset_plyrScrn;                 // input from player2itch interface that screen has changed, reset player_screen to 0
output  reg         explosion_act;                  // output to sound, explosion is active: 1'd1 is active explosion, 1'd0 is no explosion
wire        [10:0]  pixel_row_B,pixel_column_B;     // scalar for input from dtg


//Zooming for background from 128x96 to 1024x768
assign pixel_row_B =  y [10:1];
assign pixel_column_B =  x [10:1];

// starting locations
reg         [9:0]   y_tank1;                          // red tank locations
reg         [9:0]   x_tank1;

reg         [9:0]   y_tank2;                          // green tank locations
reg         [9:0]   x_tank2;

parameter integer   FLAG_CNT = 500000;                      // speed for tank. Less is faster
reg	        [20:0]  flag_count;                             // counter for tank movement
reg			        flag;                                   // tank can only move if flag is set high

reg         [20:0]  explosion_cnt;
reg                 explosion_flag;
reg         [20:0]  green_explosion_cnt;
reg                 red_explosion_ack;
reg                 green_explosion_ack;



parameter integer   BULLET_CNT = 100000;                    // speed for bullet. Less is faster
reg	        [19:0]  bullet_count;                           // counter for bullet movement
reg			        bullet_flag;                            // only changes bullet location if flag is high
reg         [1:0]	red_bullet_orient;                      // save bullet orientation when fired from tank
reg         [9:0]	y_bullet1;                        // red tanks bullet location
reg         [9:0]	x_bullet1;                
reg                 red_bullet_act;                         // active until it hits wall or opposing player


reg         [1:0]	green_bullet_orient;
reg         [9:0]	y_bullet2;
reg         [9:0]	x_bullet2;
reg                 green_bullet_act;


/////////////////////// address and data registers for green tank bullets and red tank bullets///////////////////////////
reg         [6:0]   greenbullet_up_addr;
reg         [6:0]   bullet_up_addr;
wire        [11:0]  bullet_up_dataOut;

reg         [6:0]   greenbullet_down_addr;
reg         [6:0]   bullet_down_addr;
wire        [11:0]  bullet_down_dataOut;

reg         [6:0]   greenbullet_left_addr;
reg         [6:0]   bullet_left_addr;
wire        [11:0]  bullet_left_dataOut;

reg         [6:0]   greenbullet_right_addr;
reg         [6:0]   bullet_right_addr;
wire        [11:0]  bullet_right_dataOut;

reg         [1:0]   redtank_orient;
reg         [1:0]   greentank_orient;

reg                 green_stop;
reg                 red_stop;



//Address to be passed to the Block RAM
reg         [17:0] rAddr_first = 18'd0;
wire        [11:0] rDout_first;

// addr and data for up
reg         [9:0]   up_addr = 10'd0;
wire        [11:0]  up_dataOut;

// addr and data for down

reg         [9:0]   greenup_addr = 10'd0;
wire        [11:0]  greenup_dataOut;

// addr and data for left

reg         [9:0]   left_addr = 10'd0;
wire        [11:0]  left_dataOut;

// addr and data for down

reg         [9:0]   greenleft_addr = 10'd0;
wire        [11:0]  greenleft_dataOut;

// wires for keyboard button presses
wire        [4:0]   UP, DOWN, LEFT, RIGHT, CENTER;
wire        [1:0]   ICON_UP, ICON_DOWN, ICON_LEFT, ICON_RIGHT;

// address and data for red tank explosion icon
reg         [9:0]   explosion_addr = 10'd0;
wire        [11:0]  explosion_dataOut;

// address and data for tank explosion icon
reg         [9:0]   green_explosion_addr = 10'd0;
wire        [11:0]  green_explosion_dataOut;

/*
// Block ROM to store the image information of background
blk_mem_gen_1 first_page (
  .clock(clk25),    // input wire clock
  .address(rAddr_first),  // input wire [13 : 0] address
  .q(rDout_first)
);
*/

// Block Rom for tank up position

reduptank redup1(
  .clock(clk25),    // input wire clock
  .address(up_addr),  // input wire [9 : 0] address
  .q(up_dataOut)  // output wire [11 : 0] q
);

// tank down position
greentankup greenup(
  .clock(clk25),    // input wire clock
  .address(greenup_addr),  // input wire [9 : 0] address
  .q(greenup_dataOut)  // output wire [11 : 0] q
);

// tank left position
redtankleft redleft1(
  .clock(clk25),    // input wire clock
  .address(left_addr),  // input wire [9 : 0] address
  .q(left_dataOut)  // output wire [11 : 0] q
);

// tank right position
greentankleft greenleft(
  .clock(clk25),    // input wire clock
  .address(greenleft_addr),  // input wire [9 : 0] address
  .q(greenleft_dataOut)  // output wire [11 : 0] q
);

bulletup red_bullet_up(
  .clock(clk25),    // input wire clock
  .address( bullet_up_addr),  // input wire [9 : 0] address
  .q( bullet_up_dataOut)  // output wire [11 : 0] q
);

bulletup red_bullet_down(
  .clock(clk25),    // input wire clock
  .address( greenbullet_down_addr),  // input wire [9 : 0] address
  .q( bullet_down_dataOut)  // output wire [11 : 0] q
);

bulletleft red_bullet_left(
  .clock(clk25),    // input wire clock
  .address( bullet_left_addr),  // input wire [9 : 0] address
  .q( bullet_left_dataOut)  // output wire [11 : 0] q
);

bulletleft red_bullet_right(
  .clock(clk25),    // input wire clock
  .address( bullet_right_addr),  // input wire [9 : 0] address
  .q( bullet_right_dataOut)  // output wire [11 : 0] q
);

explosion explosion(
  .clock(clk25),    // input wire clock
  .address( explosion_addr),  // input wire [9 : 0] address
  .q( explosion_dataOut)  // output wire [11 : 0] q
);

explosion greenexplosion(
  .clock(clk25),    // input wire clock
  .address( green_explosion_addr),  // input wire [9 : 0] address
  .q( green_explosion_dataOut)  // output wire [11 : 0] q
);

////////////////// used to assign bullet and tank orientations////////////////////////
assign  DOWN    = 5'b00001;                 
assign  RIGHT   = 5'b00010;
assign  UP      = 5'b00100;
assign  LEFT    = 5'b01000;
assign  CENTER  = 5'b10000;

assign  ICON_UP     = 2'b00;                
assign  ICON_DOWN   = 2'b01;
assign  ICON_LEFT   = 2'b10;
assign  ICON_RIGHT  = 2'b11;



///////////////////////// setting tank and bullet orientations///////////////////////

always @ (posedge clk25)
begin
if (reset) redtank_orient <= UP;

else if 	(red_bullet_act && player1[4] == 1'd1)
    begin
        case (redtank_orient) 
            ICON_DOWN:	red_bullet_orient <= ICON_DOWN;	
            ICON_UP:		red_bullet_orient <= ICON_UP;
            ICON_LEFT:	red_bullet_orient <= ICON_LEFT;
            ICON_RIGHT:	red_bullet_orient <= ICON_RIGHT;
            default:red_bullet_orient <= red_bullet_orient;
        endcase
    end
else
    begin
        case (player1)
        DOWN: redtank_orient <= ICON_DOWN;
        RIGHT:  redtank_orient <= ICON_RIGHT;
        UP:     redtank_orient <= ICON_UP;
        LEFT:   redtank_orient <= ICON_LEFT;
        default: redtank_orient <= redtank_orient;
        endcase
   
    end
    
if (reset) greentank_orient <= UP;
    
    else if     (green_bullet_act && player2[4] == 1'd1)
        begin
            case (greentank_orient) 
                ICON_DOWN:    green_bullet_orient <= ICON_DOWN;    
                ICON_UP:        green_bullet_orient <= ICON_UP;
                ICON_LEFT:    green_bullet_orient <= ICON_LEFT;
                ICON_RIGHT:    green_bullet_orient <= ICON_RIGHT;
                default:green_bullet_orient <= green_bullet_orient;
            endcase
        end
    else
        begin
            case (player2)
            DOWN: greentank_orient <= ICON_DOWN;
            RIGHT:  greentank_orient <= ICON_RIGHT;
            UP:     greentank_orient <= ICON_UP;
            LEFT:   greentank_orient <= ICON_LEFT;
            default: greentank_orient <= greentank_orient;
            endcase
       
        end
end
/////////////////////////////////////////////////////////////////////////////////////
//////////////////////this outputs either tank or background data///////////////////

always @(posedge clk25)begin
    if (reset) begin
            first_screen_out <= 12'd0;
            rAddr_first <= 18'd0;       
        end
    
    else
        begin
            //Where ever is the pixel pointer, print the background to screen.
            rAddr_first   <= {pixel_row_B[8:0],pixel_column_B[8:0]};;
            first_screen_out  <= rDout_first;
        end 
        
  if (reset) begin
                up_addr <=  10'd0;
                left_addr <= 10'd0;
                end
                
//////////////// If green bullet hits red tank output explosion///////////////////////////////////////                
           else if ((y_bullet2 >= y_tank1) && ( y_bullet2 <= (y_tank1+ 10'd31)) && 
                (x_bullet2 >= x_tank1) && ( x_bullet2 <= (x_tank1+ 10'd31)) &&
                (y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                    begin
                               explosion_addr <= explosion_addr + 1'd1;             // address for explosion BROM
                               first_screen_out <= explosion_dataOut;               // data in explosion BROM
                               green_explosion_cnt <= green_explosion_cnt + 1'd1;   // counter length of time to display explosion
                               explosion_act <= 1'd1;                               // explosion active, used to produce sound
                    end
            
/////////////// when counter reaches 60000, increment score            
           else if (green_explosion_cnt >= 19'd60000)
                begin
                    green_score <= green_score + 1'd1;
                    green_explosion_cnt <= 19'd0;
                    explosion_flag <= 1'd1;                                         // flag used to reset player locations
                    explosion_act <= 1'd0;                                          // stop outputting explosion sound
                end
///////////// when green tank reaches 3 hits, output player 1 wins//////////////
           else if (green_score == 2'd3)
                begin
                    player_screen <= 2'b01;
                    green_score <= 1'd0;
                end
        
////////// reset flag when tank locations reset/////////////////////////////////        
            else if (red_explosion_ack >= 1'd1) explosion_flag <= 1'd0;
   
//////////// reset player screen and score when screens change/////////////////   
            else if (reset_plyrScrn >= 1'd1) begin
                                        player_screen <= 2'b00;
                                        green_score <= 1'd0;
                                    end
   
   else begin
           
/////////// this displays red tank orientation ///////////////////////////////
           case (redtank_orient)
           
            ICON_UP:  if ((y == y_tank1) && (x == x_tank1)) 
                        begin
                         up_addr <=10'd0;                       // reset addresses
                         explosion_addr <= 10'd0;
                         end
                       else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                          (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= up_dataOut;   // output red tank up orientation
                               up_addr <= up_addr + 1'd1;        // increase address
                       end
            
                else begin
                        up_addr <= up_addr + 10'd0;             // if pixel location is not over tank, do nothing
                        explosion_addr <= explosion_addr;       // if not over explosion, do nothing
                    end
            ICON_DOWN: if ((y == y_tank1) && (x == x_tank1))
                        begin
                         up_addr <=10'd1023;                    // reset addresses                
                        explosion_addr <= 10'd0;                
                         end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin 
                                first_screen_out <= up_dataOut;  // output red tank down orientation
                                up_addr <= up_addr - 1'd1;      // decrease address
                               
                       end
             
                else begin
                           up_addr <= up_addr + 10'd0;          // do nothing
                           explosion_addr <= explosion_addr;    // do nothing
                       end
            ICON_LEFT:   
                 if ((y == y_tank1) && (x == x_tank1)) 
                            begin
                                left_addr <=10'd0;                  // reset addresses 
                                explosion_addr <= 10'd0;
                            end
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin            
                               first_screen_out <= left_dataOut;    // output red tank left orientation
                               left_addr <= left_addr + 1'd1;       // increase address
                       end
            
            else begin
                            left_addr <= left_addr + 10'd0;         // do nothing
                            explosion_addr <= explosion_addr;
                    end    
            ICON_RIGHT:  
             if ((y == y_tank1) && (x == x_tank1)) 
                        begin
                            left_addr <=10'd1023;                   // reset addresses                  
                            explosion_addr <= 10'd0;
                        end               
             else if ((y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                    (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                       begin 
                               first_screen_out <= left_dataOut;    // output red tank right orientation
                               left_addr <= left_addr - 1'd1;       // decrease address
                       end
            
            else begin
                    left_addr <= left_addr + 10'd0;                 // do nothing
                    explosion_addr <= explosion_addr;
                end            
            
            endcase
    
end

//////////////// start of green tank explosion output to screen /////////////////////////////////
    if (reset) begin
            greenup_addr <= 10'd0;
            greenleft_addr <= 10'd0;
        end
//////////////// If red bullet hits green tank output explosion///////////////////////////////////////          
    else if ((y_bullet1 >= y_tank2) && ( y_bullet1 <= (y_tank2+ 10'd31)) && 
        (x_bullet1 >= x_tank2) && ( x_bullet1 <= (x_tank2+ 10'd31)) &&
        (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
        (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
            begin
                green_explosion_addr <= green_explosion_addr + 1'd1;
                first_screen_out <= green_explosion_dataOut;
                explosion_cnt <= explosion_cnt + 1'd1;                  // count to display explosion for an amount of time
                explosion_act <= 1'd1;                                  // used to output sound when exploding
            end
            
////////////////when count reaches 600000 stop displaying explosion////////////////////////////////////            
    else if (explosion_cnt >= 19'd60000)
             begin
                 red_score <= red_score + 1'd1;                         // increment red score
                 explosion_cnt <= 19'd0;
                 explosion_flag <= 1'd1;                                // flag used to reset player location
                 explosion_act <= 1'd0;                                 // stop outputting explosion sound
             end
             
/////////////// when red score reaches change screens ///////////////////////////////////////////////////
    else if (red_score == 2'd3)
             begin
                 player_screen <= 2'b10;                                // output to player2itch interface to display player 1 wins
                 red_score <= 1'd0;                                     // reset score
             end 
              
/////////////// this displays green tank orientation ////////////////////////////////////////////////////////   
    else if (green_explosion_ack >= 1'd1) explosion_flag <= 1'd0;
     else if (reset_plyrScrn >= 1'd1) begin                             
                player_screen <= 2'b0;                                  // reset to 0 when starting over
                red_score <= 1'd0;                                      // when reset high, reset score
              end
    else  begin
                
   
            case (greentank_orient)
           
            ICON_UP:   
            if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenup_addr <=10'd0;                           // reset address
                        green_explosion_addr <= 10'd0;
                    end
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenup_dataOut;    // output green tank up data
                               greenup_addr <= greenup_addr + 1'd1;     // increment address
                       end
            
            else begin 
                    greenup_addr <= greenup_addr + 10'd0;               // do nothing, when pixel is not over tank
                    green_explosion_addr <= green_explosion_addr;
                 end
            ICON_DOWN:
              if ((y == y_tank2) && (x == x_tank2))
                    begin
                     greenup_addr <=10'd1023;                           // reset address
                    green_explosion_addr <= 10'd0;
                    end                
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin 
                                first_screen_out <= greenup_dataOut;        // output green tank down data
                                greenup_addr <= greenup_addr - 1'd1;        // deccrement address
                               
                       end
             
            else begin 
                   greenup_addr <= greenup_addr + 10'd0;                    // do nothing
                   green_explosion_addr <= green_explosion_addr;
                end
            ICON_LEFT:   
             if ((y == y_tank2) && (x == x_tank2)) 
                    begin
                        greenleft_addr <=10'd0;                             // reset address       
                        green_explosion_addr <= 10'd0;
                        end                  
             
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin            
                               first_screen_out <= greenleft_dataOut;           // output green tank left data         
                               greenleft_addr <= greenleft_addr + 1'd1;
                       end
            
            else 
                begin
                    greenleft_addr <= greenleft_addr + 10'd0;                    // do nothing
                   green_explosion_addr <= green_explosion_addr;
                 end            
            ICON_RIGHT:
             if ((y == y_tank2) && (x == x_tank2))
                begin
                    greenleft_addr <=10'd1023;                                  // reset address 
                    green_explosion_addr <= 10'd0;
                end              
             else if ((y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                    (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                       begin   
                               first_screen_out <= greenleft_dataOut;           // output green tank right data
                               greenleft_addr <= greenleft_addr - 1'd1;
                       end
                    
            else begin
                   greenleft_addr <= greenleft_addr + 10'd0;                    // do nothing
                  green_explosion_addr <= green_explosion_addr;
                end
            endcase    
    end
    
//////////////// outputs red bullet info ///////////////////////////////////////////////////////////////////////////    
if (red_bullet_act == 1'd1)
        begin
            case (red_bullet_orient)
           
                ICON_UP:   
                    if ((y == y_tank2) && (x == x_tank2)) bullet_up_addr <= 7'd120;    // reset bullet address
                    else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd14)) && 
                    (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd7)))
                       begin            
                           first_screen_out <= bullet_up_dataOut;                       // output bullet up data
                           bullet_up_addr <= bullet_up_addr - 1'd1;
                       end
                    else bullet_up_addr <= bullet_up_addr + 10'd0;                      // do nothing
                
                ICON_DOWN:   
                    if ((y == y_tank2) && (x == x_tank2)) bullet_up_addr <= 7'd0;     // reset bullet address     
                    else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd14)) && 
                        (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd7)))
                           begin            
                               first_screen_out <= bullet_up_dataOut;                   // output bullet down data
                               bullet_up_addr <= bullet_up_addr + 1'd1;
                           end
                    else bullet_up_addr <= bullet_up_addr + 10'd0;                       // do nothing
                
                ICON_LEFT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd120;     // reset bullet address
                 else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd7)) && 
                    (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     // output bullet left data
                           bullet_left_addr <= bullet_left_addr - 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 10'd0;                      // do nothing
                
                ICON_RIGHT:   
                 if ((y == y_tank2) && (x == x_tank2)) bullet_left_addr <= 7'd0;       // reset bullet address
                 else if ((y >= y_bullet1 ) && ( y <= (y_bullet1 + 10'd7)) && 
                    (x >= x_bullet1 ) && ( x <= (x_bullet1 + 10'd14)))
                       begin            
                           first_screen_out <= bullet_left_dataOut;                     // output bullet right data
                           bullet_left_addr <= bullet_left_addr + 1'd1;
                       end
                else bullet_left_addr <= bullet_left_addr + 10'd0;                      // do nothing
            endcase
        end
    else begin
            bullet_left_addr <= bullet_left_addr;                                       // do nothing
            bullet_up_addr <= bullet_up_addr ;
        end   

//////////////// outputs green bullet info ///////////////////////////////////////////////////////////////////////////           
    if (green_bullet_act == 1'd1)
                begin
                    case (green_bullet_orient)
                   
                        ICON_UP:   
                         if ((y == y_tank2) && (x == x_tank2)) greenbullet_down_addr <= 7'd120;    // reset bullet address
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd14)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;                                 // output bullet up data
                                   greenbullet_down_addr <= greenbullet_down_addr - 1'd1;
                               end
                        else greenbullet_down_addr <= greenbullet_down_addr + 10'd0;                        // do nothing
                        
                        ICON_DOWN:   
                         if ((y == y_tank2) && (x == x_tank2)) greenbullet_down_addr <= 7'd0;      // reset bullet address
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd14)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd7)))
                               begin            
                                   first_screen_out <= bullet_down_dataOut;
                                   greenbullet_down_addr <= greenbullet_down_addr + 1'd1;                   // output bullet down data
                               end
                        else greenbullet_down_addr <= greenbullet_down_addr + 10'd0;                        // do nothing
                        
                        ICON_LEFT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd120;        // reset bullet address
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd7)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                                // output bullet left data
                                   bullet_right_addr <= bullet_right_addr - 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr;                                        // do nothing
                        
                        ICON_RIGHT:   
                         if ((y == y_tank2) && (x == x_tank2)) bullet_right_addr <= 7'd0;          // reset bullet address
                         else if ((y >= y_bullet2 ) && ( y <= (y_bullet2 + 10'd7)) && 
                            (x >= x_bullet2 ) && ( x <= (x_bullet2 + 10'd14)))
                               begin            
                                   first_screen_out <= bullet_right_dataOut;                                // output bullet right data
                                   bullet_right_addr <= bullet_right_addr + 1'd1;
                               end
                        else bullet_right_addr <= bullet_right_addr + 10'd0;                            
    // do nothing
                    endcase
                end
            else begin
                    bullet_right_addr <= bullet_right_addr;                                                 // do nothing
                    greenbullet_down_addr <=greenbullet_down_addr ;
                end  
end

//////////////////////////// red tank and bullet location ///////////////////////////////////////////////////////////////
always@(posedge clk25) begin
	if (reset)
		begin
			y_tank1 <= 10'd60;                   // reset red tank location  
			x_tank1 <= 10'd60;

		end
	
	else if ( explosion_flag >= 1'd1)                  // if explosion set, reset red tank location
	   begin
	       red_explosion_ack <= 1'd1;                  // used to reset explosion flag
	       y_tank1 <= 10'd60;                  // reset red tank location  
           x_tank1 <= 10'd60;
           
	   end
	else if ( rDout_first != 12'd4095 && (y >= y_tank1 ) && ( y <= (y_tank1 + 10'd31)) && 
                                          (x >= x_tank1 ) && ( x <= (x_tank1 + 10'd31)))
                     begin
                          red_stop <= 1'd1;             // if at wall stop the movement of tank
                      end
	else if ((flag > 0) )          // changing red tank location when button pushed and flag is set high
		begin
			if (red_stop == 1'd0)                    
                begin
                    case (player1)         // change tank location if buttons pressed
                        UP:		y_tank1 <= y_tank1 - 1'd1;             
                        DOWN:	y_tank1 <= y_tank1 + 1'd1;
                        LEFT:	x_tank1 <= x_tank1 - 1'd1;
                        RIGHT:	x_tank1 <= x_tank1 + 1'd1;
                        default:	begin
                                        x_tank1 <= x_tank1;
                                        y_tank1 <= y_tank1;
                                    end
			         endcase
			    end
			else if (red_stop >= 1'd1)       // stop is set high, reverse 1 location and clear the stop
			     begin
			     red_stop <= 1'd0;           // clear the stop flag
			         case (player1)
                         UP:        y_tank1 <= y_tank1 + 1'd1;             
                         DOWN:      y_tank1 <= y_tank1 - 1'd1;
                         LEFT:      x_tank1 <= x_tank1 + 1'd1;
                         RIGHT:     x_tank1 <= x_tank1 - 1'd1;
                         default:    begin
                                         x_tank1 <= x_tank1;
                                         y_tank1 <= y_tank1;
                                     end
                      endcase
			     end
			else begin
			         y_tank1 <= y_tank1;
                     x_tank1 <= x_tank1;
                     red_stop <= 1'd0;
			     end
		
	   end
	                    
	else
		begin
			y_tank1 <= y_tank1;
			x_tank1 <= x_tank1;
			red_explosion_ack <= 1'd0;                   // clear acknowledge flag
		end
////////////////////// changes red bullet location ////////////////////////////////////////////////	
	if (reset)
		begin
			red_bullet_act <= 0;
			x_bullet1 <= 10'd0;                    // reset bullet location
			y_bullet1 <= 10'd0;
		end
    else if (explosion_flag >= 1'd1)                    // if hit opposing player, reset bullet location
        begin 
           red_explosion_ack <= 1'd1;                    
           x_bullet1 <= 10'd0;
           y_bullet1 <= 10'd0;
        end 	
	else if (player1[4] == 1'd1)                          // fire button hit
		begin
			red_bullet_act <= 1'd1;                          //  activate bullet
			x_bullet1 <= x_tank1 + 4'd15;      //  assign starting bullet location
			y_bullet1 <= y_tank1 + 4'd15;
		end
	else if ((red_bullet_act == 1'd1) && (bullet_flag > 0))    // only increment bullet location if flag is high and is active
		begin
			case (red_bullet_orient)         // increment X Y location based on orientation 
				ICON_UP:			y_bullet1 <= y_bullet1 - 1'd1;	
				ICON_DOWN:		    y_bullet1 <= y_bullet1 + 1'd1;
				ICON_LEFT:		    x_bullet1 <= x_bullet1 - 1'd1;
				ICON_RIGHT:		   x_bullet1 <= x_bullet1 + 1'd1;
				default:	begin
								    x_bullet1 <= x_bullet1;
								    y_bullet1 <= y_bullet1;
							end
			endcase
		end
	else if ((rDout_first != 12'd4095) && ( y == (y_bullet1 + 10'd4)) && // if bullet hits wall
				 ( x == (x_bullet1 + 10'd7)))
			begin
				red_bullet_act <= 1'd0;                     // deactivate bullet and reset location
				x_bullet1 <= 10'd0;
                y_bullet1 <= 10'd0;
			end
	else if ((y_bullet1 >= y_tank2) && ( y_bullet1 <= (y_tank2+ 10'd31)) &&    // if bullet hits opposing player
            (x_bullet1 >= x_tank2) && ( x_bullet1 <= (x_tank2+ 10'd31)))
                 red_bullet_act <= 1'd0;   		           // deactivate bullet
	else begin
			x_bullet1 <= x_bullet1;
			y_bullet1 <= y_bullet1;
			red_explosion_ack <= 1'd0;
		end
end


//////////////////////////////////// green tank and bullet location //////////////////////////////////////////
always @ (posedge clk25)
    begin		
	if (reset)
                begin
                    y_tank2 <= 10'd560;             // reset green tank starting location
                    x_tank2 <= 10'd560;         
                end
            else if (explosion_flag >= 1'd1)                // if tank hit reset starting location
               begin 
                    green_explosion_ack <= 1'd1;                  
                   y_tank2 <= 10'd560;
                   x_tank2 <= 10'd560;
                   
               end 
               
///////////////////// if at wall move back to tank back to original position ///////////////////////////////
            else if (rDout_first != 12'd4095 &&  (y >= y_tank2 ) && ( y <= (y_tank2 + 10'd31)) && 
                           (x >= x_tank2 ) && ( x <= (x_tank2 + 10'd31)))
                     begin
                        green_stop <= 1'd1;             // stop tank from moving if at wall
                     end  
            else if (flag > 0)              // changing green tank location when button pushed
                begin
                    if (green_stop == 1'd0)
                        begin
                            case (player2)
                                UP:         y_tank2 <= y_tank2 - 1'd1;
                                DOWN:       y_tank2 <= y_tank2 + 1'd1;
                                LEFT:       x_tank2 <= x_tank2 - 1'd1;
                                RIGHT:      x_tank2 <= x_tank2 + 1'd1;
                                default:    begin
                                                x_tank2 <= x_tank2;
                                                y_tank2 <= y_tank2;
                                            end
                            endcase
                        end
                        
                    else if (green_stop >= 1'd1) // if at wall
                        begin
                            green_stop <= 1'd0;
                            case (player2)           // decrease 1 location 
                                UP:         y_tank2 <= y_tank2 + 1'd1;
                                DOWN:       y_tank2 <= y_tank2 - 1'd1;
                                LEFT:       x_tank2 <= x_tank2 + 1'd1;
                                RIGHT:      x_tank2 <= x_tank2 - 1'd1;
                                default:    begin
                                                x_tank2 <= x_tank2;
                                                y_tank2 <= y_tank2;
                                            end
                            endcase
                        end
                    else begin
                            x_tank2 <= x_tank2;
                            y_tank2 <= y_tank2;
                            green_stop <= 1'd0;
                         end
                end
             
            else
                begin
                    y_tank2 <= y_tank2;
                    x_tank2 <= x_tank2;
                    green_explosion_ack <= 1'd0;                    // reset explosion acknowledge
                    
                end

///////////////////////////////// green tank bullet update ///////////////////////////////////////////           
            if (reset)
                begin
                    green_bullet_act <= 0;                          // reset bullet if reset button pressed
                    x_bullet2 <= 10'd0;
                    y_bullet2 <= 10'd0;
                end
            else if (explosion_flag >= 1'd1)                        // if tank hit, reset bullet location
                begin   
                   green_explosion_ack <= 1'd1;                  
                   x_bullet2 <= 10'd0;
                   y_bullet2 <= 10'd0;
                end   
            else if (player2[4] == 1'd1)   // fire bullet button pressed
                begin
                    green_bullet_act <= 1'd1;                       // activate green bullet
                    x_bullet2 <= x_tank2 + 4'd15;   // assign bullet starting location
                    y_bullet2 <= y_tank2 + 4'd15;
                end
            else if ((green_bullet_act == 1'd1) && (bullet_flag > 0)) // if bullet active and flag is set, change green bullet location
                begin
                    case (green_bullet_orient)
                        ICON_UP:            y_bullet2 <= y_bullet2 - 1'd1;    
                        ICON_DOWN:          y_bullet2 <= y_bullet2 + 1'd1;
                        ICON_LEFT:          x_bullet2 <= x_bullet2 - 1'd1;
                        ICON_RIGHT:         x_bullet2 <= x_bullet2 + 1'd1;
                        default:    begin
                                        x_bullet2 <= x_bullet2;
                                        y_bullet2 <= y_bullet2;
                                    end
                    endcase
                end
            else if ((rDout_first != 12'd4095) && ( y == (y_bullet2 + 10'd4)) && // bullet hits wall
                        ( x == (x_bullet2 + 10'd7)))
                    begin
                        green_bullet_act <= 1'd0;                       // deactivate bullet
                        x_bullet2 <= 10'd0;                     // reset bullet location
                        y_bullet2 <= 10'd0;
                    end
           else if ((y_bullet2 >= y_tank1) && ( y_bullet2 <= (y_tank1+ 10'd31)) && 
                    (x_bullet2 >= x_tank1) && ( x_bullet2 <= (x_tank1+ 10'd31)))
                         green_bullet_act <= 1'd0;                      // deactivat bullet if bullet hits opposing player        
            else begin
                    x_bullet2 <= x_bullet2;
                    y_bullet2 <= y_bullet2;
                    green_explosion_ack <= 1'd0;
                end
end	


/////////////////// Flags are used to control the speed of incrementing tanks and bullet movement ////////////////////////////////
always@(posedge clk25) begin
	if (reset)
		begin
			flag_count <= 0;
			flag <= 1'd0;
		end

//////////////////////////// counter for tank movement ////////////////////////	
	else if (flag_count == FLAG_CNT)
		begin
			flag <= 1'd1;
			flag_count <= 0;
		end
	else 
		begin
			flag_count <= flag_count + 1;
			flag <= 1'd0;
		end

//////////////////////////// counter for bullet movement ////////////////////////			
	if (reset)
		begin
			bullet_count <= 0;
			bullet_flag <= 1'd0;
		end
	else if (bullet_count == BULLET_CNT)
		begin
			bullet_flag <= 1'd1;
			bullet_count <= 0;
		end
	else 
		begin
			bullet_count <= bullet_count + 1;
			bullet_flag <= 1'd0;
		end
		
   
end
endmodule