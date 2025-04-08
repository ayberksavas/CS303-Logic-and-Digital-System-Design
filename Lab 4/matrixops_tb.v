module matrixops_tb ();

  //Ports
  reg        clk  ;
  reg        rst  ;
  reg        enter;
  reg  [1:0] X    ;
  reg  [1:0] Y    ;
  wire       Z    ;

  matrixops dut (
    .clk  (clk  ),
    .rst  (rst  ),
    .enter(enter),
    .X    (X    ),
    .Y    (Y    ),
    .Z    (Z    )
  );

  // Half period of our clock signal
  parameter HP = 5;
  // Full period of our clock signal
  parameter FP = (2*HP);

  // For generating the clock signal
  always #HP clk = ~clk;

  initial begin
    //  * Our waveform is saved under this file.
    $dumpfile("matrixops_tb.vcd");

    // * Get the variables from the module.
    $dumpvars(0,matrixops_tb);

    $display("Simulation started.");

    clk = 1;
    rst = 1;
    X = 0;
    Y = 0;
    enter = 0;
    #(FP-1);
     // To avoid race conditions, modify inputs prior to the clock edge
//this one should not be present int the case 6 so we need to make it a comment to run it exactly
    
    rst = 0;
    X = 0;
    Y = 0;
    enter = 1;
    #FP;
  /*  

    //Case 0 Testbench

    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b11;
    enter = 1;
    #FP;

    X = 2'b11;
    Y = 2'b11;
    enter = 1;
    #FP;

    X = 2'b00;
    Y = 2'b10;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;
    
    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b10;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b10;
    enter=0;
    #FP;

 
     //Case 1 Testbench
  
    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;
    
    X = 2'b10;
    Y = 2'b00;
    enter = 0;
    #FP;


    //Case 2 Testbench

    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b11;
    enter = 1;
    #FP;

    X = 2'b11;
    Y = 2'b10;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;
    
    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;

    
    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    
    X = 2'b00;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter=0;
    #FP;


  
    //Case 3 Testbench

    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    X = 2'b00;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b11;
    enter = 1;
    #FP;

    X = 2'b11;
    Y = 2'b10;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;
    
    X = 2'b01;
    Y = 2'b01;
    enter = 0;
    #FP;

    rst = 1;
    X = 2'b00;
    Y = 2'b00;
    enter = 0;
    #FP;

    rst = 0;
    X = 2'b00;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter = 1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter=0;
    #FP;
  


    //Case 4 Testbench

    X = 2'b00;
    Y = 2'b00;
    enter=1;
    #FP;

    X = 2'b00;
    Y = 2'b01;
    enter=1;
    #FP;

    X = 2'b10;
    Y = 2'b11;
    enter=1;
    #FP;

    X = 2'b11;
    Y = 2'b10;
    enter=1;
    #FP;

    X = 2'b01;
    Y = 2'b00;
    enter=1;
    #FP;

    X = 2'b10;
    Y = 2'b10;
    enter=1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter=1;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter=0;
    #FP;

    X = 2'b01;
    Y = 2'b01;
    enter=0;
    #FP;

    X = 2'b00;
    Y = 2'b00;
    enter=0;
    #FP;
    
    X = 2'b00;
    Y = 2'b00;
    enter=1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter=1;
    #FP;

    X = 2'b10;
    Y = 2'b00;
    enter=0;
    #FP;
    

*/
    //Case 5 Testbench

X = 2'b0;
Y = 2'b00;
enter=1;
#FP;

X = 2'b00;
Y = 2'b01;
enter=1;
#FP;

X = 2'b10;
Y = 2'b11;
enter=1;
#FP;

X = 2'b01;
Y = 2'b01;
enter=0;
#FP;

X = 2'b11;
Y = 2'b10;
enter=1;
#FP;

X = 2'b01;
Y = 2'b00;
enter=1;
#FP;

X = 2'b10;
Y = 2'b10;
enter=1;
#FP;

X = 2'b01;
Y = 2'b01;
enter=1;
#FP;

X = 2'b01;
Y = 2'b01;
enter=0;
#FP;

X = 2'b01;
Y = 2'b01;
enter=0;
#FP;

X = 2'b00;
Y = 2'b00;
enter=0;
#FP;

X = 2'b00;
Y = 2'b00;
enter=1;
#FP;

X = 2'b10;
Y = 2'b00;
enter=1;
#FP;

X = 2'b10;
Y = 2'b00;
enter=0;
#FP;


    
    //Case 6 Testbench

/*
rst = 0;
X = 0;
Y = 0;
enter = 0;
#HP;

rst = 0;
X = 0;
Y = 0;
enter = 1;
#HP;

rst = 0;
X = 0;
Y = 1;
enter = 0;
#HP;

rst = 0;
X = 0;
Y = 2;
enter = 0;
#FP;

rst = 0;
X = 0;
Y = 2;
enter = 1;

rst = 0;
X = 2;
Y = 2;
enter = 0;
#FP;

rst = 0;
X = 2;
Y = 3;
enter = 0;
#FP;

rst = 0;
X = 3;
Y = 3;
enter = 1;
#FP;

rst = 0;
X = 3;
Y = 2;
enter = 1;
#FP;

rst = 0;
X = 3;
Y = 0;
enter = 1;
#FP;

rst = 0;
X = 3;
Y = 0;
enter = 1;
#FP;

rst = 0;
X = 1;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 1;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 1;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 1;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 1;
Y = 1;
enter = 0;
#FP;

rst = 0;
X = 1;
Y = 1;
enter = 0;
#FP;

rst = 0;
X = 0;
Y = 0;
enter = 0;
#FP;

rst = 0;
X = 0;
Y = 0;
enter = 0;
#FP;

rst = 0;
X = 0;
Y = 0;
enter = 0;
#FP;

rst = 0;
X = 0;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 0;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 0;
Y = 1;
enter = 1;
#FP;

rst = 0;
X = 3;
Y = 3;
enter = 1;
#FP;

rst = 1;
X = 3;
Y = 3;
enter = 0;
#HP;

rst = 1;
X = 1;
Y = 0;
enter = 0;
#FP;

rst = 1;
X = 2;
Y = 0;
enter = 0;
#FP;

rst = 1;
X = 2;
Y = 0;
enter=0;
#FP;

    
*/
    $display("Simulation finished.");
    $finish(); // Finish simulation.
  end

endmodule