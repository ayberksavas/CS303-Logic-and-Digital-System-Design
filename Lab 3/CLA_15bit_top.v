module CLA_15bit_top (
  input  [14:0] A   ,
  input  [14:0] B   ,
  input         mode, // 0 --> addition , 1 --> subtraction
  output [14:0] S   ,
  output        Cout,
  output        OVF
);
  wire [14:0] B_mode;
  wire Cin = mode;
  wire [4:0] Carry;

  // An always block to handle B_mode
  reg [14:0] B_mode_reg;
  assign B_mode = B_mode_reg;

  always @(*) 
  begin
    if (mode == 1)
      B_mode_reg = ~B; // Flip B bits for subtraction
    else
      B_mode_reg = B;
  end

  // Five 3-bit CLA modules with updated port names
  CLA_3bit cla0 (.C(A[2:0]),   .D(B_mode[2:0]),   .Cin(Cin),      .RES(S[2:0]),   .Carry(Carry[0]));
  CLA_3bit cla1 (.C(A[5:3]),   .D(B_mode[5:3]),   .Cin(Carry[0]), .RES(S[5:3]),   .Carry(Carry[1]));
  CLA_3bit cla2 (.C(A[8:6]),   .D(B_mode[8:6]),   .Cin(Carry[1]), .RES(S[8:6]),   .Carry(Carry[2]));
  CLA_3bit cla3 (.C(A[11:9]),  .D(B_mode[11:9]),  .Cin(Carry[2]), .RES(S[11:9]),  .Carry(Carry[3]));
  CLA_3bit cla4 (.C(A[14:12]), .D(B_mode[14:12]), .Cin(Carry[3]), .RES(S[14:12]), .Carry(Carry[4]));

  // Final carry-out
  assign Cout = Carry[4];

  // Overflow detection: If the carry into the MSB != carry out of MSB
  assign OVF = (A[14] ^ S[14]) & (B_mode[14] ^ S[14]);

endmodule
