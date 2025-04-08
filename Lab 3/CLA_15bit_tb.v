module CLA_15bit_tb ();
reg  signed [14:0] A, B; // Declare as signed for handling negative values
reg         mode;        // mode (add or subtract)
wire signed [14:0] S;    // Declare as signed for result
wire        Ovf;         // Overflow
wire        Cout;        // Carry-out

  CLA_15bit_top dut (A, B, mode, S, Cout, Ovf);

  initial begin
    // Save the waveform under this file.
    $dumpfile("CLA_15bit_top.vcd");

    // Get the variables from the module.
    $dumpvars(0, CLA_15bit_tb);

    $display("Simulation started.");

    A = 15'd0;  // Set all inputs to zero.
    B = 15'd0;
    mode = 1'd0;
    #10;     // Wait 10 time units.
    A = 15'd25;
    B = 15'd50;
    mode = 1'd0; // For addition
    #10;     // Wait 10 time units.
    A = 15'd30;
    B = 15'd100;
    mode = 1'd1; // For subtraction
    #10;     // Wait 10 time units.

    // Addition without a carry and with an overflow
    A = 15'd16383; 
    B = 15'd2; 
    mode = 1'd0; 
    #10;

    // Addition with a carry and without an overflow
    A = 15'd63; 
    B = 15'd63; 
    mode = 1'd0; 
    #10;

    // Addition with a carry and with an overflow
    A = 15'd16383; 
    B = 15'd1; 
    mode = 1'd0; 
    #10;

    // Subtraction without a carry and without an overflow
    A = 15'd30; 
    B = 15'd100; 
    mode = 1'd1; 
    #10;

    // Subtraction without a carry and with an overflow
    A = 15'd16383; 
    B = -15'd16384; 
    mode = 1'd1; 
    #10;

    // Subtraction with a carry and without an overflow
    A = 15'd63; 
    B = 15'd31; 
    mode = 1'd1; 
    #10;

    // Subtraction with a carry and with an overflow
    A = -15'd16384; 
    B = 15'd1; 
    mode = 1'd1; 
    #10;

    $display("Simulation finished.");
    $finish(); // Finish simulation.
  end
endmodule
