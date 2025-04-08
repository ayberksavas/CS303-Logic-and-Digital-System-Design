// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */



// Parameters
parameter timerLimit = 30000000;  // for clock cycle
parameter SHIP_COUNT = 4;   // total ship each player should deploy
parameter WIN_SCORE = 4;   // Score they need to get in order to win

// States
parameter IDLE = 4'd0;
parameter SHOW_A = 4'd1;
parameter A_IN = 4'd2;
parameter ERROR_A = 4'd3;
parameter SHOW_B = 4'd4;
parameter B_IN = 4'd5;
parameter ERROR_B = 4'd6;
parameter SHOW_SCORE = 4'd7;
parameter A_SHOOT = 4'd8;
parameter A_SINK = 4'd9;
parameter A_WIN = 4'd10;
parameter B_SHOOT = 4'd11;
parameter B_SINK = 4'd12;
parameter B_WIN = 4'd13;
parameter A_WAIT_RELEASE = 4'd14;
parameter B_WAIT_RELEASE = 4'd15;



// Numbers displayed on FPGAs
parameter [7:0] SEG_0 = 8'b00111111; // display 0
parameter [7:0] SEG_1 = 8'b00000110; // display 1
parameter [7:0] SEG_2 = 8'b01011011; // display 2
parameter [7:0] SEG_3 = 8'b01001111; // display 3
parameter [7:0] SEG_4 = 8'b01100110; // display 4

// Letters displayed on FPGAs
parameter [7:0] SEG_A = 8'b01110111;  //display A
parameter [7:0] SEG_b = 8'b01111100;  //display b
parameter [7:0] SEG_E = 8'b01111001;  //display E
parameter [7:0] SEG_r = 8'b01010000;  //display r
parameter [7:0] SEG_o = 8'b01011100;  //display o
parameter [7:0] SEG_D = 8'b01011110;  //display D
parameter [7:0] SEG_L = 8'b00111000;  //display L
parameter [7:0] SEG_I = 8'b00000110;  //display I
parameter [7:0] SEG_dash = 8'b01000000; //display '-'
parameter [7:0] SEG_blank = 8'b00000000;  // empty

//LEDS displayed
parameter [7:0] ALL_LEDS_ON = 8'b11111111;  // turn on all leds
parameter [7:0] ALL_LEDS_OFF = 8'b00000000; // turn off all leds
parameter [7:0] seven_four_three_zero = 8'b10011001;  // turn on leds 7, 4, 3, 0

reg [3:0] current_state;  // current state
reg [15:0] shipA_map;   // A's map
reg [15:0] shipB_map;   // B's map
reg [2:0] A_ship_count;   //A's number of ships
reg [2:0] B_ship_count;   //B's number of ship
reg [2:0] A_score;  // counts A's score
reg [2:0] B_score;  // counts B's score




reg [31:0] timer_cnt; // counter for  given clock cyle(In this module,it is reseted at 3. In other modules where divider and clock_bouncer used, it is reseted at 50)
reg led_blink_state;  // checks if all leds are turned on or turned off
reg [3:0] blink_count;  // Counter for LED blink cycles
reg Z;  // used for lighting leds in case of A_SINK or B_SINK

// 0 = no winner, 1 = A winner, 2 = B winner (it is not used in FPGA but it is used to test the code from test_bench)
reg [1:0] winner;

//used to display scores and deployed ship inputs on player's respected leds(5-4 for A and 3-2 for B). Used during writing cases under alway(*) block
reg [7:0] dX;
reg [7:0] dY;
reg [7:0] dAscore;
reg [7:0] dBscore;

