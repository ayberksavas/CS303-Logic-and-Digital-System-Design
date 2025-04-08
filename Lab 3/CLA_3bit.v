module CLA_3bit (
  input  [2:0] C,     
  input  [2:0] D,     
  input        Cin,   
  output [2:0] RES,   
  output       Carry  
);
  wire [2:0] P, G;
  wire [2:0] Carry_internal; // Renamed internal carry wire

  // Generate and propagate signals
  assign P = C ^ D; 
  assign G = C & D; 

  // Carry signals
  assign Carry_internal[0] = Cin;
  assign Carry_internal[1] = G[0] | (P[0] & Carry_internal[0]);
  assign Carry_internal[2] = G[1] | (P[1] & Carry_internal[1]);

  // Final carry
  assign Carry = G[2] | (P[2] & Carry_internal[2]);

  // Sum
  assign RES = P ^ Carry_internal;
endmodule
