// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module top (
  input        clk,          // Main clock input
  input  [3:0] sw,           // Switches for X and Y coordinates
  input  [3:0] btn,          // Buttons: btn[0] - rst, btn[1] - start, btn[2] - pAb, btn[3] - pBb
  output [7:0] led,          // LEDs for status and feedback
  output [7:0] seven,        // Seven-segment display segments
  output [3:0] segment       // Seven-segment display anodes
);

  
  wire clock;
  wire [3:0] button;         
  wire [7:0] seven0, seven1, seven2, seven3; // Four digits to be displayed on the 7-segment display

  
  clk_divider clock_divider (
      .clk_in(clk),
      .divided_clk(clock)
  );


  debouncer debouncer_0 (
      .clk(clock),
      .rst(1'b0),
      .noisy_in(btn[0]),
      .clean_out(button[0])
  );
  
  debouncer debouncer_1 (
      .clk(clock),
      .rst(1'b0),
      .noisy_in(btn[1]),
      .clean_out(button[1])
  );

  debouncer debouncer_2 (
      .clk(clock),
      .rst(1'b0),
      .noisy_in(btn[2]),
      .clean_out(button[2])
  );

  debouncer debouncer_3 (
      .clk(clock),
      .rst(1'b0),
      .noisy_in(btn[3]),
      .clean_out(button[3])
  );


  ssd seven_segment_display (
      .clk(clk),
      .disp0(seven0),
      .disp1(seven1),
      .disp2(seven2),
      .disp3(seven3),
      .seven(seven),
      .segment(segment)
  );


  battleship main_battleship (
      .clk(clk),
      .rst(button[2]),       // Reset signal
      .start(button[1]),     // Start button
      .X(sw[3:2]),           // X coordinate (from switches)
      .Y(sw[1:0]),           // Y coordinate (from switches)
      .pAb(button[3]),       // Player A's button
      .pBb(button[0]),       // Player B's button
      .disp0(seven0),        // Display output for 1st digit
      .disp1(seven1),        // Display output for 2nd digit
      .disp2(seven2),        // Display output for 3rd digit
      .disp3(seven3),        // Display output for 4th digit
      .led(led)              // LED outputs for game status
  );

endmodule