//State transitions are written here
always @(posedge clk or posedge rst)
begin
  if (rst)
  begin
    current_state <= IDLE;
    shipA_map <= 16'b0;
    shipB_map <= 16'b0;
    A_ship_count <= 0;
    B_ship_count <= 0;
    A_score <= 0;
    B_score <= 0;
    timer_cnt <= 0;
    led_blink_state<= 0;
    winner <= 0;
  end
  else
  begin

    case (current_state)
      IDLE:
      begin
        if (start == 0)
        begin
          current_state <= IDLE;
        end
        else
        begin
          current_state <= SHOW_A;
        end
      end


      SHOW_A:
      begin
        if (timer_cnt < timerLimit)
        begin
          current_state <= SHOW_A;
          timer_cnt <= timer_cnt + 1;
        end
        else
        begin
          timer_cnt <= 0;
          current_state <= A_IN;
        end
      end


      A_IN:
      begin
        // Only act when pAb == 1
        // If pAb is still 0, do nothing; remain in A_IN.
        if (pAb == 1)
        begin
          // 1) Check if this cell is already occupied by a ship
          if (shipA_map[(4*X) + Y] == 1)
          begin
            // Occupied => go to ERROR_A
            timer_cnt <= 0;
            current_state <= ERROR_A;
          end
          else
          begin
            // 2) If not occupied, place the ship on A’s map
            shipA_map[(4*X) + Y] <= 1;
            A_ship_count <= A_ship_count + 1;

            // 3) If we have placed all ships, move to SHOW_B
            if (A_ship_count+1==SHIP_COUNT)
            begin
              // A has placed all ships
              current_state <= SHOW_B;
            end
            else
            begin
              // Still need more ships, but we want to wait for the
              // user to release the button before placing again:
              current_state <= A_WAIT_RELEASE;
            end
          end
        end
        else
        begin
          // pAb is 0 => do nothing and remain here
          current_state <= A_IN;
        end
      end
      A_WAIT_RELEASE:
      begin
        // We wait here until the user has released pAb
        if (pAb == 0)
        begin
          // If we still have not placed all ships, go back to A_IN
          // so the user can place the next ship.
          current_state <= A_IN;
        end
        else
        begin
          // pAb is still 1 => stay in this state
          current_state <= A_WAIT_RELEASE;
        end
      end



      ERROR_A:
      begin
        if (timer_cnt < timerLimit)
        begin
          timer_cnt <= timer_cnt + 1;
          current_state <= ERROR_A;
        end
        else
        begin
          timer_cnt <= 0;

          current_state <= A_WAIT_RELEASE;
        end
      end




      B_IN:
      begin
        // Only act when pBb == 1 (button pressed)
        if (pBb == 1)
        begin
          // 1) Check if this cell is already occupied by a ship
          if (shipB_map[(4*X) + Y] == 1)
          begin
            // Occupied => go to ERROR_B
            timer_cnt <= 0;
            current_state <= ERROR_B;
          end
          else
          begin
            // 2) If not occupied, place the ship on B’s map
            shipB_map[(4*X) + Y] <= 1;
            B_ship_count <= B_ship_count + 1;

            // 3) If all ships are placed, move to SHOW_SCORE
            if (B_ship_count+1== SHIP_COUNT)
            begin
              // B has placed all ships
              current_state <= SHOW_SCORE;
            end
            else
            begin
              // Still need more ships, wait for button release before next placement
              current_state <= B_WAIT_RELEASE;
            end
          end
        end
        else
        begin
          // pBb is 0 => do nothing and remain in B_IN
          current_state <= B_IN;
        end
      end
      B_WAIT_RELEASE:
      begin
        // Wait until the user releases the pBb button
        if (pBb == 0)
        begin
          // If more ships need to be placed, go back to B_IN
          current_state <= B_IN;
        end
        else
        begin
          // Button is still pressed; remain in B_WAIT_RELEASE
          current_state <= B_WAIT_RELEASE;
        end
      end



      ERROR_B:
      begin
        if(timer_cnt < timerLimit)
        begin
          timer_cnt <= timer_cnt + 1;
          current_state <= ERROR_B;
        end
        else
        begin
          timer_cnt <= 0;

          current_state <= B_WAIT_RELEASE;
        end
      end




      SHOW_SCORE:
      begin
        timer_cnt <= 0;
        if(timer_cnt < timerLimit)
        begin
          current_state <= SHOW_SCORE;
          timer_cnt <= timer_cnt + 1;
        end
        else
        begin
          timer_cnt <= 0;
          current_state <= A_SHOOT;
        end
      end


      A_SHOOT:
      begin
        if (pAb == 0)
        begin
          current_state <= A_SHOOT;
        end
        else
        begin
          if (shipB_map[(4*X)+Y] == 1)
          begin
            Z<=1;
            shipB_map[(4*X)+Y] <= 0;
            A_score <= A_score + 1;
            current_state <= A_SINK;
          end
          else
          begin
            Z<=0;
            A_score <= A_score;
            current_state <= A_SINK;
          end
        end
      end


      B_SHOOT:
      begin
        if (pBb == 0)
        begin
          current_state <= B_SHOOT;
        end
        else
        begin
          if (shipA_map[(4*X)+Y] == 1)
          begin
            Z<=1;
            shipA_map[(4*X)+Y] <= 0;
            B_score <= B_score + 1;
            current_state <= B_SINK;
          end
          else
          begin
            Z<=0;
            B_score <= B_score;
            current_state <= B_SINK;
          end
        end
      end


      A_WIN:
      begin
        if (blink_count < 8)  // Blink 4 times
        begin
          if (timer_cnt < timerLimit)
            timer_cnt <= timer_cnt + 1;
          else
          begin
            timer_cnt <= 0;
            led_blink_state <= ~led_blink_state;
            blink_count <= blink_count + 1;
          end
        end
        else
        begin
          led_blink_state <= 0;
        end
      end


      B_WIN:
      begin
        if (blink_count < 8)  // Blink 4 times
        begin
          if (timer_cnt < timerLimit)
            timer_cnt <= timer_cnt + 1;
          else
          begin
            timer_cnt <= 0;
            led_blink_state <= ~led_blink_state;
            blink_count <= blink_count + 1;
          end
        end
        else
        begin
          led_blink_state <= 0;
        end
      end


      SHOW_B:
      begin
        if (timer_cnt < timerLimit)
        begin
          current_state <= SHOW_B;
          timer_cnt <= timer_cnt + 1;
        end
        else
        begin
          timer_cnt <= 0;
          current_state <= B_IN;
        end
      end

      A_SINK:
      begin
        if(timer_cnt < timerLimit)
        begin
          timer_cnt <= timer_cnt + 1;

        end
        else
        begin
          timer_cnt <= 0;
          if(A_score == WIN_SCORE)
          begin
            blink_count <= 0;
            current_state <= A_WIN;
          end
          else
            current_state <= B_SHOOT;
        end
      end

      B_SINK:
      begin
        if(timer_cnt < timerLimit)
        begin
          timer_cnt <= timer_cnt + 1;

        end
        else
        begin

          timer_cnt <= 0;
          if(B_score == WIN_SCORE)
          begin
            blink_count <= 0;
            current_state <= B_WIN;
          end
          else
            current_state <= A_SHOOT;
        end
      end


    endcase
  end
