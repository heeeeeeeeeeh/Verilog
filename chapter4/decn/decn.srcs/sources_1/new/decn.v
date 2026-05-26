`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 09:14:25 AM
// Design Name: 
// Module Name: decn
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decn (
    W,
    E,
    Y
);
  parameter integer N = 4;
  input [N-1:0] W;
  input E;
  output reg [0:2**N-1] Y;
  integer i;

  always @(W, E) for (i = 0; i < 2 ** N; i = i + 1) Y[i] = E & (W == i);

endmodule
