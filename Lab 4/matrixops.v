module matrixops (
  input            clk  ,
  input            rst  ,
  input            enter,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  output reg       Z
);

reg read_phase_2;
reg [1:0] current_X, current_Y;

// 1D array for matrix elements (16 elements total)
reg [15:0] mat;

reg is_active;I
reg [2:0] counter;

always @(posedge clk or posedge rst) begin
  //IDLE
  if (rst) begin
    // Reset all matrix elements
    mat <= 16'b0; // Reset all elements at once

    // Reset control variables
    read_phase_2 <= 0;
    Z <= 0;
    is_active <= 0;
    counter <= 0; // Decimal value
    current_X <= 0; // Decimal value
    current_Y <= 0; // Decimal value
  end else begin
    //Reading Phase 2
    if (read_phase_2) begin
      // Calculate the index and read the matrix element
      Z <= mat[{current_X, current_Y}]; // Combine X and Y to form the index
      read_phase_2 <= 0;
    end

    if (enter) begin
      if (!is_active) begin
        // WRITING PHASE
        is_active <= 1;
        counter <= 0;
      end else if (counter < 5) begin
        mat[{X, Y}] <= 1; // Combine X and Y to form the index
        counter <= counter + 1;
      end else begin
        //READING PHASE 1
        current_X <= X;
        current_Y <= Y;
        read_phase_2 <= 1;
      end
    end
  end
end

endmodule