end

// Outputs are written here
always @(*)
begin

  disp0 = SEG_blank;
  disp1 = SEG_blank;
  disp2 = SEG_blank;
  disp3 = SEG_blank;
  led   = ALL_LEDS_OFF;


  case (X)
    2'b00:
      dX = SEG_0;
    2'b01:
      dX = SEG_1;
    2'b10:
      dX = SEG_2;
    default:
      dX = SEG_3;
  endcase

  case (Y)
    2'b00:
      dY = SEG_0;
    2'b01:
      dY = SEG_1;
    2'b10:
      dY = SEG_2;
    default:
      dY = SEG_3;
  endcase


  case (A_score)
    3'd0:
      dAscore = SEG_0;
    3'd1:
      dAscore = SEG_1;
    3'd2:
      dAscore = SEG_2;
    3'd3:
      dAscore = SEG_3;
    default:
      dAscore = SEG_4;
  endcase


  case (B_score)
    3'd0:
      dBscore = SEG_0;
    3'd1:
      dBscore = SEG_1;
    3'd2:
      dBscore = SEG_2;
    3'd3:
      dBscore = SEG_3;
    default:
      dBscore = SEG_4;
  endcase


  case (current_state)
    IDLE:
    begin
      //IDLE
      disp3 = SEG_I;
      disp2 = SEG_D;
      disp1 = SEG_L;
      disp0 = SEG_E;
      led   = seven_four_three_zero;
    end

    SHOW_A:
    begin
      //A
      disp3 = SEG_A;
      led[7] = 1;
    end

    A_IN:
    begin
      //coordinates X and Y for A
      disp1 = dX;
      disp0 = dY;
      led[7] = 1;
      led[5] = A_ship_count[1];
      led[4] = A_ship_count[0];
    end

    ERROR_A:
    begin
      //Erro
      disp3 = SEG_E;
      disp2 = SEG_r;
      disp1 = SEG_r;
      disp0 = SEG_o;
      led   = seven_four_three_zero;
    end

    SHOW_B:
    begin
      //b
      disp3 = SEG_b;
      led[0] = 1;
    end

    B_IN:
    begin
      //coordinates X and Y
      disp1 = dX;
      disp0 = dY;
      led[0] = 1;
      led[3] = B_ship_count[1];
      led[2] = B_ship_count[0];
    end

    ERROR_B:
    begin
      //Erro
      disp3 = SEG_E;
      disp2 = SEG_r;
      disp1 = SEG_r;
      disp0 = SEG_o;
      led   = seven_four_three_zero;
    end

    SHOW_SCORE:
    begin
      // 0 - 0
      disp2 = SEG_0;
      disp1 = SEG_dash;
      disp0 = SEG_0;
      led   = seven_four_three_zero;
    end

    A_SHOOT:
    begin
      //coordinates X and Y
      disp1 = dX;
      disp0 = dY;
      led[7] = 1;
      // Scores
      led[5] = A_score[1];
      led[4] = A_score[0];
      led[3] = B_score[1];
      led[2] = B_score[0];
    end

    A_SINK:
    begin
      // Display score
      disp2 = dAscore;
      disp1 = SEG_dash;
      disp0 = dBscore;

      if(Z==1)
        led = ALL_LEDS_ON;
      else
        led = ALL_LEDS_OFF;
    end

    A_WIN:
    begin
      // A and score
      disp3 = SEG_A;
      disp2 = dAscore;
      disp1 = SEG_dash;
      disp0 = dBscore;
      // LED blink state
      if (led_blink_state)
        led = ALL_LEDS_ON;
      else
        led = ALL_LEDS_OFF;
    end

    B_SHOOT:
    begin
      //coordinates X and Y
      disp1 = dX;
      disp0 = dY;
      led[0] = 1;
      // Scores
      led[5] = A_score[1];
      led[4] = A_score[0];
      led[3] = B_score[1];
      led[2] = B_score[0];
    end

    B_SINK:
    begin
      // Display score
      disp2 = dAscore;
      disp1 = SEG_dash;
      disp0 = dBscore;

      // Turn all LEDs on
      if(Z==1)
        led = ALL_LEDS_ON;
      else
        led = ALL_LEDS_OFF;
    end

    B_WIN:
    begin
      // b and score
      disp3 = SEG_b;
      disp2 = dAscore;
      disp1 = SEG_dash;
      disp0 = dBscore;
      // LED blink state
      if (led_blink_state)
        led = ALL_LEDS_ON;
      else
        led = ALL_LEDS_OFF;
    end

    default:
    begin
      disp0 = SEG_blank;
      disp1 = SEG_blank;
      disp2 = SEG_blank;
      disp3 = SEG_blank;
      led   = ALL_LEDS_OFF;
    end
  endcase
end

endmodule